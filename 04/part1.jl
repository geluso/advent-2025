include("../util/CharGrid.jl")

function solve(filename)
    file = open(filename, "r")
    lines = readlines(file)
    grid = CharGrid(lines)
    # Accessible rolls of paper have 4 or less neighbors
    total_accessible = 0
    foreach(grid) do cell, row, col
        if cell == '.'
            return
        end
        all_neighbors = get_cell_neighbors(grid, row, col)
        paper_neighbors = filter(char -> char == '@', all_neighbors)
        if (length(paper_neighbors) < 4)
            total_accessible += 1
        end
    end
    println(total_accessible)
end

filename = ARGS[1]
solve(filename)
