{-# LANGUAGE CPP                      #-}
{-# LANGUAGE DeriveAnyClass           #-}
{-# LANGUAGE DeriveGeneric            #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE TemplateHaskell          #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}

module Potato (
  basicPotato
) where


import           Foreign.C.Types
import           Foreign.Ptr
import           Foreign.StablePtr

import           Control.DeepSeq
import           Control.Lens
import           Data.Int          (Int32)
import           GHC.Generics      (Generic)

foreign import ccall "dynamic" mkFun :: FunPtr (CInt -> CInt) -> (CInt -> CInt)

data SubComplicated = SubComplicated Int Float String deriving(Show, Generic, NFData)

data Complicated = Complicated {
  _f1 :: SubComplicated,
  _f2 :: [Float],
  _f3 :: Int32 -> Int32
}

instance Show Complicated where
  show (Complicated f1' f2' f3') = "Complicated:\n\t" ++ show f1' ++ "\n\t" ++ show f2' ++ "\n\tf3(0)=" ++ show (f3' 0)


newComplicated :: Complicated
newComplicated = Complicated {
  _f1 = SubComplicated 5 0.5 "hi",
  _f2 = [0.1,0.2,5],
  _f3 = (+2)
}

makeLenses ''Complicated


basicPotato :: IO ()
basicPotato = print "potato"

getComplicated :: IO (StablePtr Complicated)
getComplicated = newStablePtr newComplicated

printComplicated :: StablePtr Complicated -> IO ()
printComplicated ptr = do
  v <- deRefStablePtr ptr
  print v

mutateComplicated :: CFloat -> StablePtr Complicated -> IO (StablePtr Complicated)
mutateComplicated (CFloat addme) ptr = do
  v <- deRefStablePtr ptr
  let
    newcomp = over f2 (++[addme]) v
  freeStablePtr ptr
  newStablePtr newcomp


setAdder :: FunPtr (CInt -> CInt) -> StablePtr Complicated -> IO (StablePtr Complicated)
setAdder fptr ptr = do
  v <- deRefStablePtr ptr
  let
    newAdder x = r where
      CInt r = (mkFun fptr) (CInt x)
    newcomp = set f3 newAdder v
  freeStablePtr ptr
  newStablePtr newcomp

freeComplicated :: StablePtr Complicated -> IO ()
freeComplicated = freeStablePtr



foreign export ccall basicPotato :: IO ()
foreign export ccall getComplicated :: IO (StablePtr Complicated)
foreign export ccall printComplicated :: StablePtr Complicated -> IO ()
foreign export ccall freeComplicated :: StablePtr Complicated -> IO ()
foreign export ccall mutateComplicated :: CFloat -> StablePtr Complicated -> IO (StablePtr Complicated)
foreign export ccall setAdder :: FunPtr (CInt -> CInt) -> StablePtr Complicated -> IO (StablePtr Complicated)
