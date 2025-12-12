function is_number_repeating_per_span(digits, span_length)
    first = digits[1 : span_length]
    index = span_length + 1
    while index <= length(digits)
        section = digits[index:index+(span_length-1)]
        if section != first
            return false
        end
        index += span_length
    end
    return true
end

function is_number_repeating(digits)
    index = 1
    while index <= length(digits) / 2
        if length(digits) % index == 0 && is_number_repeating_per_span(digits, index)
            return true
        end
        index += 1
    end
    return false
end

function analyze_range(min_range, max_range)
    ii = parse(Int, min_range)
    max_ii = parse(Int, max_range)

    sum_invalid_ids = 0
    while ii <= max_ii
        id = string(ii)
        if is_number_repeating(id)
            sum_invalid_ids += ii
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
        sum_invalid_ids = analyze_range(min_range, max_range)
        total_sum += sum_invalid_ids
    end

    println(total_sum)
end

filename = ARGS[1]
solve(filename)
