module Main exposing (main)

import Benchmark exposing (Benchmark, benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        sampleList =
            List.range 0 1000
    in
    benchmark "BAD" <| 
        \_ -> List.foldr (\x acc -> acc ++ [x]) [] sampleList


main : BenchmarkProgram
main =
    program suite
