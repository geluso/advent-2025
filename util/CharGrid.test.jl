using Test

include("./CharGrid.jl")

lines = readlines("./CharGrid.test.txt")
grid = CharGrid(lines)

@test grid.rows == 5
@test grid.cols == 4
@test get_cell(grid, 1, 1) == '1'
@test get_cell(grid, grid.rows, grid.cols) == '9'
@test get_cell(grid, 3, 2) == '5'
@test get_cell(grid, 0, 0) === nothing
@test get_cell(grid, 99, 99) === nothing

foreach((cell, row, col) -> println("$(cell) $(row) $(col)"), grid)