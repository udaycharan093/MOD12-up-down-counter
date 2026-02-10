/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.


Filename       :  ram_model.sv   

Description    :  Reference Model for ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/
// In class ram_model

class mod_model;
   //Declare two handles 'wrmon_data' and 'rdmon_data' for ram_trans
   //(to store the data from the read and write monitor)
   
   mod_trans wrmon_data,con_data;
//   mod_trans rdmon_data;

   //Declare an associative array of 64 bits(logic type) and indexed int type
 
   static logic [3:0] ref_count =0;

   //Declare three mailboxes 'wr2rm','rd2rm' and 'rm2sb' parameterized by ram_trans
   
   mailbox #(mod_trans) wr2rm;
//   mailbox #(mod_trans) rd2rm;
   mailbox #(mod_trans) rm2sb;

   //In constructor
   //pass the mailboxes as the arguments
   //make the connections 
   function new(mailbox #(mod_trans) wr2rm,
                mailbox #(mod_trans) rm2sb);
      this.wr2rm = wr2rm;
//      this.rd2rm = rd2rm;
      this.rm2sb = rm2sb;
	con_data = new;
   endfunction: new

   
   //Understand and include the virtual tasks dual_mem_fun_read and dual_mem_fun_write
   virtual task count_mod(mod_trans model_counter);
      begin
	if(model_counter.rst==1)
	begin
		ref_count <= 0;
	end
	else
	begin
		if(model_counter.load)
			ref_count <= model_counter.d_in;
	//	wait(model_counter.load==0)
		else
		begin
			if(model_counter.updown == 0)
			begin
				if(ref_count > 12)
					ref_count <= 4'b0;
				else
					ref_count <= ref_count + 1'b1;
			end
			else if(model_counter.updown == 1)
			begin
				if(ref_count == 0)
					ref_count <= 4'd11;
				else
					ref_count <= ref_count - 1'b1;
			end
		end
	end
     end
   endtask: count_mod
   
   //In virtual task start
   virtual task start();
      //in fork join_none
      fork
         begin
            forever
		begin
		wr2rm.get(wrmon_data);
		count_mod(wrmon_data);
            	wrmon_data.d_out= ref_count;
		con_data = new wrmon_data;
		rm2sb.put(con_data);
		con_data.display("Data From Reference Model");
		end
         end
      join_none
   endtask: start

endclass: mod_model
