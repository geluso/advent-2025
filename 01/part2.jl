function solve(filename)
    dial_position = 50
    zeroes = 0

    println("The dial starts by pointing at ", dial_position)

    file = open(filename, "r")
    lines = readlines(file)
    for line in lines
        direction = line[1]
        steps = parse(Int, line[begin+1:end])

        delta = direction == 'L' ? -1 : 1
        while steps > 0
            dial_position += delta            
            if dial_position == -1
                dial_position = 99
            end

            dial_position %= 100

            if dial_position == 0
                zeroes += 1
            end

            steps -= 1
        end

        println("The dial is rotated ", direction, steps, " to point at ", dial_position)
    end

    println(zeroes)
end

filename = ARGS[1]
solve(filename)

# 43 4C 49 43 4B
# C  L  I  C  K 
