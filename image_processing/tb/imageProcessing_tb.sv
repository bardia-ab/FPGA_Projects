`timescale 1ns / 1ps
`define headerSize 1080
`define imgSize 512*512

module imageProcessing_tb();

  localparam PERIOD = 10;

  logic axi_clk = 1'b0;
  logic axi_rst_n;
  logic [7:0] imgData;
  logic imgDataValid = 1'b0;
  integer i;
  integer file_in, file_out, file2;
  integer sentSize;
  logic intr;
  logic outDataValid;
  logic [7:0] outData;
  integer receivedData = 0;

  imageProcessingTop  dut (
    .axi_clk(axi_clk),
    .axi_reset_n(axi_rst_n),
    .i_data_valid(imgDataValid),
    .i_data(imgData),
    .o_data_ready(),
    .o_data_valid(outDataValid),
    .o_data(outData),
    .i_data_ready(1'b1),
    .o_intr(intr)
  );

  // clock
  always #(PERIOD/2) axi_clk = ~axi_clk;

  // reset
  initial begin
    sentSize = 0;

    axi_rst_n = 0;
    #100;
    axi_rst_n = 1;
    #100;

    // read image
    file_in = $fopen("C:/Users/t26607bb/Desktop/Practice/Embedded/SpatialFilter/tb/lena_gray.bmp", "rb");
    file_out = $fopen("C:/Users/t26607bb/Desktop/Practice/Embedded/SpatialFilter/tb/blurred_lena2.bmp", "wb");
    file2 = $fopen("C:/Users/t26607bb/Desktop/Practice/Embedded/SpatialFilter/tb/imageData.h", "w");

    // write header
    for (i=0; i<`headerSize; i=i+1) begin
      $fscanf(file_in, "%c", imgData);
      $fwrite(file_out, "%c", imgData);
    end

    // read 4 lines
    for (i=0; i<4*512; i++) begin
      @(posedge axi_clk);
      $fscanf(file_in, "%c", imgData);
      $fwrite(file2, "%0d,", imgData);
      imgDataValid = 1'b1;
    end
    sentSize = 4 * 512;

    @(posedge axi_clk);
    imgDataValid = 1'b0;

   // read line by line
    while(sentSize < `imgSize) begin
      @(posedge intr);
      for (i=0; i<512; i++) begin
        @(posedge axi_clk);
        $fscanf(file_in, "%c", imgData);
        $fwrite(file2, "%0d,", imgData);
        imgDataValid = 1'b1;
      end
      sentSize += 512;
      @(posedge axi_clk);
      imgDataValid = 1'b0;
    end

    // read first dummy row
    @(posedge intr);
    for (i=0; i<512; i++) begin
      @(posedge axi_clk);
      imgData = 0;
      imgDataValid = 1'b1;
      $fwrite(file2, "%0d,", 0);
    end
    @(posedge axi_clk);
    imgDataValid = 1'b0;

    // read second dummy row
    @(posedge intr);
    for (i=0; i<512; i++) begin
      @(posedge axi_clk);
      imgData = 0;
      imgDataValid = 1'b1;
      $fwrite(file2, "%0d,", 0);
    end
    @(posedge axi_clk);
    imgDataValid = 1'b0;

    $fclose(file_in);
    $fclose(file2);
  end

  // write output image
  always @(posedge axi_clk) begin
    if (outDataValid) begin
      $fwrite(file_out, "%c", outData);
      receivedData += 1;
    end

    if (receivedData == `imgSize) begin
      $fclose(file_out);
      $stop;
    end

  end


endmodule

// `timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////////////////////
// // Company: 
// // Engineer: 
// // 
// // Create Date: 04/02/2020 08:11:41 PM
// // Design Name: 
// // Module Name: tb
// // Project Name: 
// // Target Devices: 
// // Tool Versions: 
// // Description: 
// // 
// // Dependencies: 
// // 
// // Revision:
// // Revision 0.01 - File Created
// // Additional Comments:
// // 
// //////////////////////////////////////////////////////////////////////////////////

// `define headerSize 1080
// `define imageSize 512*512

// module imageProcessing_tb(

//     );
    
 
//  reg clk;
//  reg reset;
//  reg [7:0] imgData;
//  integer file,file1,i;
//  reg imgDataValid;
//  integer sentSize;
//  wire intr;
//  wire [7:0] outData;
//  wire outDataValid;
//  integer receivedData=0;

//  initial
//  begin
//     clk = 1'b0;
//     forever
//     begin
//         #5 clk = ~clk;
//     end
//  end
 
//  initial
//  begin
//     reset = 0;
//     sentSize = 0;
//     imgDataValid = 0;
//     #100;
//     reset = 1;
//     #100;
//     file = $fopen("C:/Users/t26607bb/Desktop/Practice/Embedded/SpatialFilter/tb/lena_gray.bmp","rb");
//     file1 = $fopen("C:/Users/t26607bb/Desktop/Practice/Embedded/SpatialFilter/tb/blurred_lena.bmp","wb");
//     for(i=0;i<`headerSize;i=i+1)
//     begin
//         $fscanf(file,"%c",imgData);
//         $display("%c\n", imgData);
//         $fwrite(file1,"%c",imgData);
//     end
    
//     for(i=0;i<4*512;i=i+1)
//     begin
//         @(posedge clk);
//         $fscanf(file,"%c",imgData);
//         imgDataValid <= 1'b1;
//     end
//     sentSize = 4*512;
//     @(posedge clk);
//     imgDataValid <= 1'b0;
//     while(sentSize < `imageSize)
//     begin
//         @(posedge intr);
//         for(i=0;i<512;i=i+1)
//         begin
//             @(posedge clk);
//             $fscanf(file,"%c",imgData);
//             imgDataValid <= 1'b1;    
//         end
//         @(posedge clk);
//         imgDataValid <= 1'b0;
//         sentSize = sentSize+512;
//     end
//     @(posedge clk);
//     imgDataValid <= 1'b0;
//     @(posedge intr);
//     for(i=0;i<512;i=i+1)
//     begin
//         @(posedge clk);
//         imgData <= 0;
//         imgDataValid <= 1'b1;    
//     end
//     @(posedge clk);
//     imgDataValid <= 1'b0;
//     @(posedge intr);
//     for(i=0;i<512;i=i+1)
//     begin
//         @(posedge clk);
//         imgData <= 0;
//         imgDataValid <= 1'b1;    
//     end
//     @(posedge clk);
//     imgDataValid <= 1'b0;
//     $fclose(file);
//  end
 
//  always @(posedge clk)
//  begin
//      if(outDataValid)
//      begin
//          $fwrite(file1,"%c",outData);
//          receivedData = receivedData+1;
//      end 
//      if(receivedData == `imageSize)
//      begin
//         $fclose(file1);
//         $stop;
//      end
//  end
 
// imageProcessingTop  dut (
//     .axi_clk(clk),
//     .axi_rst_n(reset),
//     .i_data_valid(imgDataValid),
//     .i_data(imgData),
//     .o_data_ready(),
//     .o_data_valid(outDataValid),
//     .o_data(outData),
//     .i_data_ready(1'b1),
//     .o_intr(intr)
//   );
    
// endmodule