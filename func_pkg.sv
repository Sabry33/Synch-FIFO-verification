package  func_pkg ;
import FIFO_TRAN::*;
class FIFO_coverage ;

FIFO_transaction F_cvg_tx = new();
covergroup cg ;
//////coverpoints for input sigs//////
wr_enable_cvp : coverpoint F_cvg_tx.wr_en{
    bins wr_en0 ={0};
    bins wr_en1 ={1};
    option.weight =0 ;}
rd_enable_cvp : coverpoint F_cvg_tx.wr_en{
    bins rd_en0 ={0};
    bins rd_en1 ={1};
    option.weight =0 ;}

//////coverpoints for output sigs//////
wr_ack_cvp :coverpoint  F_cvg_tx.wr_ack{
    bins wr_ak0 ={0};
    bins wr_ak1 ={1};
    option.weight =0 ;}

overf_cvp :coverpoint  F_cvg_tx.overflow{
    bins overflow0 ={0};
    bins overflow1 ={1};
    option.weight =0 ;}
    
fl_cvp :coverpoint  F_cvg_tx.full{
    bins full0 ={0};
    bins full1 ={1};
    option.weight =0 ;}

mt_cvp :coverpoint  F_cvg_tx.empty{
    bins empty0 ={0};
    bins empty1 ={1};
    option.weight =0 ;}

al_f_cvp :coverpoint  F_cvg_tx.almostfull{
    bins almostfull0 ={0};
    bins almostfull1 ={1};
    option.weight =0 ;}

al_e_cvp :coverpoint  F_cvg_tx.almostempty{
    bins almostempty0 ={0};
    bins almostempty1 ={1};
    option.weight =0 ;}

underf_cvp :coverpoint  F_cvg_tx.underflow{
    bins underflow0 ={0};
    bins underflow1 ={1};
    option.weight =0 ;}

cross wr_enable_cvp,rd_enable_cvp,wr_ack_cvp {
    bins wren_ack  = binsof(wr_enable_cvp.wr_en1) && binsof (wr_ack_cvp.wr_ak1) ;
    bins rden_ack  = binsof(wr_enable_cvp.wr_en1) && binsof (wr_ack_cvp.wr_ak1) && binsof (rd_enable_cvp.rd_en1) ;  //must add wr_en because wr_ack wont be 1 unless wr_en is 1 
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,overf_cvp {
    bins wren_of  = binsof (wr_enable_cvp.wr_en1) && binsof (overf_cvp.overflow1) ;
    bins rden_of =  binsof (rd_enable_cvp.rd_en1) && binsof (overf_cvp.overflow1) ;   //should not happen ???
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,underf_cvp {
    bins wren_uf  = binsof (wr_enable_cvp.wr_en1) && binsof (underf_cvp.underflow1) ; 
    bins rden_uf =  binsof (rd_enable_cvp.rd_en1) && binsof (underf_cvp.underflow1) ;  
    option.cross_auto_bin_max = 0 ; 
}


cross wr_enable_cvp,rd_enable_cvp,fl_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (fl_cvp.full1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (fl_cvp.full1) ;  
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,mt_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (mt_cvp.empty1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (mt_cvp.empty1) ;  
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,al_f_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (al_f_cvp.almostfull1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (al_f_cvp.almostfull1) ;  
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,al_e_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (al_e_cvp.almostempty1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (al_e_cvp.almostempty1) ;  
    option.cross_auto_bin_max = 0 ; 
}

endgroup

function new () ;
  cg = new ();
endfunction



function void  sample_data( FIFO_transaction F_txn); //input is the default 
F_cvg_tx = F_txn  ;
cg.sample();
endfunction

endclass

endpackage