
class mod_trans;
   
   rand bit load;
   rand bit updown;
   rand bit [3:0] d_in;
   rand bit rst;
   
   logic [3:0] d_out;
 
   // Declare a static variable trans_id (int type), to keep the count of transactions generated
   static int trans_id;

   static int no_of_rst_trans;
   static int no_of_load_trans;
   static int no_of_updown_trans;

   // Add the following constraints 
   constraint c0 {d_in inside {[0:11]};}
   constraint c1 {load ==1;}
   constraint c2 {updown dist{0:=10,1:=3};}
   constraint c3 {rst dist{1:=70, 0:=30};}

   // In post_randomize method 
   function void post_randomize();
      trans_id++;
      if(this.rst==1)
         no_of_rst_trans++;
      if(this.load==1)
         no_of_load_trans++;
      if(this.updown==1)
         no_of_updown_trans++;
      this.display("\tRANDOMIZED DATA");
   endfunction: post_randomize

   //In virtual function display
      // display the string
      // display all the properties of the transaction class
   virtual function void display(input string message);
      $display("=============================================================");
      $display("%s",message);
      if(message=="\tRANDOMIZED DATA")
         begin
            $display("\t_______________________________");
            $display("\tTransaction No. %d",trans_id);
            $display("\tReset Transaction No. %d", no_of_rst_trans);
            $display("\tLoad Transaction No. %d", no_of_load_trans);
            $display("\tUP/DOWN Transaction No. %d", no_of_updown_trans);
            $display("\t_______________________________");
         end
      $display("\tReset=%d",rst);
      $display("\tLoad=%d, Load_data=%d",load, d_in);
      $display("\tUP/DOWN=%d",updown);
      $display("\tData_out= %d",d_out);
      $display("=============================================================");
   endfunction: display


endclass: mod_trans
