/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
   
Filename       :  ram_env.sv   

Description    :  Environment class for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/
//In class ram_env

class mod_env;

   //Instantiate virtual interface with Write Driver modport,
   //Read Driver modport,Write monitor modport,Read monitor modport 
   virtual mod_if.WR_DRV_MP wr_drv_if;
//   virtual mod_if.RD_DRV_MP rd_drv_if;
   virtual mod_if.WR_MON_MP wr_mon_if;
   virtual mod_if.RD_MON_MP rd_mon_if; 
   
   //Declare 6 mailboxes parameterized by ram_trans and construct it                                                                         
   mailbox #(mod_trans) gen2wr = new();
//   mailbox #(mod_trans) gen2rd = new();

   mailbox #(mod_trans) wr2rm  = new();
//   mailbox #(mod_trans) rd2rm  = new();

   mailbox #(mod_trans) rd2sb  = new();
   
   mailbox #(mod_trans) rm2sb  = new();
   
   //Create handle for ram_gen,ram_write_drv,ram_read_drv,ram_write_mon,
   //ram_read_mon,ram_model,ram_sb
   mod_gen        gen_h;
   mod_write_drv  wr_drv_h;
//   mod_read_drv   rd_drv_h;
   mod_write_mon  wr_mon_h;
   mod_read_mon   rd_mon_h;
   mod_model      ref_mod_h;
   mod_sb         sb_h;

   //In constructor
   //pass the Driver and monitor interfaces as the argument
   //connect them with the virtual interfaces of ram_env
   function new(virtual mod_if.WR_DRV_MP wr_drv_if,
                virtual mod_if.WR_MON_MP wr_mon_if,
                virtual mod_if.RD_MON_MP rd_mon_if);
      this.wr_drv_if = wr_drv_if;
//      this.rd_drv_if = rd_drv_if;
      this.wr_mon_if = wr_mon_if;
      this.rd_mon_if = rd_mon_if;
   endfunction: new
   
   //In virtual task build
   //construct the handles of generator,Write Driver,Read Driver, 
   //Write monitor,Read monitor,Reference model,Scoreboard
   virtual task build;
      gen_h      = new(gen2wr);
      wr_drv_h   = new(wr_drv_if,gen2wr);
 //     rd_drv_h   = new(rd_drv_if, gen2rd);
      wr_mon_h   = new(wr_mon_if,wr2rm);
      rd_mon_h   = new(rd_mon_if,rd2sb);
      ref_mod_h  = new(wr2rm,rm2sb);
      sb_h       = new(rm2sb,rd2sb);
   endtask: build

   //Understand and include the virtual task reset_dut
   virtual task reset_dut();
      begin
	@(wr_drv_if.wr_drv_cb);
	wr_drv_if.wr_drv_cb.rst <= 1'b1;
	wr_drv_if.wr_drv_cb.load<=0;
	wr_drv_if.wr_drv_cb.updown<=0;
	wr_drv_if.wr_drv_cb.d_in<=0;
//	$display("**********     reset done      *******");
	repeat(5)
	@(wr_drv_if.wr_drv_cb);
//	wr_drv_if.wr_drv_cb.rst <= 1'b0;
//	$display("stop");
      end
   endtask: reset_dut

   //In virtual task start
   //call the start methods of generator,Write Driver,Read Driver
   //Write monitor,Read Monitor,reference model,scoreboard
   virtual task start;
      gen_h.start();
      wr_drv_h.start();
  //    rd_drv_h.start();
      wr_mon_h.start();
      rd_mon_h.start();
      ref_mod_h.start();
      sb_h.start();
   endtask: start

   virtual task stop();
//	$display("waiting for stop");
      wait(sb_h.DONE.triggered);
   endtask: stop 

   //In virtual task run, call reset_dut, start, stop methods & report function from scoreboard
   virtual task run();
      reset_dut();
//	$display("%d",rd_mon_if.rd_mon_cb.d_out);
      start();
//	$display("start done");
      stop();
//	$display("stop done");
      sb_h.report();
   endtask: run

endclass: mod_env

