
(:~
 : Tests for the array datatype and associated functions.
 :)
module namespace arr="http://exist-db.org/test/arrays";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare 
    %test:args(1)
    %test:assertEquals(13)
    %test:args(3)
    %test:assertEquals(14)
function arr:function-item($pos as xs:int) {
    [13, 10, 14]($pos)
};

declare 
    %test:args(1)
    %test:assertEquals(13)
    %test:args(3)
    %test:assertEquals(14)
function arr:function-item2($pos as xs:int) {
    let $a := [13, 10, 14]
    return
        $a($pos)
};

declare
    %test:args(1)
    %test:assertEquals(13)
    %test:args(3)
    %test:assertEquals(14)
function arr:function-item3($pos as xs:int) {
    let $a := [13, 10, 14]
    let $f := function($array as function(*), $position as xs:int) {
        $array($position)
    }
    return
        $f($a, $pos)
};

declare
    %test:assertError("FOAY0001")
function arr:function-item-out-of-bounds() {
    let $a := [13, 10, 14]
    return
        $a(22)
};

declare
    %test:assertError("err:XPTY0004")
function arr:function-item-invalid() {
    let $a := [13, 10, 14]
    return
        $a("x")
};

declare
    %test:args(1)
    %test:assertEmpty
    %test:args(2)
    %test:assertEquals(27, 17, 0)
function arr:square-constructor1($pos as xs:int) {
    let $a := [(), (27, 17, 0)]
    return $a($pos)
};

declare
    %test:args(1)
    %test:assertEquals("<p>test</p>")
    %test:args(2)
    %test:assertEquals(55)
function arr:square-constructor2($pos as xs:int) {
    let $a := [<p>test</p>, 55]
    return $a($pos)
};

declare
    %test:assertEquals(0)
function arr:square-constructor3() {
    let $a := []
    return array:size($a)
};

declare
    %test:args(1)
    %test:assertEquals(27)
    %test:args(2)
    %test:assertEquals(17)
function arr:curly-constructor1($pos as xs:int) {
    let $x := (27, 17, 0)
    let $a := array { $x }
    return $a($pos)
};

declare
    %test:args(1)
    %test:assertEquals(27)
    %test:args(2)
    %test:assertEquals(17)
function arr:curly-constructor2($pos as xs:int) {
    let $a := array { (), (27, 17, 0) }
    return $a($pos)
};

declare
    %test:assertEquals(2)
function arr:with-map1() {
    let $a := [ map { "a": 1, "b": 2 } ]
    return $a(1)("b")
};

declare
    %test:assertEquals(3)
function arr:with-map2() {
    let $a := map { "a": 1, "b": [2, 3, 4] }
    return $a("b")(2)
};

declare
    %test:assertEquals(5)
function arr:nested1() {
    let $a := [ [1, 2, 3], [4, 5, 6] ]
    return $a(2)(2)
};

declare
    %test:assertEquals(5)
function arr:nested2() {
    let $a := array { [1, 2, 3], [4, 5, 6] }
    return $a(2)(2)
};

declare
    %test:args(2)
function arr:size1() {
    array:size([<p>test</p>, 55])
};

declare
    %test:args(1)
function arr:size2() {
    array:size([[]])
};

declare
    %test:assertEquals(3, 4, 5)
function arr:append1() {
    array:append([1, 2], (3, 4, 5))(3)
};

declare
    %test:assertEmpty
function arr:append2() {
    array:append([1, 2], ())(3)
};

declare
    %test:assertEquals("a")
function arr:head1() {
    array:head(["a", "b"])
};

declare
    %test:assertEquals(2)
function arr:head2() {
    array:head([[1, 2], 3, 4, 5])(2)
};

declare
    %test:assertError("FOAY0001")
function arr:head-empty() {
    array:head([])
};

declare
    %test:assertEquals(2)
function arr:tail1() {
    array:tail([1, 2, 3])(1)
};

declare
    %test:assertEquals(2)
function arr:tail2() {
    array:tail([1, [2, 3]])(1)
};

declare
    %test:assertEquals(0)
function arr:tail3() {
    array:size(array:tail([1]))
};

declare
    %test:assertError("FOAY0001")
function arr:tail-empty() {
    array:tail([])
};

declare
    %test:args(2)
    %test:assertEquals("b", "c", "d")
    %test:args(5)
    %test:assertEmpty
function arr:subarray1($start as xs:int) {
    let $a := array:subarray(["a", "b", "c", "d"], $start)
    return
        $a?*
};

declare
    %test:args(5, 0)
    %test:assertEmpty
    %test:args(2, 0)
    %test:assertEmpty
    %test:args(2, 1)
    %test:assertEquals("b")
    %test:args(2, 2)
    %test:assertEquals("b", "c")
    %test:args(4, 1)
    %test:assertEquals("d")
    %test:args(1, 2)
    %test:assertEquals("a", "b")
    %test:args(1, 5)
    %test:assertError("FOAY0001")
    %test:args(0, 1)
    %test:assertError("FOAY0001")
    %test:args(1, "-1")
    %test:assertError("FOAY0002")
function arr:subarray2($start as xs:int, $length as xs:int) {
    let $a := array:subarray(["a", "b", "c", "d"], $start, $length)
    return
        $a?*
};

declare 
    %test:args(1)
    %test:assertEquals("b", "c", "d")
    %test:args(2)
    %test:assertEquals("a", "c", "d")
    %test:args(4)
    %test:assertEquals("a", "b", "c")
    %test:args(0)
    %test:assertError("FOAY0001")
    %test:args(5)
    %test:assertError("FOAY0001")
function arr:remove1($pos as xs:int) {
    array:remove(["a", "b", "c", "d"], $pos)?*
};

