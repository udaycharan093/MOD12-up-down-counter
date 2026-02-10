/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  top.sv   

Description    :  Top for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/
module top();

   //Import ram_pkg
   import mod_pkg::*;   
    
   parameter cycle = 10;
  
   reg clock;   

   //Instantiate the interface
   mod_if DUV_IF(clock);

   test t_h;   
   
   mod12 DUV (.clock(clock), .rst(DUV_IF.rst), .load(DUV_IF.load), .updown(DUV_IF.updown), .d_in(DUV_IF.d_in), .d_out(DUV_IF.d_out));

   //Generate the clock
   initial
      begin
         clock = 1'b0;
         forever #(cycle/2) clock = ~clock;
      end
   
   initial
      begin
	 
	`ifdef VCS
         $fsdbDumpvars(0, top);
        `endif

	//Create the objects for different testcases and pass the interface instances as arguments
         //Call the virtual task build and virtual task run       
         if($test$plusargs("TEST1"))
            begin
               t_h = new(DUV_IF,DUV_IF, DUV_IF);
               number_of_transactions = 2;
               t_h.build();
               t_h.run();
               $finish;
            end 

      end
endmodule
