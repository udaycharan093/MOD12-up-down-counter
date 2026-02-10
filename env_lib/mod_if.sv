
interface mod_if(input bit clock);
   
   logic rst;
   logic load;
   logic updown;
   logic [3:0] d_in;
   logic [3:0] d_out;

   //Write Driver clocking block
   clocking wr_drv_cb@(posedge clock);
      default input #1 output #1;
      output load;
      output updown;
      output d_in;
      output rst;
   endclocking: wr_drv_cb

   //Write monitor clocking block
   clocking wr_mon_cb@(posedge clock);
      default input #1 output #1;
      input load;
      input updown;
      input d_in;
      input rst;
   endclocking: wr_mon_cb
   
   //Read monitor clocking block
   clocking rd_mon_cb@(posedge clock);
      default input #1 output #1;
      input d_out;
   endclocking: rd_mon_cb

   //Write Driver modport
   modport WR_DRV_MP (clocking wr_drv_cb);

   //Write Monitor modport
   modport WR_MON_MP (clocking wr_mon_cb);

   //Read Monitor modport
   modport RD_MON_MP (clocking rd_mon_cb);
    

endinterface: mod_if

