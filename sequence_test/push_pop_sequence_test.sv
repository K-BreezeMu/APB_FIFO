class push_pop_sequence_test extends base_sequence_test;

	`uvm_component_utils(push_pop_sequence_test)

	function new(string name = "push_pop_sequence_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		push_pop_sequence pp_seq;
    uvm_top.set_timeout(10ms, 0);
		phase.raise_objection(this);
		pp_seq = push_pop_sequence::type_id::create("pp_seq",this);
		pp_seq.start(env.agent.sequencer);

		#1000;
		phase.drop_objection(this);
	endtask
endclass
