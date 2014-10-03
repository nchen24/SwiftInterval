struct OpenEnd {
    let start: Int
}

postfix operator ... {}
postfix func ...(index: Int) -> OpenEnd {
    return OpenEnd(start: index)
}

struct OpenStart {
    let end: Int
}
prefix operator ... {}
prefix func ...(index: Int) -> OpenStart{
    return OpenStart(end: index)
}

struct ClosedRange {
    let start: Int
    let end: Int
}

func ...(startIndex: Int, endIndex: Int) -> ClosedRange {
    return ClosedRange(start: startIndex, end: endIndex)
}

//The expression 1... now creates an OpenEnd with start = 1.
//Now, we add an extension to Array so we can use OpenEnd in a subscript.

extension Array {
    subscript (openEnd: OpenEnd) -> Slice<Element> {
        return self[openEnd.start...self.count-1]
    }
    subscript (openStart: OpenStart) -> Slice<Element> {
        return self[0...openStart.end]
    }
    subscript(closedRange: ClosedRange) -> Slice<Element> {
        var start = closedRange.start
            var end   = closedRange.end
            if start < 0{
                start = self.count   + start
            }
            if end < 0{
                end = self.count - 1 + end
            }
            return self[start..<end+1]
    }
}

let x = [0,1,2,3,4,5,6,7,8,9]
let y = [4...]
let z = x[3...5]
let c = x[3...(-1)]
let d = x[-3...(-1)]
let e = x[(-1)...]
let f = x[5...]
let g = x[...3]
