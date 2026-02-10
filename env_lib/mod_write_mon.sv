/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_write_mon.sv   

Description    :  Monitor for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

***********************************************************************************************/
//In class ram_write_mon

class mod_write_mon;

   //Instantiate virtual interface instance wr_mon_if of type ram_if with WR_MON_MP modport
   virtual mod_if.WR_MON_MP wr_mon_if;

   //Declare two handles 'wrdata' and 'data2rm' of class type ram_trans
   mod_trans wrdata;
   mod_trans data2rm;

   //Declare a mailbox 'mon2rm' parameterized by type ram_trans
   mailbox #(mod_trans) mon2rm;
   
   //In constructor
   //Pass the following as the input arguments  
   //virtual interface 
   //mailbox handle 'mon2rm' parameterized by ram_trans  
   //make the connections and allocate memory for 'wrdata' 

   function new(virtual mod_if.WR_MON_MP wr_mon_if,
                mailbox #(mod_trans) mon2rm);
      this.wr_mon_if = wr_mon_if;
      this.mon2rm    = mon2rm;
      this.wrdata    = new;
   endfunction: new


   virtual task monitor();
      @(wr_mon_if.wr_mon_cb)
      begin
         wrdata.load =  wr_mon_if.wr_mon_cb.load;
         wrdata.updown= wr_mon_if.wr_mon_cb.updown;
	 wrdata.d_in= wr_mon_if.wr_mon_cb.d_in;
	 wrdata.rst = wr_mon_if.wr_mon_cb.rst;
         //call the display of ram_trans to display the monitor data
   //      wrdata.display("DATA FROM WRITE MONITOR");
      
      end
   endtask: monitor
   
   
   //In virtual task start          
   virtual task start();
      //within fork-join_none
      //In forever loop
      fork
         forever
            begin
               //Call the monitor task
               //Understand the provided monitor task
               //Monitor task samples the interface signals 
               //according to the protocol and convert to transaction items 
               monitor(); 
               //shallow copy wrdata to data2rm          
               //Put the transaction item into the mailbox mon2rm
               data2rm = new wrdata;
               mon2rm.put(data2rm);
		data2rm.display("Data From Write Monitor:");
            end
      join_none
   endtask: start

endclass:mod_write_mon
