#include <stdlib.h>
#include <iostream>
#include "HsFFI.h"
#include "potato.h"
#include "Potato_stub.h"

void potatoInit(void){
  int argc = 2;
  char *argv[] = { (char *)"+RTS", (char *)"-A32m", NULL };
  char **pargv = argv;

  // Initialize Haskell runtime
  hs_init(&argc, &pargv);
}

void potatoExit(void){
  hs_exit();
}

int add1234(int a) {
  return a + 1234;
}

void test()
{
  basicPotato();

  std::cout << "original" << std::endl;
  HsStablePtr ptr = getComplicated();
  printComplicated(ptr);

  std::cout << "mutate 1.0" << std::endl;
  ptr = mutateComplicated(1.0, ptr);
  printComplicated(ptr);

  std::cout << "mutate 2343.0" << std::endl;
  ptr = mutateComplicated(2343.0, ptr);
  printComplicated(ptr);

  std::cout << "setAdder 1234" << std::endl;
  ptr = setAdder((HsFunPtr)add1234, ptr);
  printComplicated(ptr);

  // sadly does not work :(((
  //std::cout << "setAdder 123 lambda" << std::endl;
  //auto addFun = [](int a) { return a + 123; };
  //ptr = setAdder((HsFunPtr)addFun, ptr);
  //printComplicated(ptr);

  std::cout << "cleanup" << std::endl;
  freeComplicated(ptr);
}
