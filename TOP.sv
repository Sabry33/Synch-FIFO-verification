module TOP ();

bit clk ;
initial 
begin
    clk =0 ;
    forever  begin 
    #10 ; 
    clk =~clk ;
    end
end

fifo_interface  f_if(clk);
FIFO  DUT   (f_if);
FIFO_TB  TB (f_if);
fifo_monitor  mon(f_if) ;

endmodule