module mod12 (
	input clock, 
	input rst, 
	input load, 
	input updown,
	input [3:0] d_in, 
	output reg [3:0] d_out);

always @ (posedge clock)
	begin
		if(rst)
			d_out <= 4'd0;
		else
		begin
			if(load)
				d_out <= d_in;
			else
			begin
				if(updown==0)
				begin
					if(d_out == 4'd11)
						d_out <= 4'd0;
					else
						d_out <= d_out + 1;
				end
				else
				begin
					if(d_out == 4'd0)
						d_out <= 4'd11;
					else
						d_out <= d_out - 1;
				end	
			end
		end
	end

endmodule
