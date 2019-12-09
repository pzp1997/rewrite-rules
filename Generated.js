// map f (map g l) → map (f . g) l
A2(elm$core$List$map, f, A2(elm$core$List$map, g, sampleList));
A2(elm$core$List$map, function (x) { return g(f(x)); }, sampleList);

// reverse (reverse l) → l
elm$core$List$reverse(elm$core$List$reverse(sampleList));
sampleList;

// foldr f z (reverse l) → foldl f z l
A3(elm$core$List$foldr, h, 0, elm$core$List$reverse(sampleList));
A3(elm$core$List$foldl, h, 0, sampleList);

// foldr f z (map g l) → foldr (\x acc -> f (g x) acc) z l
A3(elm$core$List$foldr, h, 0, A2(elm$core$List$map, f, sampleList));
A3(elm$core$List$foldr, F2(function (x, acc) { return A2(h, f(x), acc); }), 0, sampleList);

// any identity (map f l) → any f l
A2(elm$core$List$any, elm$core$Basics$identity, A2(elm$core$List$map, j, sampleList));
A2(elm$core$List$any, j, sampleList);

// all identity (map f l) → all f l
A2(elm$core$List$all, elm$core$Basics$identity, A2(elm$core$List$map, j, sampleList));
A2(elm$core$List$all, j, sampleList);

// foldr (\\x acc -> acc ++ [x]) z l → foldl (::) z l
A3(elm$core$List$foldr, F2(function (x, acc) { return _Utils_ap(acc, _List_fromArray([x]));}), _List_Nil, smallerSampleList);
A3(elm$core$List$foldl, elm$core$List$cons, _List_Nil, smallerSampleList);