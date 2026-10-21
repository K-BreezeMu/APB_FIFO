class push_pop_sequence extends base_sequence;
	`uvm_object_utils(push_pop_sequence)

	function new(string name = "push_pop_sequence");
		super.new(name);
	endfunction

	task body();
		apb_sequence_item item;
		bit [31:0] data;
		`uvm_info(get_type_name(),"Start Push_pop_Sequence",UVM_MEDIUM)
		`uvm_info(get_type_name(),"1.------push one pop one-------",UVM_MEDIUM)
		enable();
		`uvm_info(get_type_name(),"en == 1",UVM_MEDIUM)

		
		write(DATA,32'h0001);
		`uvm_info(get_type_name(),"push 01",UVM_MEDIUM)
		read_status();
		#100;
		read(DATA,data);
		`uvm_info(get_type_name(),"pop 01",UVM_MEDIUM)
		read_status();
		#100;
	endtask
endclass

