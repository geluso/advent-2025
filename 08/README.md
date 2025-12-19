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