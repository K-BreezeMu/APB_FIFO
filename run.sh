export PATH="/d/questa/win64:$PATH"

ROOT="D:/ROAD/learn/apb_fifo"

DUT_FILE="$ROOT/dut/fifo.sv"
PKG_FILE="$ROOT/component/apb_pkg.sv"
TOP_FILE="$ROOT/component/tb_top.sv"
VIF_FILE="$ROOT/component/apb_interface.sv"

SRC="$VIF_FILE $PKG_FILE $DUT_FILE $TOP_FILE"

TOP="tb_top"
OPT="tb_top_opt"
TESTS="reset_sequence_test push_pop_sequence_test"


INCDIR="+incdir+$ROOT/component +incdir+$ROOT/sequence_test"

echo "=== vlog command line ==="
echo "vlog -sv $INCDIR $SRC"
echo ""
echo "=== Compiling ==="
vlog -sv -L mtiUvm=uvm-1.2 $INCDIR $SRC
echo "=== Optimizing ==="
vopt -L mtiUvm=uvm-1.2 -o $OPT $TOP +acc
for t in $TESTS; do
	 echo ""
    echo "--- Running $t  ---"
	vsim -c -L mtiUvm=uvm-1.2 $OPT \
         +UVM_TESTNAME=$t \
	 -do "run -all;quit -f"
 done








