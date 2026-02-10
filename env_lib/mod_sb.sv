/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_sb.sv   

Description    :  Scoreboard for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

********************************************************************************************/
//In class ram_sb

class mod_sb;
   //Declare an event DONE
   event DONE; 

   //Declare three variables of int datatype for counting
   //number of read data received from the reference model(rm_data_count)
   //number of read data received from the monitor(mon_data_count)
   //number of read data verified(data_verified)
   static int data_verified = 0;
   static int rd_data_count = 0;
   static int ref_data_count = 0;

   //Declare ram_trans handles as 'rm_data','rcvd_data' and cov_data 
   mod_trans rd_data;  
   mod_trans ref_data;
   mod_trans cov_data;
   
   //Declare two mailboxes as 'rm2sb','rdmon2sb' parameterized by ram_trans 
   mailbox #(mod_trans) ref2sb;      //ref model to sb
   mailbox #(mod_trans) rd2sb;   //rdmon to sb
   
   //Write the functional coverage model 
   //Define a covergroup as 'mem_coverage'   
   //Define coverpoint and bins for read, data_out and rd_address
   //Define cross for read,rd_address
   covergroup cg;     
//	option.per_instance=1;
	reset: coverpoint cov_data.rst{
		bins rst={0,1};}
	load: coverpoint cov_data.load{
		bins load={0,1};}
	updown: coverpoint cov_data.updown{
		bins updown={0,1};}
	d_in: coverpoint cov_data.d_in{
		bins d_in = {[0:11]}; }
		/*bins d1 = {0};
		bins d2 = {1}; 
		bins d1 = {2};
		bins d2 = {3}; 
		bins d1 = {4};
		bins d2 = {5}; 
		bins d1 = {6};
		bins d2 = {7}; 
		bins d1 = {8};
		bins d2 = {9}; 
		bins d1 = {10};
		bins d2 = {11}; */      
      
   endgroup : cg
   
   //In constructor
   //pass the mailboxes as arguments
   //make the connections
   //create an instance for the covergroup
   function new(mailbox #(mod_trans) ref2sb,
                mailbox #(mod_trans) rd2sb);
      this.rd2sb    = rd2sb;
      this.ref2sb = ref2sb;
      cg  = new;    
   endfunction: new

   //In virtual task start    
   virtual task start();
      //Within fork join_none, inside begin end
      fork
         forever
            begin
               //Get the data from mailbox rm2sb 
               ref2sb.get(ref_data);
               //Increment rm_data_count
               ref_data_count++;
               //Get the data from mailbox rdmon2sb
               rd2sb.get(rd_data);   
               //Increment mon_data_count
               rd_data_count++;    
               //Call the check task and pass 'rcvd_data' handle as the input argument
               check(rd_data);
            end
      join_none
   endtask: start

   // Understand and include the virtual task check
   virtual task check(mod_trans rc_data);
	begin
      		if(rc_data.d_out == ref_data.d_out) 
         		$display("count matches");
     		else
			$display("count not matching");
        
            cov_data = new rc_data;
	    cg.sample(); 
	
            //Increment data_verified 
            data_verified++;
	end
//	$display("----------- - - - -%d - - - - - ---------%d -------",data_verified,ref_data_count);
            //Trigger the event if the verified data count is equal to the sum of number of read and read-write transactions 
            if(data_verified >= number_of_transactions) 
               begin             
                  ->DONE;
               end
	
   endtask: check

   //In virtual function report 
   //display rm_data_count, mon_data_count, data_verified 
   virtual function void report();
      $display(" ------------------------ SCOREBOARD REPORT ----------------------- \n ");
      $display(" Data Expected = %d", ref_data_count);
      $display(" Data generated = %d",rd_data_count);
      $display(" Data Verified = %d",data_verified); 
      $display(" ------------------------------------------------------------------ \n ");
   endfunction: report
    
endclass: mod_sb
