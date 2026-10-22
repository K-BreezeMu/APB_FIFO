class reset_sequence_test extends base_sequence_test;

	`uvm_component_utils(reset_sequence_test)


function new(string name = "reset_sequence_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
  	reset_sequence reset_seq;
    uvm_top.set_timeout(10ms, 0); 
		phase.raise_objection(this);
		reset_seq = reset_sequence::type_id::create("reset_seq",this);
		reset_seq.start(env.agent.sequencer);

		#1000;
		phase.drop_objection(this);
	endtask
endclass
		
