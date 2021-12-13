extends Node


# global constants for input information


# stick directions
const N : int = 0
const U : int = 1
const F : int = 2
const B : int = 4
const D : int = 8
const UF = U | F
const UB = U | B
const DF = D | F
const DB = D | B 

# buttons
const QUICK : int = 16
const DIRECT : int = 32
const VERTICAL : int = 64
const HORIZONTAL : int = 128
const DASH : int = 256

const START : int = 512
const SELECT : int = 1024
