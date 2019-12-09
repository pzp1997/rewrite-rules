module Main exposing (main)

import Benchmark exposing (Benchmark, benchmark, compare, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        sampleList =
            List.range 0 2000

        smallerSampleList =
            List.range 0 200

        f x =
            x + x

        g x =
            x + 1

        h x y =
            x * (y + 1)

        j x =
            modBy 7 x == 1
    in
    describe "Lists"
        [ compare "map f (map g l) → map (f . g) l" "pre" (\_ -> List.map f (List.map g sampleList)) "post" (\_ -> List.map (g >> f) sampleList)
        , compare "reverse (reverse l) → l" "pre" (\_ -> List.reverse (List.reverse sampleList)) "post" (\_ -> sampleList)
        , compare "foldr f z (reverse l) → foldl f z l" "pre" (\_ -> List.foldr h 0 (List.reverse sampleList)) "post" (\_ -> List.foldl h 0 sampleList)
        , compare "foldr f z (map g l) → foldr (\\x acc -> f (g x) acc) z l" "pre" (\_ -> List.foldr h 0 (List.map f sampleList)) "post" (\_ -> List.foldr (\x acc -> h (f x) acc) 0 sampleList)
        , compare "any identity (map f l) → any f l" "pre" (\_ -> List.any identity (List.map j sampleList)) "post" (\_ -> List.any j sampleList)
        , compare "all identity (map f l) → all f l" "pre" (\_ -> List.all identity (List.map j sampleList)) "post" (\_ -> List.all j sampleList)

        -- the pre of this rule is so bad it causes Chrome to crash on lists of 1k+ elements
        , compare "foldr (\\x acc -> acc ++ [x]) z l → foldl (::) z l" "pre" (\_ -> List.foldr (\x acc -> acc ++ [x]) [] smallerSampleList) "post" (\_ -> List.foldl (::) [] smallerSampleList)
        
        -- Tuple.first (List.unzip list) → List.map Tuple.first list
        -- Tuple.second (List.unzip list) → List.map Tuple.second list
        -- Tuple.first (List.partition pred list) → List.filter pred list
        -- Tuple.second (List.partition pred list) → List.filter (pred >> not) list
        ]



main : BenchmarkProgram
main =
    program suite
