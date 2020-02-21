all: capp


usingcabal: src/Potato.hs potato.cabal.old
	rm potato.cabal
	cp potato.cabal.old potato.cabal
	cabal configure && cabal build
	find dist-newstyle/ -name 'libpotato.*' -exec cp {} ./capp/ \;


potatolib: src/Potato.hs package.yaml stack.yaml
	rm potato.cabal
	stack build
	find .stack-work/ -name 'libpotato.*' -exec cp {} ./capp/ \;

capp: potatolib
	cd capp && make

run: capp
	cd capp && make run

clean:
	rm potato.cabal
	rm -r dist-newstyle
	stack clean && cd capp && make clean

.PHONY: all usingcabal potatolib capp run clean
