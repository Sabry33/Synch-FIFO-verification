import scoreboard_pkg::*;
import FIFO_TRAN::*;
import func_pkg::*;
import sharedpkg::*;

module fifo_monitor (fifo_interface.MONITOR f_if);
FIFO_transaction f_tr ;
FIFO_scoreboard  f_sb ;
FIFO_coverage    f_cg ;

initial
begin  
f_tr =new();
f_sb =new();
f_cg =new();

forever
begin
    @(negedge f_if.clk);
    f_tr.data_in       = f_if.data_in;
    f_tr.data_out      = f_if.data_out;
    f_tr.wr_en         = f_if.wr_en;
    f_tr.rd_en         = f_if.rd_en;
    f_tr.wr_ack        = f_if.wr_ack;
    f_tr.overflow      = f_if.overflow;
    f_tr.full          = f_if.full;
    f_tr.empty         = f_if.empty;
    f_tr.almostfull    = f_if.almostfull;
    f_tr.almostempty   = f_if.almostempty;
    f_tr.underflow     = f_if.underflow;
    f_tr.rst_n         = f_if.rst_n;

    fork
      begin 
      f_cg.sample_data(f_tr) ;
      end

      begin 
        @(posedge f_if.clk) ;
        #3;
       f_sb.check_data(f_tr);
      end
    join
    
    if (test_finished) begin 
         $display("Test finished at time %0t", $time);
        $display("Summary: %0d correct comparisons, %0d errors.",correct_cntr,error_cntr);
        $stop ;
    end
end

end



endmodule