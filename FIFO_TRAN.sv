package FIFO_TRAN;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

class FIFO_transaction ;

rand bit [FIFO_WIDTH-1:0] data_in;
rand bit  rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0]  data_out ;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

int RD_EN_ON_DIST ;
int WR_EN_ON_DIST ;

function  new (int rd_en_dist = 30 , int wr_en_dist =70);

   this.RD_EN_ON_DIST = rd_en_dist ;
   this.WR_EN_ON_DIST = wr_en_dist ;

endfunction

constraint rst_cnstrs {
  rst_n dist {1:= 98 , 0 :=2 };  //u should make it enabled more than 1 to make it toggle more than one  
}

constraint wr_enble {
  wr_en dist {1:= WR_EN_ON_DIST , 0 := 100-WR_EN_ON_DIST}; 
}

constraint rd_enable {
  rd_en dist {1:= RD_EN_ON_DIST , 0 := 100-RD_EN_ON_DIST}; 
}

endclass 

endpackage