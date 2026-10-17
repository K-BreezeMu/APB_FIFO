class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)

	virtual apb_interface vif;
	uvm_analysis_port #(apb_sequence_item) ap;

	function new(string name = "apb_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		ap = new("ap",this);
		if(!uvm_config_db#(apb_interface)::get(this,"","vif",vif))begin
			`uvm_fatal("apb_monitor","no vif")
		end
	endfunction
	
	virtual task run_phase(uvm_phase);
		apb_sequence_item item;
		forever begin
		@(vif.mon_cb);
		if(vif.PSEL && vif.PENABLE && vif.PREADY || vif.PRESETn == 1'b0) begin
		item = apb_sequence_item::type_id::create("item",this);
		item.presetn <= vif.PRESETn;
		item.pwrite <= vif.PWRITE;
		item.paddr <= vif.PADDR;
		item.pwdata <= vif.PWDATA;
		item.prdata <= vif.PRDATA;
		item.pslverr <= vif.PSLVERR;
		ap.write(item);
		end
	end
	endtask
endclass

		
