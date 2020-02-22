export ROOT_DIR=${PWD}
UNAME := $(shell uname)

# make sure you build parent project first or it won't find the libraries

all: potatomain

potatomain: potatomain.cpp
# set linker path on linux
# not sure why I need clang++ or -stdlib=libc++ but it fixes some missing symbol errors
ifeq ($(UNAME), Linux)
	g++ -g -Wall potatomain.cpp -o $@ \
	-I../csrc \
	-stdlib=libc++
	-Wl,-rpath='$$ORIGIN' \
	-lpotato \
	-L./
else
	g++ -g -Wall potatomain.cpp -o $@ \
	-I../csrc \
	-lpotato \
	-L./
endif
# set rpath path on mac, see https://medium.com/@donblas/fun-with-rpath-otool-and-install-name-tool-e3e41ae86172
ifeq ($(UNAME), Darwin)
	install_name_tool -add_rpath @executable_path/. potatomain
endif


run: potatomain
	./potatomain

clean:
	rm -rf *.o *.a *.dSYM *.dylib potatomain

.PHONY: clean all run
