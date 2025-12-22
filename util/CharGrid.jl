struct Coordinate
  row::Int
  col::Int
end

struct CharGrid
  rows::Int
  cols::Int
  grid::Vector{String}

  function CharGrid(lines::Vector{String})
    rows = length(lines)
    cols = length(lines[1])
    grid = lines
    new(rows, cols, grid)
  end
end

function is_valid_cell(grid::CharGrid, row::Int, col::Int)
  if row < 1 || col < 1 || row > grid.rows || col > grid.cols
    return false
  end
  return true
end

function get_cell(grid::CharGrid, row::Int, col::Int)
  if !is_valid_cell(grid, row, col)
    return
  end
  return grid.grid[row][col]
end

function set_cell(grid::CharGrid, coord::Coordinate)
  set_cell(grid, coord.row, coord.col)
end

function set_cell(grid::CharGrid, row::Int, col::Int, char::Char)
  if !is_valid_cell(grid, row, col)
    return
  end
  letters = collect(grid.grid[row])
  letters[col] = char
  grid.grid[row] = String(letters)
end

function get_cell_neighbors(grid::CharGrid, row::Int, col::Int)
  top_left = get_cell(grid, row - 1, col - 1)
  top = get_cell(grid, row - 1, col)
  top_right = get_cell(grid, row - 1, col + 1)

  left = get_cell(grid, row, col - 1)
  right = get_cell(grid, row, col + 1)

  bot_left = get_cell(grid, row + 1, col - 1)
  bot = get_cell(grid, row + 1, col)
  bot_right = get_cell(grid, row + 1, col + 1)

  neighbors = filter(item -> item !== nothing, [top_left, top, top_right, left, right, bot_left, bot, bot_right])
  return neighbors
end

function Base.foreach(ff::Function, grid::CharGrid)
  for row in range(1, grid.rows)
    for col in range(1, grid.cols)
      cell = get_cell(grid, row, col)
      ff(cell, row, col)
    end
  end
end