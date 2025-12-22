function max_jolt(line)
    println(line)
    max_left = parse(Int, line[1])
    max_right = parse(Int, line[2])
    # Set up this loop offset by one so we can run to the and of the string and
    # always be safely looking back by one
    for index in range(2, length(line))
        first_digit = parse(Int, line[index - 1])
        second_digit = parse(Int, line[index])
        println("max: $(max_left)$(max_right) $(first_digit) $(second_digit)")
        if first_digit > max_left
            max_left = first_digit
            max_right = second_digit
        elseif second_digit > max_right
            max_right = second_digit
        end
    end
    max_jolt = 10 * max_left + max_right
    println(max_jolt, " ", line)
    return max_jolt
end

function solve(filename)
    file = open(filename, "r")
    lines = readlines(file)
    total_jolt = 0
    for line in lines
        total_jolt += max_jolt(line)
    end
    println(total_jolt)
end

filename = ARGS[1]
solve(filename)
