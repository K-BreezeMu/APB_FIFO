class apb_sequence_item extends uvm_sequence_item;

	function new(string name = "apb_sequence_item");
		super.new(name);
	endfunction

	rand bit presetn;
	rand bit pwrite;

	rand bit [7:0] paddr;
	rand bit [31:0] pwdata;
	rand bit [31:0] prdata;
	rand bit pslverr;

	constraint addr {
		paddr inside {CTRL,THRESH,STATUS,DATA};
		}
	constraint ctrl {
		(paddr == CTRL)->pwdata[31:3] == 29'h0;
		}
	constraint thresh {
		(paddr == THRESH)->pwdata[31:16] == 16'h0;
		}
	constraint data {
		(paddr == DATA)->pwdata[31:8] == 24'h0;
		}

	`uvm_object_utils_begin(apb_sequence_item)
	`uvm_field_int(presetn,UVM_ALL_ON)
	`uvm_field_int(pwrite,UVM_ALL_ON)
	`uvm_field_int(paddr,UVM_ALL_ON)
	`uvm_field_int(pwdata,UVM_ALL_ON)
	`uvm_field_int(prdata,UVM_ALL_ON)
	`uvm_field_int(pslverr,UVM_ALL_ON)
	`uvm_object_utils_end

endclass
	
