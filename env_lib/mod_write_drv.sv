/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_write_drv.sv   

Description    :  Driver class for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/
// In class ram_write_drv

class mod_write_drv;
   // Instantiate virtual interface instance wr_drv_if of type ram_if with WR_DRV_MP modport
   virtual mod_if.WR_DRV_MP wr_drv_if;

   // Declare a handle for ram_trans as 'data2duv' 
   mod_trans data2duv;

   // Declare a mailbox 'gen2wr' parameterized with ram_trans     
   mailbox #(mod_trans) gen2wr;  

   // In constructor 
   // pass the following as the input arguments 
   // virtual interface
   // mailbox handle 'gen2wr' parameterized by ram_trans    
   // make the connections
   // For example this.gen2wr = gen2wr
   function new(virtual mod_if.WR_DRV_MP wr_drv_if,
                mailbox #(mod_trans) gen2wr);
      this.wr_drv_if = wr_drv_if;
      this.gen2wr    = gen2wr;
   endfunction: new

   virtual task drive();
      @(wr_drv_if.wr_drv_cb);
      wr_drv_if.wr_drv_cb.load <= data2duv.load;
      wr_drv_if.wr_drv_cb.updown <= data2duv.updown;
      wr_drv_if.wr_drv_cb.d_in <= data2duv.d_in;
      wr_drv_if.wr_drv_cb.rst <= data2duv.rst;         
   endtask: drive

   // In virtual task start      
   virtual task start();
      // Within fork join_none 
      fork
         forever
            begin
               // Within forever , inside begin end         
               // get the data from mailbox 'gen2wr'
               // call the drive task
               gen2wr.get(data2duv);
               drive();
		data2duv.display("Data From Write Driver");
            end
      join_none
   endtask: start

endclass: mod_write_drv
