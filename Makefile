all: potatolib

potatolib: src/Potato.hs potato.cabal
	cabal configure && cabal build

capp: potatolib
	cd capp && make

run: capp
	cd capp && make run

clean:
	cabal new-clean && cd capp && make clean

.PHONY: all clean potatolib
