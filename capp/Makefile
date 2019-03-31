export ROOT_DIR=${PWD}

all: potatomain

# make sure you cabal build first...
potatolib:
	cp ../dist/build/potato/libpotato.dylib ./

potatomain: potatomain.cpp potatolib
	g++ -g -Wall potatomain.cpp -o $@ \
	-I../csrc \
	-lpotato \
	-L./

run: potatomain
	export DYLD_LIBRARY_PATH=${ROOT_DIR} && ./potatomain

clean:
	rm -rf *.o *.a potatomain

.PHONY: clean all run
