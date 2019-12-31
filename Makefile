all: capp

potatolib: src/Potato.hs potato.cabal
	cabal configure && cabal build
	cp dist/build/potato/libpotato.* ./capp/

usingstack: src/Potato.hs potato.cabal stack.yaml
	stack build
	find .stack-work/ -name 'libpotato.*' -exec cp {} ./capp/ \;

capp: potatolib
	cd capp && make

run: capp
	cd capp && make run

clean:
	cabal new-clean && cd capp && make clean

.PHONY: all clean potatolib
