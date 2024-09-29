interface fifo_interface(clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8; 
input clk ;

logic [FIFO_WIDTH-1:0] data_in,data_out;
logic  rst_n, wr_en, rd_en;
logic  wr_ack, overflow;
logic  full, empty, almostfull, almostempty, underflow;


modport TB (output  rst_n, wr_en, rd_en,data_in,
              input   data_out, wr_ack,overflow , full, empty, almostfull, almostempty, underflow,clk);
              

modport DUT (output  data_out, wr_ack,overflow , full, empty, almostfull, almostempty, underflow, 
             input  clk,rst_n, wr_en, rd_en,data_in) ;


modport MONITOR   (input clk,data_in,data_out,wr_en,rd_en,wr_ack,overflow,full,empty,almostfull,almostempty,underflow,rst_n )  ;


endinterface