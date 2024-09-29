import sharedpkg::*;
import FIFO_TRAN::*;
module FIFO_TB(fifo_interface.TB f_if) ;

FIFO_transaction f_tr_tb ;

parameter mixedOps = 10000 ;


logic [FIFO_WIDTH-1:0] data_in,data_out;

logic  wr_ack, overflow;
logic  full, empty, almostfull, almostempty, underflow;
initial 
begin 
f_tr_tb =new();
//repeat(2) @(negedge f_if.clk);
f_if.rst_n = 0 ;
#10;
f_if.rst_n =1 ;

for (int i=0; i<mixedOps; i=i+1) begin 
 assert(f_tr_tb.randomize());
 f_if.rst_n   = f_tr_tb.rst_n   ;
 f_if.wr_en   = f_tr_tb.wr_en   ;
 f_if.rd_en   = f_tr_tb.rd_en   ;
 f_if.data_in = f_tr_tb.data_in ;
 @(negedge f_if.clk);
end
test_finished = 1;
end

endmodule