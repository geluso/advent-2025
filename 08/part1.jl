using DataStructures

include("Point3D.jl")

function solve(filename::String, iterations::Int, is_part_one::Bool)
    file = open(filename, "r")
    lines = readlines(file)

    min_distance_heap = MutableBinaryMinHeap{PointToPointDistance}()
    foreach(enumerate(lines)) do (ii, line1)
        p1 = line_to_point(line1)
        foreach(enumerate(lines)) do (jj, line2)
            # prevent swip-swapped dupes
            if ii < jj
                p2 = line_to_point(line2)
                dd = distance(p1, p2)
                p2p_distance = PointToPointDistance(p1, p2, dd)
                push!(min_distance_heap, p2p_distance)
            end
        end
    end

    sorted_p2p_distances = extract_all!(min_distance_heap)
    point_to_set = Dict{Point3D,Set{Point3D}}()
    connections = 0

    for p2p_dd in sorted_p2p_distances
        p1 = p2p_dd.p1
        p2 = p2p_dd.p2

        connections += 1
        # Neither of these points have been put in a set yet. Create 1 new one.
        if !haskey(point_to_set, p1) && !haskey(point_to_set, p2)
            println("$(connections) CONNECT p1:$(p1) p2:$(p2)")
            ss = Set{Point3D}()
            push!(ss, p1)
            push!(ss, p2)
            point_to_set[p1] = ss
            point_to_set[p2] = ss
        elseif haskey(point_to_set, p1) && haskey(point_to_set, p2)
            s1 = get(point_to_set, p1, nothing)
            s2 = get(point_to_set, p2, nothing)
            if s1 != s2
                for point in s2
                    push!(s1, point)
                    point_to_set[point] = s1
                end
            end
        elseif haskey(point_to_set, p1)
            s1 = get(point_to_set, p1, nothing)
            push!(s1, p2)
            point_to_set[p2] = s1
        elseif haskey(point_to_set, p2)
            s2 = get(point_to_set, p2, nothing)
            push!(s2, p1)
            point_to_set[p1] = s2
        end

        set = get(point_to_set, p1, nothing)
        println(length(set), " items in set ($(length(lines)) lines)")
        if length(set) == length(lines)
            println(p1.xx * p2.xx)
            break
        end
    end

    if is_part_one
        max_size_heap = MutableBinaryMaxHeap{Int}()
        sets = values(point_to_set)
        unique_sets = Set(sets)
        for set in unique_sets
            size = length(set)
            push!(max_size_heap, size)
        end

        size1 = pop!(max_size_heap)
        size2 = pop!(max_size_heap)
        size3 = pop!(max_size_heap)
        println("$(size1 * size2 * size3) = $(size1) * $(size2) * $(size3)")
    end
end

filename = ARGS[1]
iterations = 10
if occursin("input", filename)
    iterations = 1000
end
solve(filename, iterations, false)
