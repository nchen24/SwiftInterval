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
    subscript (oEN: OpenEndN) -> Slice<Element> {
        return self[oEN.start...self.count-2]
    }
    subscript (oS: OpenStart) -> Slice<Element> {
        return self[0...oS.end]
    }
    subscript(cR: ClosedRange) -> Slice<Element> {
        let start = cR.start >= 0 ? cR.start : self.count + cR.start
        let end   = cR.end   >= 0 ? cR.end   : self.count + cR.end - 1

        var r: Slice<Element> = []
        for var i = start ; i <= end ; i+=1{
            r.append(self[i])
        }
        return r
    }
}

let x = [0,1,2,3,4,5,6,7,8,9]

let a = x[4...]
let b = x[(-3)...]

let c = x[4..<]
let d = x[(-3)..<]

let e = x[...6]
let f = x[...(-4)]

let g = x[..<6]
let h = x[..<(-4)]

let i = x[2...5]
let j = x[3...(-1)]
let k = x[(-5)...8]
let l = x[(-5)...(-2)]

let m = x[2..<5]
let n = x[3..<(-1)]
let o = x[(-5)..<8]
let p = x[(-5)..<(-2)]
