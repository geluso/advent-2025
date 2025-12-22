include("../util/CharGrid.jl")

function solve(filename)
    file = open(filename, "r")
    lines = readlines(file)
    grid = CharGrid(lines)

    total_removed = 0
    is_removing = true
    while is_removing
        removable = gather_removeable(grid)
        remove(grid, removable)
        removed = length(removable)
        if removed == 0
            is_removing = false
        end
        total_removed += removed
    end
    println(total_removed)
end

function gather_removeable(grid::CharGrid)
    # Accessible rolls of paper have 4 or less neighbors
    removable = Coordinate[]
    foreach(grid) do cell, row, col
        if cell == '.'
            return
        end
        all_neighbors = get_cell_neighbors(grid, row, col)
        paper_neighbors = filter(char -> char == '@', all_neighbors)
        if (length(paper_neighbors) < 4)
            push!(removable, Coordinate(row, col))
        end
    end
    return removable
end

function remove(grid, coordinates)
    foreach(coordinates) do coordinate
        set_cell(grid, coordinate.row, coordinate.col, '.')
    end
end

filename = ARGS[1]
solve(filename)
