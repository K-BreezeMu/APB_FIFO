class apb_driver extends uvm_driver #(apb_sequence_item);
	`uvm_component_utils(apb_driver)

	function new(string name = "apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual apb_interface vif;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))begin
			`uvm_fatal("apb_driver","no vif")
		end
	endfunction

	 virtual task drive_idle();
		vif.PRESETn <= 1'b1;
		vif.PSEL <= 1'b0;
		vif.PENABLE <= 1'b0;
		vif.PWRITE <= 1'b0;
		vif.PADDR <= 8'h0;
		vif.PWDATA <= 32'h0;
	endtask

	virtual task drive(apb_sequence_item tr);
		if(tr.presetn == 1'b0) begin
			@(vif.drv_cb);
			vif.PRESETn <= 1'b0;
			@(vif.drv_cb);
			vif.PRESETn <= 1'b1;

		return;
	end

		@(vif.drv_cb);
		vif.PRESETn <= 1'b1;
		vif.drv_cb.PSEL <= 1'b1;
		vif.drv_cb.PENABLE <= 1'b0;
		vif.drv_cb.PWRITE <= tr.pwrite;
		vif.drv_cb.PADDR <= tr.paddr;
		vif.drv_cb.PWDATA <= tr.pwdata;

		@(vif.drv_cb);
		vif.PENABLE <= 1'b1;

		@(vif.drv_cb);
		while(vif.drv_cb.PREADY != 1'b1) begin
			@(vif.drv_cb);
		end

		tr.pslverr = vif.PSLVERR;
		if(!tr.pwrite) begin
			tr.prdata <= vif.drv_cb.PRDATA;
		end

		drive_idle();
	endtask

	virtual task run_phase(uvm_phase phase);
		apb_sequence_item tr;
		
		drive_idle();

		forever begin
			seq_item_port.get_next_item(tr);
			`uvm_info("Driver", $sformatf("Driving %s transaction: addr=0x%02h, pwdata=0x%0h",tr.pwrite ? "WRITE" : "READ", tr.paddr, tr.pwdata), UVM_MEDIUM)
			drive(tr);
			seq_item_port.item_done(tr);
		end
	endtask
endclass
				


