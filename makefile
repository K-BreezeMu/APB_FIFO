ROOT := $(shell pwd)

# 使用通配符自动寻找文件，避免漏加文件
DUT_FILE  = $(wildcard $(ROOT)/dut/*.sv)
PKG_FILE  = $(ROOT)/component/apb_pkg.sv
TOP_FILE  = $(ROOT)/component/tb_top.sv
VIF_FILE  = $(ROOT)/component/apb_interface.sv

# 增加 test_pkg 等相关文件
SRC = $(VIF_FILE) $(PKG_FILE) $(DUT_FILE) $(TOP_FILE)
ALL_SV = $(shell find $(ROOT)/component $(ROOT)/sequence_test $(ROOT)/dut -name "*.sv")

INCDIR = +incdir+$(ROOT)/component +incdir+$(ROOT)/sequence_test

TOP    = tb_top
OUTPUT = simv


VCS_OPTS = -full64 -sverilog -debug_access+all -kdb -ntb_opts uvm-1.2 -lca -Mupdate


TEST ?= reset_sequence_test
# 默认不生成波形 (make run DUMP=1 可开启)
DUMP ?= 0

ifeq ($(DUMP), 1)
    RUN_OPTS = +fsdb
else
    RUN_OPTS = 
endif

.PHONY: all compile run run_all clean verdi

all: compile

# 编译目标
compile: $(OUTPUT)

$(OUTPUT): $(ALL_SV)
	@echo "========================================"
	@echo ">>> Compiling with VCS..."
	@echo "========================================"
	vcs $(VCS_OPTS) $(INCDIR) $(SRC) -top $(TOP) -o $(OUTPUT) -l compile.log
	@if [ -f $(OUTPUT) ]; then \
		echo "✅ Compile Success! Output: $(OUTPUT)"; \
	else \
		echo "❌ Compile Failed! Please check compile.log"; exit 1; \
	fi
# 运行目标
run: compile
	@echo "========================================"
	@echo ">>> Running Test: $(TEST)"
	@echo "========================================"
	./$(OUTPUT) +UVM_TESTNAME=$(TEST) +ntb_random_seed_automatic $(RUN_OPTS) -l sim_$(TEST).log

run_all: compile
	@for t in reset_sequence_test push_pop_sequence_test; do \
		echo ""; \
		echo ">>> Running $$t ---"; \
		./$(OUTPUT) +UVM_TESTNAME=$$t +ntb_random_seed_automatic -l sim_$$t.log; \
	done

# 清理目标
clean:
	@echo ">>> Cleaning up..."
	rm -rf $(OUTPUT) csrc *.log *.vpd *.fsdb ucli.key simv.daidir vc_hdrs.h DVEfiles novas* verdiLog

# 打开 Verdi
verdi:
	@echo ">>> Launching Verdi..."
	verdi -sv -ntb_opts uvm-1.2 $(INCDIR) $(SRC) -ssf *.fsdb &
