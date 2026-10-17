interface apb_interface(input PCLK);
	logic PRESETn;

	logic PSEL;
	logic PENABLE;
	logic PWRITE;
	logic [7:0] PADDR;
	logic [31:0] PWDATA;
	
	logic [31:0] PRDATA;
	logic PREADY;
	logic PSLVERR;

	clocking drv_cb @(posedge PCLK);
		default input #1step output #1step;
		output PSEL,PENABLE,PWRITE,PADDR,PWDATA;
		input  PREADY,PRDATA,PSLVERR;
	endclocking

	clocking mon_cb @(posedge PCLK);
		default input #1step;
		input PSSL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY,PSLVERR;	   
       	endclocking
