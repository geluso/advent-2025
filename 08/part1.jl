using Debugger
using DataStructures

include("Point3D.jl")

function solve(filename::String, iterations::Int)
    file = open(filename, "r")
    lines = readlines(file)

    min_distance_heap = MutableBinaryMinHeap{PointToPointDistance}()
    for line1 in lines
        p1 = line_to_point(line1)
        for line2 in lines
            if line1 == line2
                continue
            end
            p2 = line_to_point(line2)
            dd = distance(p1, p2)
            p2p_distance = PointToPointDistance(p1, p2, dd)
            push!(min_distance_heap, p2p_distance)
        end
    end

    sorted_p2p_distances = extract_all!(min_distance_heap)
    seen = Set{String}()
    point_to_set = Dict{Point3D,Set{Point3D}}()
    connections = 0
    for p2p_dd in sorted_p2p_distances
        if connections == iterations
            break
        end

        p1 = p2p_dd.p1
        p2 = p2p_dd.p2
        is_debugging = p1.xx == 31854 || p2.xx == 31854

        key_p1p2 = "$(p1)+$(p2)"
        key_p2p1 = "$(p2)+$(p1)"

        # De-dupe swip swaps
        if in(key_p1p2, seen) || in(key_p2p1, seen)
            # println("$(connections) SKIP p1:$(p1) p2:$(p2)")
            continue
        end

        push!(seen, key_p1p2)
        push!(seen, key_p2p1)
        
        if is_debugging
            @bp
        end

        # Neither of these points have been put in a set yet. Create 1 new one.
        if !haskey(point_to_set, p1) && !haskey(point_to_set, p2)
            connections += 1
            # println("$(connections) CONNECT p1:$(p1) p2:$(p2)")
            ss = Set{Point3D}()
            push!(ss, p1)
            push!(ss, p2)
            get!(point_to_set, p1, ss)
            get!(point_to_set, p2, ss)
        elseif haskey(point_to_set, p1) && haskey(point_to_set, p2)
            s1 = get(point_to_set, p1, nothing)
            s2 = get(point_to_set, p2, nothing)
            # println("s1 $(s1)")
            # println("s2 $(s2)")
            if s1 == s2
                # println("$(connections) IGNORE p1:$(p1) p2:$(p2)")
                continue
            else
                connections += 1
                # println("$(connections) MERGE p1:$(p1) p2:$(p2)")
                # println("  S1 points")
                # for point in s1
                #     println("    $(point)")
                # end
                # println("  S2 points")
                # for point in s2
                #     println("    $(point)")
                # end
                original_s1_size = length(s1)
                original_s2_size = length(s2)
                for point in s2
                    push!(s1, point)
                    get!(point_to_set, point, s1)
                    point_to_set[point] = s1
                end
                new_s1_size = length(s1)
                is_consistent = new_s1_size == original_s1_size + original_s2_size
                if !is_consistent
                    println("  $(new_s1_size)=$(original_s1_size)+$(original_s2_size) $(is_consistent)")
                end
                # if !is_consistent
                #     println("  S1 points")
                #     for point in s1
                #         println("    $(point)")
                #     end
                #     println("  S2 points")
                #     for point in s2
                #         println("    $(point)")
                #     end
                # end

                # println("Verify hash pointers")
                # println("Points pointing in S1")
                # for point in s1
                #     println("  $(point) $(get(point_to_set, point, nothing)))")
                # end
                # println("Points pointing in S2")
                # for point in s2
                #     println("  $(point) $(get(point_to_set, point, nothing)))")
                #     get!(point_to_set, point, s1)
                # end
                # println("Points pointing in S2 AGAIN")
                # for point in s2
                #     println("  $(point) $(get(point_to_set, point, nothing)))")
                # end
            end
        elseif haskey(point_to_set, p1)
            connections += 1
            # println("$(connections) PUSH p2 to p1 $(p1) $(p2)")
            s1 = get(point_to_set, p1, nothing)
            push!(s1, p2)
            get!(point_to_set, p2, s1)
        elseif haskey(point_to_set, p2)
            connections += 1
            # println("$(connections) PUSH p1 to p2 $(p1) $(p2)")
            s2 = get(point_to_set, p2, nothing)
            push!(s2, p1)
            get!(point_to_set, p1, s2)
        end
    end

    max_size_heap = MutableBinaryMaxHeap{Int}()
    for set in Set(values(point_to_set))
        size = length(set)
        println(size, ' ', set)
        push!(max_size_heap, size)
    end

    println(max_size_heap)
    size1 = pop!(max_size_heap)
    size2 = pop!(max_size_heap)
    size3 = pop!(max_size_heap)
    println("$(size1 * size2 * size3) = $(size1) * $(size2) * $(size3)")
end

filename = ARGS[1]
iterations = 10
if occursin("input", filename)
    iterations = 1000
end
solve(filename, iterations)
