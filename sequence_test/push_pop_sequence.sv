class push_pop_sequence extends base_sequence;
	`uvm_object_utils(push_pop_sequence)

	function new(string name = "push_pop_sequence");
		super.new(name);
	endfunction

	task body();
		apb_sequence_item item;
		bit [31:0] data;
		`uvm_info(get_type_name(),"Start Push_pop_Sequence",UVM_MEDIUM)
		`uvm_info(get_type_name(),"1.------push one pop one-------",UVM_MEDIUM)
		reset();
		enable();
		`uvm_info(get_type_name(),"en == 1",UVM_MEDIUM)

		
		write(DATA,32'h0001);
		`uvm_info(get_type_name(),"push 01",UVM_MEDIUM)
		read_status();
		#100;
		read(DATA,data);
		`uvm_info(get_type_name(),"pop 01",UVM_MEDIUM)
		read_status();
		#100;

		write(DATA,32'h0002);
		`uvm_info(get_type_name(),"push 02",UVM_MEDIUM)
		read_status();
		#100;
		read(DATA,data);
		`uvm_info(get_type_name(),"pop 02",UVM_MEDIUM)
		read_status();
		#100;

		`uvm_info(get_type_name(),"1.------------END------------",UVM_MEDIUM)
		`uvm_info(get_type_name(),"2.---------push some pop some----------",UVM_MEDIUM)

		write(DATA,32'h0010);
		`uvm_info(get_type_name(),"pop 10",UVM_MEDIUM)
		write(DATA,32'h0011);
		`uvm_info(get_type_name(),"pop 11",UVM_MEDIUM)
		write(DATA,32'h0012);
		`uvm_info(get_type_name(),"pop 12",UVM_MEDIUM)
		write(DATA,32'h0013);
		`uvm_info(get_type_name(),"pop 13",UVM_MEDIUM)
		read_status();
		
		read(DATA,data);
		read(DATA,data);
		read(DATA,data);
		read(DATA,data);
		`uvm_info(get_type_name(),"2.--------------END-------------------",UVM_MEDIUM)

		`uvm_info(get_type_name(),"3.---------push/pop to almost ----------",UVM_MEDIUM)

		for(int i=0;i<15;i++) begin
			write(DATA,i);
			`uvm_info(get_type_name(),$sformatf("push %0d",i),UVM_MEDIUM)
		end
		
		read_status();

		for(int i=0;i<14;i++) begin
			read(DATA,data);
			`uvm_info(get_type_name(),$sformatf("pop %0d",data),UVM_MEDIUM)
		end

		read_status();
		`uvm_info(get_type_name(),"3.---------END--------------------------",UVM_MEDIUM)

		#100;
		reset();
		read_status();
		#100;
		enable();
		`uvm_info(get_type_name(),"4.-----underflow overflow---------------",UVM_MEDIUM)
		`uvm_info(get_type_name(),"--------------pop to underflow-----------",UVM_MEDIUM)
		read(DATA,data);
		read_status();
		read(DATA,data);
		read_status();
		`uvm_info(get_type_name(),"push to check underflow sticky",UVM_MEDIUM)
		write(DATA,1);
		read_status();
		read(DATA,data);
		read_status();
		read(DATA,data);
		read_status();
		`uvm_info(get_type_name(),"---------push to overflow-------------",UVM_MEDIUM)
		for(int i=0;i<16;i++) begin
			write(DATA,i);
		end
		read_status();
		write(DATA,2);
		read_status();
		`uvm_info(get_type_name(),"pop to check overflow sticky",UVM_MEDIUM)
		read(DATA,data);
		read_status();
		read(DATA,data);
		read_status();
		for(int i=0;i<15;i++) begin
			read(DATA,data);
			read_status();
		end
		#100;
		`uvm_info(get_type_name(),"4.--------------END--------------------",UVM_MEDIUM)	

		`uvm_info(get_type_name(),"5.------------CLR VERY-----------------",UVM_MEDIUM)
		reset();
		enable();
		for(int i=0;i<17;i++) begin
			write(DATA,i);
		end
		read_status();
		`uvm_info(get_type_name(),"---------set clr-----------------------",UVM_MEDIUM)
		write(CTRL,32'h2);
		read(CTRL,data);
		read_status();
		`uvm_info(get_type_name(),"5.------------END----------------------",UVM_MEDIUM)




	endtask
endclass

