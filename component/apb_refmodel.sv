class apb_refmodel;
	localparam int DEPTH = FIFO_DEPTH;
	localparam int WIDTH = FIFO_WIDTH;

	protected bit [WIDTH-1:0] data[$];

	//CTRL
	bit en;
	bit clr;
	bit drop_on_full;

	//THRESH
	bit [7:0] almost_full_th;
	bit [7:0] almost_empty_th;

	//status
	bit empty;
	bit full;
	bit almost_empty;
	bit almost_full;
	bit overflow;
	bit underflow;
	bit [7:0] count;

	function void updata_flags();
		count = data.size();
		empty = (count == 0);
		full = (count >= DEPTH);
		almost_empty = (count <= almost_empty_th);
		almost_full = (count > almost_full_th);
	endfunction

	function bit push (bit [WIDTH-1:0] data_in);
		if(!en) begin
			return 1;
		end
		if(full) begin
			overflow = 1'b1;
			if(drop_on_full)
				return 0;
			else begin
				return 1;
			end
		end
	
			data.push_back(data_in);
			updata_flags();
			return 0;
		endfunction

	function bit [WIDTH-1:0] pop();
		bit [WIDTH-1:0] data_out;
		if(!en) begin
			return 0;
		end
		if(empty) begin
			underflow = 1'b1;
			return 0;
		end

		data_out = data.pop_front();
		updata_flags();
		return data_out;
	endfunction
	
	function void reset();
		data.delete();
		en = 1'b0;
		clr = 1'b0;
		drop_on_full = 1'b0;
		almost_full_th = DEPTH -1;
		almost_empty_th = 8'd1;
		overflow = 1'b0;
		underflow =1'b0;
		updata_flags();
	endfunction

	function void clear();
		data.delete();
		updata_flags();
		overflow = 1'b0;
		underflow = 1'b0;
	endfunction

	function bit [31:0] read(bit [7:0] addr);
		bit [31:0] data_out;
		case(addr)
			CTRL:begin
				data_out = {29'd0,drop_on_full,clr,en};
			end
			STATUS:begin
				data_out = {18'd0,count[7:0],underflow,overflow,almost_empty,almost_full,full,empty};
			end
			DATA:begin
				data_out = {24'd0,pop()};
			end
			THRESH:begin
				data_out = {16'd0,almost_empty_th,almost_full_th};
			end
			default data_out = 32'd0;
		endcase
			return data_out;
		endfunction

	function bit write (bit [7:0] addr,bit [31:0] wdata);
		case(addr)
			CTRL:begin
				en = wdata[0];
				clr = wdata[1];
				drop_on_full = wdata[2];
				if(clr) begin wdata[0] =1'b0;
						clear();
						clr = 1'b0;
					end
			end
			THRESH:begin
				almost_full_th = wdata[7:0];
				almost_empty_th = wdata[15:8];
			end
			DATA:begin
				return push(wdata[WIDTH-1:0]);
			end
			default: `uvm_warning("SCB","unknown reg!!!!")
		endcase
	endfunction
endclass

