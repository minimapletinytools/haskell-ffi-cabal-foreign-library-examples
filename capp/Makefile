export ROOT_DIR=${PWD}

all: potatomain

# make sure you cabal build first...
potatolib:
	cp ../dist/build/potato/libpotato.* ./

potatomain: potatomain.cpp potatolib
	g++ -g -Wall potatomain.cpp -o $@ \
	-I../csrc \
	-lpotato \
	-Wl,-rpath='$$ORIGIN' \
	-L./

run: potatomain
	./potatomain

clean:
	rm -rf *.o *.a potatomain

.PHONY: clean all run
