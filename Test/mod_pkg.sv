/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_pkg.sv   

Description    :  Package for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/
package mod_pkg;

   int number_of_transactions = 1;
  
   //include the files 
   //"ram_trans.sv", "ram_gen.sv", "ram_write_drv.sv"
   //"ram_read_drv.sv", "ram_write_mon.sv", "ram_read_mon.sv"
   //"ram_model.sv", "ram_sb.sv", "ram_env.sv", "test.sv"
	`include "mod_trans.sv"
	`include "mod_gen.sv"
	`include "mod_write_drv.sv"
//	`include "mod_read_drv.sv"
	`include "mod_write_mon.sv"
	`include "mod_read_mon.sv"
	`include "mod_model.sv"
	`include "mod_sb.sv"
	`include "mod_env.sv"
	`include "test.sv" 

endpackage
