function solve(filename)
    dial_position = 50
    zeroes = 0

    println("The dial starts by pointing at ", dial_position)

    file = open(filename, "r")
    lines = readlines(file)
    for line in lines
        direction = line[1]
        rotation = parse(Int, line[begin+1:end])

        if direction == 'L'
            dial_position = dial_position - rotation
        end
        if direction == 'R'
            dial_position = dial_position + rotation
        end

        if dial_position < 0
            dial_position = 100 + dial_position
        end

        dial_position = dial_position % 100

        if dial_position == 0
            zeroes += 1
        end

        println("The dial is rotated ", direction, rotation, " to point at ", dial_position)
    end

    println(zeroes)
end

filename = ARGS[1]
solve(filename)

# 43 4C 49 43 4B
# C  L  I  C  K 
