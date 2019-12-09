module Main exposing (main)

import Benchmark exposing (Benchmark, benchmark, describe)
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
        [ describe "map f (map g l) → map (f . g) l"
            [ benchmark "pre" <|
                \_ -> List.map f (List.map g sampleList)
            , benchmark "post" <|
                \_ -> List.map (g >> f) sampleList
            ]
        , describe "reverse (reverse l) → l"
            [ benchmark "pre" <|
                \_ -> List.reverse (List.reverse sampleList)
            , benchmark "post" <|
                \_ -> sampleList
            ]
        , describe "foldr f z (reverse l) → foldl f z l"
            [ benchmark "pre" <|
                \_ -> List.foldr h 0 (List.reverse sampleList)
            , benchmark "post" <|
                \_ -> List.foldl h 0 sampleList
            ]
        , describe "foldr f z (map g l) → foldr (\\x acc -> f (g x) acc) z l"
            [ benchmark "pre" <|
                \_ -> List.foldr h 0 (List.map f sampleList)
            , benchmark "post" <|
                \_ -> List.foldr (\x acc -> h (f x) acc) 0 sampleList
            ]
        , describe "any identity (map f l) → any f l"
            [ benchmark "pre" <|
                \_ -> List.any identity (List.map j sampleList)
            , benchmark "post" <|
                \_ -> List.any j sampleList
            ]
        , describe "all identity (map f l) → all f l"
            [ benchmark "pre" <|
                \_ -> List.all identity (List.map j sampleList)
            , benchmark "post" <|
                \_ -> List.all j sampleList
            ]

        -- the pre of this rule is so bad it causes Chrome to crash on lists of 1k+ elements
        , describe "foldr (\\x acc -> acc ++ [x]) z l → foldl (::) z l"
            [ benchmark "pre" <|
                \_ -> List.foldr (\x acc -> acc ++ [x]) [] smallerSampleList
            , benchmark "post" <|
                \_ -> List.foldl (::) [] smallerSampleList
            ]
        
        -- Tuple.first (List.unzip list) → List.map Tuple.first list
        -- Tuple.second (List.unzip list) → List.map Tuple.second list
        -- Tuple.first (List.partition pred list) → List.filter pred list
        -- Tuple.second (List.partition pred list) → List.filter (pred >> not) list
        ]



main : BenchmarkProgram
main =
    program suite
