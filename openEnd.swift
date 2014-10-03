// a[x...]
struct OpenEnd {
    let start: Int
}

postfix operator ... {}
postfix func ...(index: Int) -> OpenEnd {
    return OpenEnd(start: index)
}

// a[x..<]
struct OpenEndN {
    let start: Int
}

postfix operator ..< {}
postfix func ..<(index: Int) -> OpenEndN {
    return OpenEndN(start: index)
}

// a[...x]
struct OpenStart {
    let end: Int
}

prefix operator ... {}
prefix func ...(index: Int) -> OpenStart{
    return OpenStart(end: index)
}

// a[..<x]
prefix operator ..< {}
prefix func ..<(index: Int) -> OpenStart{
    return OpenStart(end: index-1)
}

// a[x...y], a[-x...y], a[x...-y], a[-x...-y]
struct ClosedRange {
    let start: Int
    let end: Int
}

func ...(startIndex: Int, endIndex: Int) -> ClosedRange {
    return ClosedRange(start: startIndex, end: endIndex)
}

func ..<(startIndex: Int, endIndex: Int) -> ClosedRange {
    return ClosedRange(start: startIndex, end: endIndex-1)
}


//The expression 1... now creates an OpenEnd with start = 1.
//Now, we add an extension to Array so we can use OpenEnd in a subscript.

extension Array {
    subscript (oE: OpenEnd) -> Slice<Element> {
        return self[oE.start...self.count-1]
    }

    subscript (oE: OpenEnd, stride: Int) -> Slice<Element> {
        return self[oE.start...self.count-1, stride]
    }

    subscript (oEN: OpenEndN) -> Slice<Element> {
        return self[oEN.start...self.count-2]
    }

    subscript (oEN: OpenEndN, stride: Int) -> Slice<Element> {
        return self[oEN.start...self.count-2, stride]
    }

    subscript (oS: OpenStart) -> Slice<Element> {
        return self[0...oS.end]
    }

    subscript (oS: OpenStart, stride: Int) -> Slice<Element> {
        return self[0...oS.end, stride]
    }

    subscript(cR: ClosedRange) -> Slice<Element> {
        return self[cR, 1]
    }
    subscript(cR: ClosedRange, stride: Int) ->Slice<Element> {
        var start = cR.start >= 0 ? cR.start : self.count + cR.start
        var end   = cR.end   >= 0 ? cR.end   : self.count + cR.end - 1

        var r: Slice<Element> = []
        if stride < 0{
            for var i = end; i >= start; i+=stride{
                r.append(self[i])
            }
        } else {
            for var i = start ; i <= end ; i+=stride{
                r.append(self[i])
            }
        }
        return r
    }
}

let x = [0,1,2,3,4,5,6,7,8,9,
         10,11,12,13,14,15]

    // Open end
var foo = x[3...]
    foo = x[(-3)...]

    // Open end with step
    foo = x[3..., 4]
    foo = x[(-3)..., 3]

    // Open end, exclusive
    foo = x[3..<]
    foo = x[(-3)..<]

    // Open end, exclusive, with step
    foo = x[3..<, 4]
    foo = x[(-3)..<, 3]

    // Open start
    foo = x[...6]
    foo = x[...(-4)]

    // Open start, with step
    foo = x[...6, 5]
    foo = x[...(-4), 2]

    // Open start, exclusive
    foo = x[..<6]
    foo = x[..<(-4)]

    // Open start, exclusive, with step
    foo = x[..<6, 5]
    foo = x[..<(-4), 2]

    // Range
    foo = x[2...5]
    foo = x[3...(-1)]
    foo = x[(-7)...13]
    foo = x[(-5)...(-2)]

    // Range, with step
    foo = x[2...5, 2]
    foo = x[3...(-1), 3]
    foo = x[(-7)...13, 2]
    foo = x[(-5)...(-2), 2]

    // Range, exclusive
    foo = x[2..<5]
    foo = x[3..<(-1)]
    foo = x[(-7)..<13]
    foo = x[(-5)..<(-2)]

    // Range, exclusive, with step
    foo = x[2..<5, 2]
    foo = x[3..<(-1), 3]
    foo = x[(-7)..<13, 2]
    foo = x[(-5)..<(-2), 2]
