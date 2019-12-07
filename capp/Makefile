export ROOT_DIR=${PWD}
UNAME := $(shell uname)


all: potatomain

# make sure you cabal build first...
potatolib:
	cp ../dist/build/potato/libpotato.* ./

potatomain: potatomain.cpp potatolib
# set linker path on Linux
ifeq ($(UNAME), Linux)
	g++ -g -Wall potatomain.cpp -o $@ \
	-I../csrc \
	-Wl,-rpath='$$ORIGIN' \
	-lpotato \
	-L./
else
	g++ -g -Wall potatomain.cpp -o $@ \
	-I../csrc \
	-lpotato \
	-L./
endif


run: potatomain
# set dylib path on Mac
# I don't get it either, I just copy pasted from here https://medium.com/@donblas/fun-with-rpath-otool-and-install-name-tool-e3e41ae86172
ifeq ($(UNAME), Darwin)
	install_name_tool -add_rpath @executable_path/. potatomain
endif
	./potatomain

clean:
	rm -rf *.o *.a potatomain

.PHONY: clean all run
