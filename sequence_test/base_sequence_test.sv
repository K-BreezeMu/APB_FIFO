class base_sequence_test extends uvm_test;

	`uvm_component_utils(base_sequence_test)

	apb_env env;

	function new(string name= "base_sequence_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = apb_env::type_id::create("env",this);
	endfunction

endclass