declare 
    %test:assertEmpty
function arr:remove2() {
    array:remove(["a"], 1)?*
};

declare 
    %test:assertEquals("d", "c", "b", "a")
function arr:reverse1() {
    array:reverse(["a", "b", "c", "d"])?*
};

declare 
    %test:assertEquals("c", "d", "a", "b")
function arr:reverse2() {
    array:reverse([("a", "b"), ("c", "d")])?*
};

declare 
    %test:assertEquals("1", "2", "3", "4", "5")
function arr:reverse3() {
    array:reverse([(1 to 5)])?*
};

declare 
    %test:assertEmpty
function arr:reverse4() {
    array:reverse([])?*
};

declare 
    %test:assertEmpty
function arr:join1() {
    array:join(())?*
};

declare 
    %test:assertEquals("a", "b", "c", "d")
function arr:join2() {
    array:join((["a", "b"], ["c", "d"], []))?*
};

declare 
    %test:assertEquals(5)
function arr:join3() {
    array:size(array:join((["a", "b"], ["c", "d"], [["e", "f"]])))
};

declare 
    %test:assertEquals("A", "B", "C", "D")
function arr:for-each1() {
    array:for-each(["a", "b", "c", "d"], upper-case#1)?*
};

declare 
    %test:assertEquals("false", "false", "true", "true")
function arr:for-each2() {
    array:for-each(["a", "b", 1, 2], function($z) { $z instance of xs:integer })?*
};

declare 
    %test:assertEquals("1", "2")
function arr:filter1() {
    array:filter(["a", "b", 1, 2], function($z) { $z instance of xs:integer })?*
};

declare 
    %test:assertEquals("a", "b", 1)
function arr:filter2() {
    array:filter(["a", "b", "", 0, 1], boolean#1)?*
};

declare 
    %test:assertEquals("the cat", "on the mat")
function arr:filter3() {
    array:filter(["the cat", "sat", "on the mat"], function($s) { count(tokenize($s, " ")) gt 1 })?*
};

declare 
    %test:assertFalse
function arr:fold-left1() {
    array:fold-left([true(), true(), false()], true(), function($x, $y) { $x and $y })
};

declare 
    %test:assertTrue
function arr:fold-left2() {
    array:fold-left([true(), true(), false()], false(), function($x, $y) { $x or $y })
};

declare 
    %test:assertEquals(1)
function arr:fold-left3() {
    array:fold-left([], 1, function($x, $y) { $x + $y })
};

declare 
    %test:assertEquals(8)
function arr:fold-left4() {
    array:fold-left(["abc", "def", "gh"], 0, function($x, $y) { $x + string-length($y) })
};

declare 
    %test:assertEquals("abcdefgh")
    %test:pending
function arr:fold-left5() {
    array:fold-left(["abc", "def", "gh"], "a", function($x, $y) { $x || $y })
};

declare 
    %test:assertEquals(1)
function arr:fold-left6() {
    array:fold-left([1, 2], (), function($x, $y) { [$x, $y] })?1?2
};

declare 
    %test:assertFalse
function arr:fold-right1() {
    array:fold-right([true(), true(), false()], true(), function($x, $y) { $x and $y })
};

declare 
    %test:assertTrue
function arr:fold-right2() {
    array:fold-right([true(), true(), false()], false(), function($x, $y) { $x or $y })
};

declare 
    %test:assertEquals(2)
function arr:fold-right3() {
    array:fold-right([1, 2, 3], (), function($x, $y) { [$x, $y] })?2?1
};

declare 
    %test:assertEquals(5, 4, 3, 2, 1)
function arr:fold-right4() {
    array:fold-right(
        array { 1 to 5 },
        (),
        function($a, $b) { $b, $a }
    )
};

declare
    %test:assertEquals("AB", "BC", "CD")
function arr:for-each-pair1() {
    let $a := ["A", "B", "C", "D"]
    return
        array:for-each-pair($a, array:tail($a), concat#2)?*
};

declare 
    %test:assertEquals(5, 7, 9)
function arr:for-each-pair2() {
    array:for-each-pair(
        array { 1 to 3 },
        array { 4 to 6 },
        function($a, $b) { $a + $b }
    )?*
};

declare 
    %test:assertEmpty
function arr:for-each-pair3() {
    array:for-each-pair(
        [],
        array { 4 to 6 },
        function($a, $b) { $a + $b }
    )?*
};

declare 
    %test:assertEquals(1, 4, 6, 5, 3)
function arr:flatten1() {
    array:flatten([1, 4, 6, 5, 3])
};

declare 
    %test:assertEquals(1, 2, 5, 10, 11, 12, 13)
function arr:flatten2() {
    array:flatten(([1, 2, 5], [[10, 11], 12], [], 13))
};

declare 
    %test:assertEquals(1, 1, 0, 1, 1)
function arr:flatten3() {
    array:flatten((1, [(1, 0), (1, 1)]))
};

declare 
    %test:assertEmpty
function arr:flatten4() {
    array:flatten(())
};

declare 
    %test:assertEquals("a", "b", "x", "c", "d")
function arr:insert-before1() {
    array:insert-before(["a", "b", "c", "d"], 3, "x")?*
};

declare 
    %test:assertEquals("x", "y")
function arr:insert-before2() {
    array:insert-before(["a", "b", "c", "d"], 3, ("x", "y"))?3
};

declare 
    %test:assertEquals("a", "b", "c", "d", "x")
function arr:insert-before3() {
    array:insert-before(["a", "b", "c", "d"], 5, "x")?*
};

declare 
    %test:assertEquals("array")
function arr:array-type1() {
    let $a := [1, 2]
    return
        typeswitch($a)
            case array(*) return
                "array"
            default return
                "no array"
};