# haskell-ffi-cabal-foreign-library-examples

This repository contains a Cabal 2.0 project showing how to build a haskell library to use in c/c++ using the new [foreign-library](https://cabal.readthedocs.io/en/latest/developing-packages.html#foreign-libraries) feature. The `foreign-library` feature greatly simplifies the process of creating haskell libraries for use by other languages.

The `lens` and `deepseq` packages are included mainly as a test case for dependencies. The example contains code that is intended to test features _I_ need for my own projects, in particular [🥔 PuzzleScript](https://github.com/pdlla/PotatoPuzzleScript). I would love to merge a PR including more relevant examples 😘.

## Usage

`make run`

It was tested on Mac and Linux (Ubuntu 19.04 with cabal 2.4 and ghc 8.6.5).

## Walkthrough

`potato.cabal` defines our module using `foreign-library`

```
foreign-library potato
  type:                native-shared

  if os(Windows)
    options: standalone
    mod-def-file: PotatoLib.def

  other-modules:       Potato
  build-depends:
    base ^>=4.12.0.0
    , lens == 4.*
    , deepseq == 1.4.*
  hs-source-dirs:      src
  c-sources:           csrc/potato.cpp
  default-language:    Haskell2010
```

Please see [cabal docs](https://cabal.readthedocs.io/en/latest/developing-packages.html#foreign-libraries) for a more thorough description explaining the meaning of each field. The important detail here is

```
c-sources:           csrc/potato.cpp
```

which points to a file that `cabal build` will build for us (and handle all linker/include issues for us). In this case, we wrap all exported methods from our 🥔 Haskell module and from ghc's `HsFFI.h` inside of helper functions. Only `potato.h` needs to be included by the user. In this manner, we are building a 🥔 *c++* library that calls our 🥔 haskell library. If you don't wish to wrap the functionality, you can simply leave `potato.cpp` empty and call the exported methods from our 🥔 haskell library directly. In this case, you'll need to include `Potato_stub.h` which is generated by `cabal build` and likely `HsFFI.h` when you use the library.

`void potatoInit(void);` and `void potatoExit(void);` simply wrap `hs_init` and `hs_exit` which start and stop the haskell runtime respectively. `void test()` calls all the functions in our 🥔 haskell module.

The `capp/` folder contains our cpp source that will call code from our haskell `potato` module. The makefile builds the cpp app using `g++` with the needed flags. Note that it expects the hs library files to be in this directory to work.

```
g++ -g -Wall potatomain.cpp -o $@ \
-I../csrc \
-lpotato \
-L./
```

As mentioned earlier, if you want your `capp/potatomain.cpp` to use methods from the Haskell library directly instead of calling through `csrc/potato.h`, then you will need to add the flags `-I../dist/build/potato/potato-tmp` for `Potato_stub.h` and something like `-I/usr/local/lib/ghc-8.4.4/include/` for `HsFFI.h`.

Finally, the makefile in the root directory runs `cabal configure && cabal build` then copies the compiled library into the `capp` folder. Then it calls `make` inside of `capp`. `make run` runs the app it compiled in `capp`.

## Stack Integration
This seems to work fine with the latest version of stack. You can do `make usingstack` in the root directory to try it out. It will copy the output the `capp` folder and you can run `make run` inside the `capp` directory.

## THX

I used [this guide](https://ro-che.info/articles/2017-07-26-haskell-library-in-c-project) as a starting point which includes links to many other resources I found helpful so I won't list them here. The guide contains a script for gathering the scattered libraries but I didn't seem to need it here. As far as I can tell, Cabal 2.0 will package everything that's needed into a single shared library.

Enjoy!
