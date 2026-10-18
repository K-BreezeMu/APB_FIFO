class apb_subscriber extends uvm_subscriber #(apb_sequence_item);
	`uvm_component_utils(apb_subscriber)
	apb_sequence_item item;
 	bit [15:0] status;

	covergroup cg_transaction;
		option.per_instance=1;

		pwrite_cp: coverpoint item.pwrite{
			bins read = {1'b0};
			bins write = {1'b1};
			}

		paddr_cp : coverpoint item.paddr{
			bins ctrl = {8'h00};
			bins thresh = {8'h04};
			bins status = {8'h08};
			bins data = {8'h0C};
			}

		write_paddr_cross: cross pwrite_cp,paddr_cp{
			ignore_bins status_write = binsof(pwrite_cp.write) && binsof(paddr_cp.status);
			}
		endgroup

	covergroup data_cg;
		option.per_instance = 1;

		wdata_cp: coverpoint item.pwdata [7:0] {
			bins zero = {8'h00} ;
			bins low = {[8'h01:8'h3F]};
			bins mid = {[8'h40:8'hBF]};
			bins high = {[8'hC0:7'hFE]};
			bins max = {8'hFF};
			}

		rdata_cp: coverpoint item.prdata [7:0] {
			bins zero = {8'h00} ;
			bins low = {[8'h01:8'h3F]};
			bins mid = {[8'h40:8'hBF]};
			bins high = {[8'hC0:8'hFE]};
			bins max = {8'hFF};
			}
		endgroup
	
	covergroup status_cg;
		option.per_instance = 1;

		count_cp: coverpoint status [13:6] {
			bins empty = {0};
			bins one = {1};
			bins low = {[2:5]};
			bins mid = {[6:10]};
			bins high ={[11:14]};
			bins almost_full = {15};
			bins full = {16};
			}

		empty_cp: coverpoint status [0] {
			bins not_empty = {0};
			bins empty = {1};
			}

		full_cp : coverpoint status [1] {
			bins not_full = {0};
			bins full = {1};
			}
		
		almost_full_cp : coverpoint status [2] {
			bins not_almost_full = {0};
			bins almost_full = {1};
			}

		almost_empty_cp : coverpoint status [3] {
			bins not_almost_empty = {0};
			bins almost_empty = {1};
			}

		overflow_cp : coverpoint status [4] {
			bins not_overflow = {0};
			bins overflow = {1};
			}

		underflow_cp : coverpoint status [5] {
			bins not_underflow = {0};
			bins underflow = {1};
			}
		endgroup
	
	covergroup ctrl_cg;
		option.per_instance = 1;
		
		en_cp : coverpoint status [0] {
			bins dis_en = {0};
			bins en = {1};
			}

		clr_cp : coverpoint status [1] {
			bins dis_clr = {0};
			bins clr = {1};
			}

		drop_on_full_cp: coverpoint status [2] {
			bins dis_drop = {0};
			bins drop = {1};
			}
		endgroup

	covergroup thresh_cg;
		option.per_instance = 1;

		almost_full_th_cp : coverpoint status [7:0] {
			bins low = {8};
			bins mid = {[9:11]};
			bins high = {[12:14]};
			bins max = {15};
			}

		almost_empty_th_cp : coverpoint status [15:8] {
			bins low = {1};
			bins mid = {[2:4]};
			bins high = {[5:6]};
			bins max = {7};
			}
		endgroup

	function new(string name = "apb_subsciber",uvm_component parent);
		super.new(name,parent);
		cg_transaction = new();
		data_cg = new();
		status_cg = new();
		ctrl_cg = new();
		thresh_cg = new();
	endfunction

	function void write(apb_sequence_item t);
		item =t;
		cg_transaction.sample();

		if(item.pwrite == 1'b0) begin
			status = item.prdata [15:0];

		case(item.paddr)
			CTRL: begin
				ctrl_cg.sample();
			end
			STATUS: begin
				status_cg.sample();
			end
			DATA: begin
				data_cg.sample();
			end
			THRESH: begin
				thresh_cg.sample();
			end
		endcase
	end else begin
			status = item.pwdata [15:0];
		case(item.paddr)
			CTRL: begin
				ctrl_cg.sample();
			end
			STATUS: begin
				status_cg.sample();
			end
			DATA: begin
				data_cg.sample();
			end
			THRESH: begin
				thresh_cg.sample();
			end
		endcase
	end
endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);

		`uvm_info("COV","----------------Report--------------",UVM_MEDIUM)
		`uvm_info("COV",$sformatf("Transaction :      %5.2f%%",cg_transaction.get_coverage()),UVM_MEDIUM)
		`uvm_info("COV",$sformatf("ctrl_cg     :      %5.2f%%",ctrl_cg.get_coverage()),UVM_MEDIUM)
		`uvm_info("COV",$sformatf("status_cg   :      %5.2f%%",status_cg.get_coverage()),UVM_MEDIUM)
		`uvm_info("COV",$sformatf("data_cg     :      %5.2f%%",data_cg.get_coverage()),UVM_MEDIUM)
		`uvm_info("COV",$sformatf("thresh_cg   :      %5.2f%%",thresh_cg.get_coverage()),UVM_MEDIUM)
		`uvm_info("COV","------------------------------------",UVM_MEDIUM)
	endfunction

endclass







	
				
		
		






