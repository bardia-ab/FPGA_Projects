#include "xaxivdma.h"
#include "xil_exception.h"
#include "xscugic.h"
#include "xparameters.h"
#include "xil_cache.h"
#include "sleep.h"
#include "imageData.h"

#define Width 1920
#define Height 1080
#define FrameSize (Height * Width * 3)
#define ImageWidth 512
#define ImageHeight 512

int init_VDMA(XAxiVdma *InstancePtr, u16 DeviceId);
int config_VDMA(XAxiVdma *InstancePtr, XAxiVdma_DmaSetup MM2SConfig, u8 *FrameBufferAddress);
void set_colorbar(u8 *FrameBuffer);
s32 setup_interrupt(XScuGic *GicInstPtr, u16 GicDeviceId, u32 Int_Id, XAxiVdma *VdmaInstPtr);
static void VDMA_CompletionCallBack(void *CallBackRef, u32 Mask);
static void VDMA_ErrorCallBack(void *CallBackRef, u32 Mask);
void draw_image(int dispWidth, int dispHeight, int imgWidth, int imgHeight, char *imgData);

XScuGic GicInst;

u8 FrameBuffer[FrameSize];

int main() {
	int status;
	XAxiVdma VdmaInst;
	XAxiVdma_DmaSetup MM2SConfig;

	/**************** VDMA Init ******************/
	status = init_VDMA(&VdmaInst, XPAR_AXI_VDMA_0_DEVICE_ID);
	if (status != XST_SUCCESS)
		return -1;

	status = config_VDMA(&VdmaInst, MM2SConfig, FrameBuffer);
	if (status != XST_SUCCESS)
		return -1;

	/**************** Color Bar ******************/
	//set_colorbar(FrameBuffer);
	draw_image(Width, Height, ImageWidth, ImageHeight, imageData);

	/**************** Setup Interrupt ******************/
	XAxiVdma_IntrEnable(&VdmaInst, XAXIVDMA_IXR_COMPLETION_MASK | XAXIVDMA_IXR_ERROR_MASK, XAXIVDMA_READ);
	status = setup_interrupt(&GicInst, XPAR_PS7_SCUGIC_0_DEVICE_ID, XPAR_FABRIC_AXI_VDMA_0_MM2S_INTROUT_INTR, &VdmaInst);
	if (status != XST_SUCCESS)
		return -1;

	Xil_DCacheFlush();
	status = XAxiVdma_DmaStart(&VdmaInst, XAXIVDMA_READ);
	if (status != XST_SUCCESS) {
		print("Starting DMA Channel Failed!\n\r");
		return -1;
	}

	while(1);

	return 0;
}

int init_VDMA(XAxiVdma *InstancePtr, u16 DeviceId) {
	int status;
	XAxiVdma_Config *VdmaConfig = XAxiVdma_LookupConfig(DeviceId);
	status = XAxiVdma_CfgInitialize(InstancePtr, VdmaConfig, VdmaConfig->BaseAddress);
	if (status != XST_SUCCESS) {
		print("VDMA Initialization Failed!\n\r");
		return XST_FAILURE;
	}

	return status;
}

int config_VDMA(XAxiVdma *InstancePtr, XAxiVdma_DmaSetup MM2SConfig, u8 *FrameBufferAddress) {
	int status;

	MM2SConfig.VertSizeInput = Height;
	MM2SConfig.HoriSizeInput = Width * 3;
	MM2SConfig.Stride = Width * 3;
	MM2SConfig.FrameStoreStartAddr[0] = (u32)FrameBufferAddress;
	MM2SConfig.FrameDelay = 0;
	MM2SConfig.EnableCircularBuf = 1;
	MM2SConfig.EnableSync = 1;
	MM2SConfig.PointNum = 0;
	MM2SConfig.EnableFrameCounter = 0;
	MM2SConfig.FixedFrameStoreAddr = 0;

	status = XAxiVdma_DmaConfig(InstancePtr, XAXIVDMA_READ, &MM2SConfig);
	if (status != XST_SUCCESS) {
		print("DMA Channel Configuration Failed!\n\r");
		return XST_FAILURE;
	}

	status = XAxiVdma_DmaSetBufferAddr(InstancePtr, XAXIVDMA_READ, MM2SConfig.FrameStoreStartAddr);
	if (status != XST_SUCCESS) {
		print("DMA Buffer Address Configuration Failed!\n\r");
		return XST_FAILURE;
	}

	return status;
}

