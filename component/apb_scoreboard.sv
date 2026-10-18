class apb_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(apb_scoreboard)

	uvm_analysis_imp #(apb_sequence_item,apb_scoreboard) analysis_export;

	apb_refmodel refmodel;

	int pass;
	int fail;
	int total;

	function new(string name = "apb_scoreboard",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		analysis_export = new("analysis_export",this);
		refmodel = new();
	endfunction

	virtual function void compare(bit [7:0] addr,bit [31:0] exp,bit [31:0] act);
		if(exp !==act) begin
			fail++;
			`uvm_error("SCB","----------------------------------------------")
			`uvm_error("SCB",$sformatf("%s Mismatch:exp =0x%08h,act =0x%08h",reg_name,exp,act))

			if(addr == STATUS) begin 
			`uvm_error("SCB",$sformatf("Empty        : exp = %0b,act = %0b",exp[0],act[0]))
			`uvm_error("SCB",$sformatf("Full         : exp = %0b,act = %0b",exp[1],act[1]))
			`uvm_error("SCB",$sformatf("almost_full  : exp = %0b,act = %0b",exp[2],act[2]))
			`uvm_error("SCB",$sformatf("almost_empty : exp = %0b,act = %0b",exp[3],act[3]))
			`uvm_error("SCB",$sformatf("overflow     : exp = %0b,act = %0b",exp[4],act[4]))
			`uvm_error("SCB",$sformatf("underflow    : exp = %0b,act = %0b",exp[5],act[5]))
			`uvm_error("SCB",$sformatf("count        : exp = %0d,act = %0d",exp[13:6],act[13:6]))
		end else if(addr == CTRL) begin
			`uvm_error("SCB",$sformatf("en		 : exp = %0b,act = %0b",exp[0],act[0]))
			`uvm_error("SCB",$sformatf("clr		 : exp = %0b,act = %0b",exp[1],act[1]))
			`uvm_error("SCB",$sformatf("drop_on_full : exp = %0b,act = %0b",exp[2],act[2]))
		end else if(addr == THRESH) begin
			`uvm_error("SCB",$sformatf("almost_full_th  : exp = %0d,act = %0d",exp[7:0],act[7:0]))
			`uvm_error("SCB",$sformatf("almost_empty_th : exp = %0d,act = %0d",exp[15:8],act[15:8]))
		end
			`uvm_error("SCB","----------------------------------------------")
		end
	       	else begin
			pass++;
			`uvm_info("SCB","-----------------------------------------------",UVM_MEDIUM)
			`uvm_info("SCB","--------------------PASS-----------------------",UVM_MEDIUM)
		end
endfunction

	virtual function void write(apb_sequence_item tr);
		bit [31:0] exp;
		bit [31:0] act;
		if(tr.presetn == 1'b0) begin
			`uvm_info("SCB","!!! Reset Refmodel !!!!",UVM_MEDIUM)
			refmodel.reset();
			return;
		end

		total++;
		`uvm_info("SCB",$sformatf("pwrite = %0b,paddr = %02h,pwdata = %08h,prdata = %08h,pslverr = %0b",tr.pwrite,tr.paddr,tr.pwdata,tr.prdata,tr.pslverr))
		if(tr.pwrite == 1'b1) begin
		refmodel.write(tr.paddr,tr.pwdata);
		end
       		else begin
		exp = refmodel.read(tr.paddr);
		act = tr.prdata;
		compare(tr.paddr,exp,act);
		end
	endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);

		`uvm_info("SCB","-------------------------------------------------",UVM_MEDIUM)
		`uvm_info("SCB","-----------------Report SCB----------------------",UVM_MEDIUM)
		`uvm_info("SCB",$sformatf("total : %5d			",total),UVM_MEDIUM)
		`uvm_info("SCB",$sformatf("PASS  : %5d			",pass),UVM_MEDIUM)
		`uvm_info("SCB",$sformatf("FALL  : %5d			",fail),UVM_MEDIUM)
		`uvm_info("SCB","-------------------------------------------------",UVM_MEDIUM)
	endfunction
endclass




	
		
		


			

	














	
