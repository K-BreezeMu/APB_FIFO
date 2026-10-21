class base_sequence extends uvm_sequence #(apb_sequence_item);

	`uvm_object_utils(base_sequence)

	function new(string name = "base_sequence");
		super.new(name);
	endfunction

	virtual task write(bit [7:0] addr,bit [31:0] data);
		apb_sequence_item item;
		item = apb_sequence_item::type_id::create("item");
		start_item(item);
		item.presetn = 1'b1;
		item.pwrite = 1'b1;
		item.paddr = addr;
		item.pwdata = data;
		finish_item(item);
		get_response(item);
	endtask

	virtual task read(bit [7:0] addr,output bit [31:0] data);
		apb_sequence_item item;
		item = apb_sequence_item::type_id::create("item");
		start_item(item);
		item.presetn = 1'b1;
		item.pwrite = 1'b0;
		item.paddr = addr;
		finish_item(item);
		get_response(item);
		data = item.prdata;
	endtask
	
	virtual task reset();
		apb_sequence_item item;
		`uvm_info(get_type_name(),"reset task",UVM_MEDIUM)
		item = apb_sequence_item::type_id::create("item");
		start_item(item);
		item.presetn = 1'b0;
		finish_item(item);
		get_response(item);
	endtask

	virtual task enable();
		`uvm_info(get_type_name(),"enabled",UVM_MEDIUM)
		write(CTRL,32'h1);
	endtask

	virtual task dis_able();
		`uvm_info(get_type_name(),"dis_able",UVM_MEDIUM)
		write(CTRL,32'h0);
	endtask

	virtual task read_status();
		bit [31:0] act;
		read(STATUS,act);
			`uvm_info(get_type_name(),$sformatf("Empty        : act = %0b",act[0]),UVM_MEDIUM)
			`uvm_info(get_type_name(),$sformatf("Full         : act = %0b",act[1]),UVM_MEDIUM)
			`uvm_info(get_type_name(),$sformatf("almost_full  : act = %0b",act[2]),UVM_MEDIUM)
			`uvm_info(get_type_name(),$sformatf("almost_empty : act = %0b",act[3]),UVM_MEDIUM)
			`uvm_info(get_type_name(),$sformatf("overflow     : act = %0b",act[4]),UVM_MEDIUM)
			`uvm_info(get_type_name(),$sformatf("underflow    : act = %0b",act[5]),UVM_MEDIUM)
			`uvm_info(get_type_name(),$sformatf("count        : act = %0d",act[13:6]),UVM_MEDIUM)
	endtask
		
	
endclass