void set_colorbar(u8 *FrameBuffer) {
	for (int r = 0; r < Height; r++)
		for (int c = 0; c < Width; c++) {
			int idx = r * Width * 3 + c * 3;
			if (c < Width/3) {
				FrameBuffer[idx] = 0xff;
				FrameBuffer[idx + 1] = 0x00;
				FrameBuffer[idx + 2] = 0x00;
			}
			else if (c < 2 * Width / 3) {
				FrameBuffer[idx] = 0x00;
				FrameBuffer[idx + 1] = 0xff;
				FrameBuffer[idx + 2] = 0x00;
			}
			else {
				FrameBuffer[idx] = 0x00;
				FrameBuffer[idx + 1] = 0x00;
				FrameBuffer[idx + 2] = 0xff;
			}
		}
}

s32 setup_interrupt(XScuGic *GicInstPtr, u16 GicDeviceId, u32 Int_Id, XAxiVdma *VdmaInstPtr) {
	s32 status;

	// Init GIC
	XScuGic_Config *GicConfig = XScuGic_LookupConfig(GicDeviceId);
	status = XScuGic_CfgInitialize(GicInstPtr, GicConfig, GicConfig->CpuBaseAddress);
	if (status != XST_SUCCESS) {
		print("GIC Initialization Failed!\n\r");
		return XST_FAILURE;
	}

	// Connect ISR and Enable Interrupt at GIC level
	XScuGic_Connect(GicInstPtr, Int_Id, (Xil_InterruptHandler)XAxiVdma_ReadIntrHandler, VdmaInstPtr);
	if (status != XST_SUCCESS) {
		print("ISR Connection Failed!\n\r");
		return XST_FAILURE;
	}

	XScuGic_Enable(GicInstPtr, Int_Id);

	// Enable Interrupts at CPU level
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, GicInstPtr);
	Xil_ExceptionEnable();

	status = XAxiVdma_SetCallBack(VdmaInstPtr, XAXIVDMA_HANDLER_GENERAL, VDMA_CompletionCallBack, VdmaInstPtr, XAXIVDMA_READ);
	if (status != XST_SUCCESS) {
		print("Setting Completion CallBack Failed!\n\r");
		return XST_FAILURE;
	}

	status = XAxiVdma_SetCallBack(VdmaInstPtr, XAXIVDMA_HANDLER_ERROR, VDMA_ErrorCallBack, VdmaInstPtr, XAXIVDMA_READ);
	if (status != XST_SUCCESS) {
		print("Setting Error CallBack Failed!\n\r");
		return XST_FAILURE;
	}

	return status;
}

static void VDMA_CompletionCallBack(void *CallBackRef, u32 Mask) {
	static u8 pixelValue = 0x00;
	if (Mask & XAXIVDMA_IXR_COMPLETION_MASK)
		print("VDMA Frame Completed!\n\r");

	/*pixelValue = ~pixelValue;
	memset(FrameBuffer, pixelValue, FrameSize);
	Xil_DCacheFlush();
	sleep(1);*/
}

static void VDMA_ErrorCallBack(void *CallBackRef, u32 Mask) {
	if (Mask & XAXIVDMA_IXR_ERROR_MASK)
			print("VDMA Error Detected!\n\r");
}

void draw_image(int dispWidth, int dispHeight, int imgWidth, int imgHeight, char *imgData) {
	int VertOffset = (dispHeight - imgHeight) / 2;
	int HorOffset = (dispWidth - imgWidth) / 2;
	int idx;

	for (int r = 0; r < dispHeight; r++)
		for (int c = 0; c < dispWidth; c++) {
			idx = r * dispWidth * 3 + c * 3;

			if (c < HorOffset || c >= imgWidth + HorOffset) {
				FrameBuffer[idx] = 0x00;
				FrameBuffer[idx + 1] = 0x00;
				FrameBuffer[idx + 2] = 0x00;
			}
			else if (r < VertOffset || r >= imgHeight + VertOffset) {
				FrameBuffer[idx] = 0x00;
				FrameBuffer[idx + 1] = 0x00;
				FrameBuffer[idx + 2] = 0x00;
			}
			else {
				/* vga uses 4-bit data for each color while the bmp file uses 8 bits
				 without division by 16, only 4 LSBs are written into FrameBuffer*/
				FrameBuffer[idx] = *imgData / 16;
				FrameBuffer[idx + 1] = *imgData / 16;
				FrameBuffer[idx + 2] = *imgData / 16;
				imgData++;
			}
		}

}

