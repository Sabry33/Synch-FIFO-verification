package scoreboard_pkg ;
import FIFO_TRAN::*;
import sharedpkg::*;

class FIFO_scoreboard ;

FIFO_transaction fifo_tr_scrbrd = new ();
parameter FIFO_WIDTH = 16 ;
parameter FIFO_DEPTH = 8 ;
int count ;
 
bit [FIFO_WIDTH-1:0]  data_out_ref ;
bit wr_ack_ref, overflow_ref;
bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

bit [6:0] scrbrd_out_flags ;
bit [6:0] dut_out_flags ;
bit [FIFO_WIDTH-1:0] data_q[$] ;


function comb_flags_calc ;
full_ref = ( count == FIFO_DEPTH) ? 1 : 0;
empty_ref = ( count == 0) ? 1 : 0;
almostfull_ref = (count == FIFO_DEPTH - 1) ? 1 : 0;
almostempty_ref = (count == 1) ? 1 : 0;
endfunction

function reference_model ( FIFO_transaction gold_model) ;

fork
 begin 

if(!gold_model.rst_n) begin 
wr_ack_ref =0 ;
overflow_ref =0;
data_q.delete();
full_ref = 0 ;
almostfull_ref = 0 ; 
end
else if (gold_model.wr_en && count<FIFO_DEPTH ) 
begin 
    data_q.push_back(gold_model.data_in);
    wr_ack_ref =1;
end
else begin 
    wr_ack_ref = 0 ;
    if (full_ref && gold_model.wr_en)
		overflow_ref = 1;
	else
		overflow_ref = 0;
end
end 

begin 
    if(!gold_model.rst_n) begin 
    data_out_ref = 0;
    underflow_ref =0; 
    empty_ref = 0 ;
    almostempty_ref = 0 ; 
    end
    else if (gold_model.rd_en && count != 0)
    data_out_ref = data_q.pop_front();
    else begin 
    if (empty_ref && gold_model.rd_en)
    underflow_ref = 1 ;
    else 
    underflow_ref = 0 ;
    end
end

join
if(!gold_model.rst_n)  
    count = 0 ;
else begin
if	( ({gold_model.wr_en, gold_model.rd_en} == 2'b10) && !full_ref) 
	count = count + 1;
else if ( ({gold_model.wr_en, gold_model.rd_en} == 2'b01) && !empty_ref)
	count = count - 1;
else if (({gold_model.wr_en, gold_model.rd_en} == 2'b11) && empty_ref)
    count = count + 1;
else if (({gold_model.wr_en, gold_model.rd_en} == 2'b11) && full_ref)
		    count = count - 1;				
end
comb_flags_calc();
endfunction

function check_data ( FIFO_transaction fifo_tr_scrbrd) ;
reference_model(fifo_tr_scrbrd);
scrbrd_out_flags ={wr_ack_ref,overflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref} ;
dut_out_flags ={fifo_tr_scrbrd.wr_ack,fifo_tr_scrbrd.overflow,fifo_tr_scrbrd.full,fifo_tr_scrbrd.empty,fifo_tr_scrbrd.almostfull,fifo_tr_scrbrd.almostempty,fifo_tr_scrbrd.underflow} ;

if (fifo_tr_scrbrd.data_out !== data_out_ref) begin
$display ("time %0t the output of the design and golden model are not equal",$time);
error_cntr++ ;
end
if (dut_out_flags !== scrbrd_out_flags) begin
$display ("time %0t the output flags of the design and golden model are not equal",$time);
error_cntr++ ;
end
if (fifo_tr_scrbrd.data_out == data_out_ref && dut_out_flags == scrbrd_out_flags ) begin 
  $display ("time %0t Succedded comarison with data = %0p",$time,data_q);
correct_cntr++ ;  
end
endfunction
endclass
endpackage