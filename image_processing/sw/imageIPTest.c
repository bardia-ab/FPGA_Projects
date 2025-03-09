#include "xil_exception.h"
#include "xscugic.h"
#include "xaxidma.h"
#include "xuartps.h"
#include "xparameters.h"
#include "imageData.h"

#define BaudRate 115200
#define HeaderSize 1080
#define ImageSize (512 * 512)
#define FileSize (HeaderSize + ImageSize)
#define LineSize 512
#define FourLineSize (4 * LineSize)
#define MM2S_DMASR 0x04

XScuGic GicInst;
volatile int DmaReceiveDone = 0;

int init_DMA(XAxiDma * InstancePtr, u32 DeviceId);
s32 init_UART(XUartPs *InstancePtr, u16 DeviceId);
s32 init_GIC(XScuGic *InstancePtr, u16 DeviceId);
void init_exeption(u32 Exception_id, void *ExceptionHandler, void *Data);
u32 checkIdle(u32 BaseAddress, u32 offset);
static void ImageProcessingISR(void *CallBackRef);
static void DmaReceiveISR(void *CallBackRef);

int main() {
	s32 status;
	XAxiDma DmaInst;
	XUartPs UartInst;
	int NumSentBytes;
	int TotalNumSentBytes = 0;

	/**************** DMA Init *******************/
	status = init_DMA(&DmaInst, XPAR_AXI_DMA_0_DEVICE_ID);
	if (status != XST_SUCCESS) {
		print("DMA Initialization Failed!\n\r");
		return -1;
	}

	/**************** UART Init *******************/
	status = init_UART(&UartInst, XPAR_PS7_UART_1_DEVICE_ID);
	if (status != XST_SUCCESS) {
		print("UART Initialization Failed!\n\r");
		return -1;
	}

	// Set baud rate
	status = XUartPs_SetBaudRate(&UartInst, BaudRate);
	if (status != XST_SUCCESS) {
		print("Setting Baud Rate Failed!\n\r");
		return -1;
	}

	/**************** GIC Init *******************/
	status = init_GIC(&GicInst, XPAR_PS7_SCUGIC_0_DEVICE_ID);
	if (status != XST_SUCCESS) {
		print("GIC Init Failed!\n\r");
		return -1;
	}

	init_exeption(XIL_EXCEPTION_ID_IRQ_INT, XScuGic_InterruptHandler, &GicInst);

	/**************** Enable Interrupts *******************/
	// enable DMA interrupt
	XAxiDma_IntrEnable(&DmaInst, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);

	// set priority of interrupts
	XScuGic_SetPriorityTriggerType(&GicInst, XPAR_FABRIC_IMAGEPROCESSING_0_O_INTR_INTR, 0xA0, 3);
	XScuGic_SetPriorityTriggerType(&GicInst, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, 0xA1, 3);

	// connect interrupt ID of the source with its ISR
	status = XScuGic_Connect(&GicInst, XPAR_FABRIC_IMAGEPROCESSING_0_O_INTR_INTR, ImageProcessingISR, &DmaInst);
	if (status != XST_SUCCESS) {
		print("ImageProcessingISR Connection Failed\n\r!");
		return -1;
	}

	status = XScuGic_Connect(&GicInst, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, DmaReceiveISR, &DmaInst);
	if (status != XST_SUCCESS) {
		print("DmaReceiveISR Connection Failed\n\r!");
		return -1;
	}

	// enable Interrupts at GIC level
	XScuGic_Enable(&GicInst, XPAR_FABRIC_IMAGEPROCESSING_0_O_INTR_INTR);
	XScuGic_Enable(&GicInst, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);

	/**************** DMA Transfer *******************/
	status = XAxiDma_SimpleTransfer(&DmaInst, (u32)imageData, ImageSize, XAXIDMA_DEVICE_TO_DMA);
	if (status != XST_SUCCESS) {
		print("DMA Receive Failed!\n\r");
		return -1;
	}

	status = XAxiDma_SimpleTransfer(&DmaInst, (u32)imageData, FourLineSize, XAXIDMA_DMA_TO_DEVICE);
	if (status != XST_SUCCESS) {
		print("DMA Transfer Failed!\n\r");
		return -1;
	}

	// wait until DMA is done
	while(!DmaReceiveDone);

	/**************** UART Transfer to PC *******************/
	while (TotalNumSentBytes < ImageSize) {
		NumSentBytes = XUartPs_Send(&UartInst, (u8 *)&imageData[TotalNumSentBytes], 1);
		TotalNumSentBytes += NumSentBytes;
	}


	return 0;
}

int init_DMA(XAxiDma * InstancePtr, u32 DeviceId) {
	int status;
	XAxiDma_Config * DMAConfig = XAxiDma_LookupConfig(DeviceId);
	status = XAxiDma_CfgInitialize(InstancePtr, DMAConfig);
	return status;
}


s32 init_UART(XUartPs *InstancePtr, u16 DeviceId) {
	s32 status;
	XUartPs_Config *UARTConfig;
	UARTConfig = XUartPs_LookupConfig(DeviceId);
	status = XUartPs_CfgInitialize(InstancePtr, UARTConfig, UARTConfig->BaseAddress);

	return status;
}

s32 init_GIC(XScuGic *InstancePtr, u16 DeviceId) {
	s32 status;
	XScuGic_Config *GicConfig;
	GicConfig = XScuGic_LookupConfig(DeviceId);
	status = XScuGic_CfgInitialize(InstancePtr, GicConfig, GicConfig->CpuBaseAddress);

	return status;
}

void init_exeption(u32 Exception_id, void *ExceptionHandler, void *Data) {
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(Exception_id, (Xil_ExceptionHandler)ExceptionHandler, Data);
	Xil_ExceptionEnable();
}

u32 checkIdle(u32 BaseAddress, u32 offset) {
	u32 status = XAxiDma_ReadReg(BaseAddress, offset) & XAXIDMA_IDLE_MASK;
	return status;
}

static void ImageProcessingISR(void *CallBackRef) {
	static int i = 4;
	int status;

	XScuGic_Disable(&GicInst, XPAR_FABRIC_IMAGEPROCESSING_0_O_INTR_INTR);

	status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, MM2S_DMASR);
	while (status == 0)
		status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x04);

	if (i < 514) {
		status = XAxiDma_SimpleTransfer((XAxiDma *)CallBackRef, (u32)&imageData[512 * i], LineSize, XAXIDMA_DMA_TO_DEVICE);
		i++;
	}

	XScuGic_Enable(&GicInst, XPAR_FABRIC_IMAGEPROCESSING_0_O_INTR_INTR);
}

static void DmaReceiveISR(void *CallBackRef) {
	XAxiDma_IntrDisable((XAxiDma *)CallBackRef, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);

	XAxiDma_IntrAckIrq((XAxiDma *)CallBackRef, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);
	DmaReceiveDone = 1;

	XAxiDma_IntrEnable((XAxiDma *)CallBackRef, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);
}
