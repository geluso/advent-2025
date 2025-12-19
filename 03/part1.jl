function max_jolt(line)
    max_jolt = 0
    max_left = parse(Int, line[1])
    max_right = parse(Int, line[2])
    for (index, character) in zip(range(1, length(line)), line)
        println(index, ' ', character)
        # Only update the left digit if there remains a right digit
        if character > max_left && index < length(line)
            max_left = parse(Int, character)
            max_right = parse(Int, line[index + 1])
        end
    end
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

filename = "sample.txt"
solve(filename)
