module ReLU  #(parameter DATA_WIDTH=16, WEIGHT_INT_WIDTH=4) (
    input           i_clk,
    input   [2*DATA_WIDTH-1:0]   i_addr,
    output  reg [DATA_WIDTH-1:0]  o_out
  );


  always_ff @(posedge i_clk)
  begin
    if($signed(i_addr) >= 0)
    begin
      if(|i_addr[2*DATA_WIDTH-1-:WEIGHT_INT_WIDTH+1]) //over flow to sign bit of integer part
        o_out <= {1'b0,{(DATA_WIDTH-1){1'b1}}}; //positive saturate
      else
        o_out <= i_addr[2*DATA_WIDTH-1-WEIGHT_INT_WIDTH-:DATA_WIDTH];
    end
    else
      o_out <= 0;
  end

endmodule

