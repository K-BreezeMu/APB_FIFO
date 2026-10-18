class apb_env extends uvm_env;
	`uvm_component_utils(apb_env)

	apb_agent agent;
	apb_scoreboard scoreboard;
	apb_subscriber subscriber;

	function new(string name = "apb_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = apb_agent::type_id::create("agent",this);
		scoreboard = apb_scoreboard::type_id::create("scoreboard",this);
		subscriber = apb_subscriber::type_id::create("subscriber",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agent.monitor.ap.connect(scoreboard.analysis_export);
		agent.monitor.ap.connect(subscriber.analysis_export);
	endfunction

endclass
