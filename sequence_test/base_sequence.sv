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
	
endclass
