function solve(filename)
    file = open(filename, "r")
    lines = readlines(file)
    for line in lines
        println(line)
    end
end

filename = ARGS[1]
solve(filename)
