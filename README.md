SwiftInterval
=============

An attempt at emulating Python's slice notation in Swift.=

This attempts to emulate the slice functionality of Python in Swift.  Chiefly, this allows for three things that are, by default
(as of 2014/10/3) not supported:

* Allows the use of open ended ranges
    a[3...]
    a[...9]
* Allows the use of negative indices to represent steps away from the end
    let a = [0,1,2,3,4,5,6,7,8,9]
    a[...(-1)]
    >> [0,1,2,3,4,5,6,7,8]
    a[(-5)...(-2)]
    >> [5,6,7]
* Allows the use of an optional "step" argument that skips over every step places, including negative arguments fo
  incrementing backwards
    a[1..., 2]
    >> [1,3,5,7,9]
    a[0..., -1]
    >> [9,8,7,6,5,4,3,2,1,0]
