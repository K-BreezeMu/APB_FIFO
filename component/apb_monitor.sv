class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)

	virtual apb_interface vif;
	uvm_analysis_port #(apb_sequence_item) ap;

	function new(string name = "apb_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap = new("ap",this);
		if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))begin
			`uvm_fatal("apb_monitor","no vif")
		end
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		apb_sequence_item item;
		forever begin
		@(vif.mon_cb);
		if((vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY) || (vif.PRESETn == 1'b0)) begin
		item = apb_sequence_item::type_id::create("item",this);
		item.presetn = vif.PRESETn;
		item.pwrite = vif.mon_cb.PWRITE;
		item.paddr = vif.mon_cb.PADDR;
		item.pwdata = vif.mon_cb.PWDATA;
		item.prdata = vif.mon_cb.PRDATA;
		item.pslverr = vif.mon_cb.PSLVERR;
		ap.write(item);
		end
	end
	endtask
endclass

		
