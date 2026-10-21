class reset_sequence extends base_sequence;
	`uvm_object_utils(reset_sequence);

	function new(string name = "reset_sequence");
		super.new(name);
	endfunction

	task body();
		apb_sequence_item item;
		bit [31:0] data;
		`uvm_info(get_type_name(),"Start reset_sequence",UVM_MEDIUM)
		`uvm_info(get_type_name(),"reset time",UVM_MEDIUM) //上电复位
		reset();
		read_status();
		#100;
		`uvm_info(get_type_name(),"--------------------",UVM_MEDIUM)
		
		`uvm_info(get_type_name(),"reset from idle",UVM_MEDIUM)
		reset(); //idle复位
		read_status();
		#100;


		`uvm_info(get_type_name(),"Push data",UVM_MEDIUM)
		enable();
		read(CTRL,data);
		write(DATA,32'h0010);
		read_status();
		#100;
		`uvm_info(get_type_name(),"reset time",UVM_MEDIUM)
		reset();
		read_status();
		`uvm_info(get_type_name(),"--------------------",UVM_MEDIUM)
	endtask
endclass




		

		


		
	
