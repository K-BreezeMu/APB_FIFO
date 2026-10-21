package apb_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	parameter int FIFO_WIDTH = 8;
	parameter int FIFO_DEPTH = 16;

	parameter bit [7:0] CTRL= 8'h00; // RW
   	parameter bit [7:0] THRESH= 8'h04; // RW
    	parameter bit [7:0] STATUS= 8'h08; // R
    	parameter bit [7:0] DATA = 8'h0C; // RW

	`include "apb_sequence_item.sv"
	`include "apb_sequencer.sv"

	`include "apb_driver.sv"
	`include "apb_monitor.sv"
	`include "apb_agent.sv"

	`include "apb_refmodel.sv"
	`include "apb_scoreboard.sv"
	`include "apb_subscriber.sv"

	`include "apb_env.sv"

	`include "base_sequence.sv"
	`include "base_sequence_test.sv"
	`include "reset_sequence.sv"
	`include "reset_sequence_test.sv"
	`include "push_pop_sequence.sv"
	`include "push_pop_sequence_test.sv"

endpackage
