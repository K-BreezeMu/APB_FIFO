`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

module tb_top;
	
	logic PCLK;
	
	initial begin
		PCLK = 0 ;
		forever #5 PCLK = ~PCLK;
	end

	apb_interface  vif(PCLK);

	apb_sync_fifo #(
        .WIDTH(FIFO_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) dut (
        .PCLK (PCLK),
        .PRESETn (vif.PRESETn),
        .PSEL (vif.PSEL),
        .PENABLE (vif.PENABLE),
        .PWRITE (vif.PWRITE),
        .PADDR (vif.PADDR),
        .PWDATA (vif.PWDATA),
        .PRDATA (vif.PRDATA),
        .PREADY (vif.PREADY),
        .PSLVERR (vif.PSLVERR)
    );

    initial begin

	    uvm_config_db#(virtual apb_interface)::set(null,"*.env.agent.driver","vif",vif);
	    uvm_config_db#(virtual apb_interface)::set(null,"*.env.agent.monitor","vif",vif);
    end

    initial begin
	    run_test();
    end

      initial begin
        #1000000;  // 1ms timeout
        `uvm_fatal("TOP", "Simulation timeout!")
    end

    endmodule
    
