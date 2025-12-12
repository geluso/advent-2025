function analyze_range(min_range, max_range)
    ii = parse(Int, min_range)
    max_ii = parse(Int, max_range)

    invalid_ids = 0
    sum_invalid_ids = 0
    while ii <= max_ii
        id = string(ii)

        # Only investigate even strings
        if length(id) % 2 == 0
            midpoint = div(length(id), 2)
            first_half = id[1:midpoint]
            second_half = id[midpoint + 1:end]
            if first_half == second_half
                println("invald ID: ", ii)
                invalid_ids += 1
                sum_invalid_ids += ii
            end
        end
        ii += 1
    end
    return sum_invalid_ids
end

function solve(filename)
    file = open(filename, "r")
    lines = readlines(file)
    line = lines[1]
    ranges = split(line, ',')

    total_sum = 0
    for range in ranges
        min_range, max_range = split(range, '-')
        println(min_range, " to ", max_range)

        sum_invalid_ids = analyze_range(min_range, max_range)
        total_sum += sum_invalid_ids
        println()
    end

    println(total_sum)
end

filename = ARGS[1]
solve(filename)
