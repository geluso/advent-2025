# Day 08
## Data Structures and Algorithms
* 2D point to point distance matrix for each pairs of points
* Data structure `Point3D` with `xx`, `yy`, `zz` and function `distance(p1, p2)`
  * Need a `toString`, or `key`, or `hash` function defined
* Data structure `PointToPointDistance` with `p1`, `p2`, and `distance`
* 1D sorted list of minimum distances (a min-heap is more efficient)
* HashMap relating point key (xx,yy,zz) to sets of connected points
  * If a point is not connected should it belong in its own set, or not be in a set at all?
  * I prefer disconnected points should not be in sets at all.
  * Points don't have "ownership" over sets. Given a point it is either in a connected set, or not in a set at all.


## Algorithm
* Create the 2D distance matrix.
  * Iterate through the pairs of points
  * For each pair create a `PointToPointDistance` object
  * Add the `PointToPointDistance` object to the min-heap
  * Realizing the min-heap is sufficient. We don't really need the 2D distance matrix.
* After all pairs of distances have been calculated now iterate through the min-heap.
* Iterate `N` times connecting pairs (N=10 for sample, N=1000 for input)
* Iterate through the sets of connected points adding them to a max-heap
  * We only need to track the three highest sets.
  * We can maintain a max-heap with a size limit of three
  * Be careful identifying the sets between the hash map and the heap
  * Be careful to not add a point to a set and have it appear in the heap twice
  * Surely the heap has a `contains` function
  * Traditionally a heap only looks at the weight of an item when it is inserted,
    let's make sure it recalculates the weight of items each time things are added
    in order to make sure items aren't being passively added to the set while it is
    in the heap without the heap being aware of the item growing in size.
* Multiply the sizes of the largest top three sets together!

## JuliaLang notes

### Heap
* https://juliacollections.github.io/DataStructures.jl/latest/heaps/

```julia
using DataStructures

h = MutableBinaryMinHeap{Int}()
h = MutableBinaryMaxHeap{Int}()      # create an empty mutable min/max heap
```

```julia
# Let `h` be a heap, `v` be a value, and `n` be an integer size
length(h)            # returns the number of elements
isempty(h)           # returns whether the heap is empty
empty!(h)            # reset the heap
push!(h, v)          # add a value to the heap
first(h)             # return the first (top) value of a heap
pop!(h)              # removes the first (top) value, and returns it
extract_all!(h)      # removes all elements and returns sorted array
extract_all_rev!(h)  # removes all elements and returns reverse sorted array
sizehint!(h, n)      # reserve capacity for at least `n` elements
```

```julia
# Let `h` be a heap, `i` be a handle, and `v` be a value.
i = push!(h, v)            # adds a value to the heap and and returns a handle to v
update!(h, i, v)           # updates the value of an element (referred to by the handle i)
delete!(h, i)              # deletes the node with handle i from the heap
v, i = top_with_handle(h)  # returns the top value of a heap and its handle
```

### Sets

* https://docs.julialang.org/en/v1/base/collections/
* https://juliacollections.github.io/DataStructures.jl/latest/disjoint_sets/

```julia
s = Set("aaBca")
union(s)
union!(s, "ace", "bar", "car")
in!("ace", s)
```

```julia
using DataStructures
a = DisjointSet{AbstractString}(["a", "b", "c", "d"])
union!(a, "a", "b")
in_same_set(a, "c", "d")
push!(a, "f")
```

## Unit Tests

## Bugs

### Comparator
Need a way to define the heap comparator for my structs `PointToPointDistance`. This error
message implies I need to write a custom `isless()`

```
ERROR: LoadError: MethodError: no method matching isless(::PointToPointDistance, ::PointToPointDistance)
The function `isless` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  isless(::Missing, ::Any)
   @ Base missing.jl:87
  isless(::Any, ::Missing)
   @ Base missing.jl:88
  isless(::Char, ::Char)
   @ Base char.jl:214
  ...
```

I tried writing `isless` and still had the error. I ended up having to write
`Base.isless` and then it worked.

```julia
function Base.isless(d1::PointToPointDistance, d2::PointToPointDistance)
  return isless(d1.distance, d2.distance)
end
```

```julia
function Base.isless(d1::PointToPointDistance, d2::PointToPointDistance)
  return isless(d1.distance, d2.distance)
end
```

### Preventing Swip Swap Dupes

Creating the distances is prone to an error where the distance appears twice
with (p1, p2) and (p2, p1).

Could canonicalize distance where p1 is always "closer to the origin" but this
doesn't feel robust. Two points could be at different places exactly far away
from the origin.


```julia
PointToPointDistance(Point3D(162, 817, 812), Point3D(425, 690, 689), 316.90219311326956)
PointToPointDistance(Point3D(425, 690, 689), Point3D(162, 817, 812), 316.90219311326956)
PointToPointDistance(Point3D(431, 825, 988), Point3D(162, 817, 812), 321.560258738545)
PointToPointDistance(Point3D(162, 817, 812), Point3D(431, 825, 988), 321.560258738545)
PointToPointDistance(Point3D(906, 360, 560), Point3D(805, 96, 715), 322.36935338211043)
PointToPointDistance(Point3D(805, 96, 715), Point3D(906, 360, 560), 322.36935338211043)
PointToPointDistance(Point3D(431, 825, 988), Point3D(425, 690, 689), 328.11888089532425)
PointToPointDistance(Point3D(425, 690, 689), Point3D(431, 825, 988), 328.11888089532425)
```

Solution: keep a set of items added where the set has swip swaps itself.

```
seen = Set()

key_p1p2 = "$(p1)+$(p2)"
key_p2p1 = "$(p2)+$(p1)"

if !in(key_p1p2, seen) or !in(key_p2p1)
  seen.add(key_p1p2)
  seen.add(key_p2p1)
end
```