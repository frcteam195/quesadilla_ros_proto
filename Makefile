ARCH := $(shell arch)
ODIR := out
LIB := RobotComms.a
LIB_x86_64 := $(ODIR)/x86_64/$(LIB)
LIB_AARCH64 := $(ODIR)/aarch64/$(LIB)

CXX_FLAGS := -fPIC -I$(ODIR)

all:
	make $(ARCH)

proto:
	@mkdir -p out
	@/usr/local/bin/protoc --cpp_out=./out *.proto 

$(LIB_x86_64): proto
	mkdir -p $(ODIR)/x86_64
	cd $(ODIR)/x86_64 && $(CXX) $(CXX_FLAGS) -c ../*.cc
	ar -crfv $(LIB_x86_64) $(ODIR)/x86_64/*.o

$(LIB_AARCH64): proto
	mkdir -p $(ODIR)/aarch64
	cd $(ODIR)/aarch64 && $(CXX) $(CXX_FLAGS) -c ../*.cc
	ar -crfv $(LIB_AARCH64) $(ODIR)/aarch64/*.o
		
x86_64: $(LIB_x86_64)

arm64 aarch64: $(LIB_AARCH64)

clean:
	@rm -rf ./out