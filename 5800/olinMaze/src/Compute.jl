# Complete the four functions below. You may add helper functions in
# Compute.jl or separate files inside src/. Load helper files from Include.jl;
# all library-file include calls belong in Include.jl. Document each helper's
# purpose, arguments, and return value.

"""
    neighbors(maze::MyMazeModel, position::Position) -> Vector{Position}

Find the cells one step up, down, left, or right from `position`, excluding
walls. Part 2's `nextstates(...)` checks whether you can enter a door.

### Arguments

- `maze::MyMazeModel`: The maze to inspect. Its cell matrix is not modified.
- `position::Position`: The current `(row, column)`, using one-based indices.
  The position must be inside the map and must not be a wall.

### Returns

- `Vector{Position}`: Neighboring cells inside the map that are not walls.
  Include each position once, in any order. Include neighboring `S`, `E`, `K`,
  and `D` cells. Return an empty vector when there are no such neighbors.

### Errors

- `ArgumentError`: `position` is outside the map or identifies a wall.
"""
function neighbors(maze::MyMazeModel, position::Position)::Vector{Position}

  # declare row and column for clarity
  row, col = position

  # check if the current position is in bounds and not a wall
  if !(row >= 1 && row <= size(maze.cells, 1) && col >= 1 && col <= size(maze.cells, 2))
    throw(ArgumentError("Position $position is outside the map."))
  end
  
  if (maze.cells[row, col] == '#')
    throw(ArgumentError("Position $position identifies a wall."))
  end

  # declare an empty vector to hold the adjacent positions
  adjacent = Position[]

  # for each of the four possible neighbors (up, down, left, right)
  for neighbor in ((row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1))
    neighbor_row, neighbor_col = neighbor # separate the rows and cols
    # ensure that the neighbor is in bounds and not a wall, then add it to the adjacent vector
    if neighbor_row >= 1 && neighbor_row <= size(maze.cells, 1) &&
      neighbor_col >= 1 && neighbor_col <= size(maze.cells, 2) &&
      maze.cells[neighbor_row, neighbor_col] != '#'
      push!(adjacent, neighbor)
    end
  end
  
  return adjacent

end

"""
    escape_part_1(maze::MyMazeModel) -> Union{Nothing, Vector{Position}}

Find a route from the start to the exit with the fewest moves using breadth-first
search and `MyQueue`. Each move goes one cell up, down, left, or right.

### Arguments

- `maze::MyMazeModel`: A maze containing only `#`, `.`, `S`, and `E`. The model
  and its cell matrix are not modified.

### Returns

- `Vector{Position}`: A shortest route in travel order, including the start
  and exit. Each step moves to a neighboring cell without entering a wall.
  Any shortest route is accepted. Its move count is `length(route) - 1`.
- `nothing`: The exit is unreachable from the start.

### Errors

- `ArgumentError`: The map contains `K` or `D`, which require the Part 2 solver.
"""
function escape_part_1(maze::MyMazeModel)::Union{Nothing, Vector{Position}}

  # if the maze contains a K or D, throw an error since that's part 2
  if any(maze.cells .== 'K') || any(maze.cells .== 'D')
    throw(ArgumentError("Map contains K or D, which requires the Part 2 solver."))
  end

  # declarations for queue, discovered set, and predecessors dictionary
  queue = MyQueue{Position}()
  discovered = Set{Position}([maze.start])
  predecessors = Dict{Position, Union{Nothing, Position}}(maze.start => nothing) # i had AI do this one
  push!(queue, maze.start) # add the start position to the queue

  # while loop to process the queue until it's empty
  while !isempty(queue)
    current = popfirst!(queue) # pop the first position from the queue
    
    if current == maze.goal # if the current position is the goal, reconstruct the path
      path = Position[] # declare an empty vector to hold the path
      while current !== nothing # while the current position is not nothing (which would be at the start)
        push!(path, current) # add the current position to the path
        current = predecessors[current] # move to the predecessor of the current position
      end
      return reverse(path) # reverse the path to get it in travel order and return it
    end

    # for each neighbor of the current position
    for neighbor in neighbors(maze, current)
      if !(neighbor in discovered) # if the neighbor has not been discovered yet
        push!(discovered, neighbor) # add the neighbor to the discovered set
        predecessors[neighbor] = current # set the predecessor of the neighbor to the current position
        push!(queue, neighbor) # add the neighbor to the queue for further exploration
      end
    end
  end
  return nothing # if the queue is empty and the goal was not found, return nothing
end

"""
    nextstates(maze::MyMazeModel, state::EscapeState) -> Vector{EscapeState}

Find the states you can reach in one move from `state`. Entering `K` collects
your CornellID automatically. You can enter `D` only if you already have your
CornellID. You keep the ID for the rest of the route and can open every door.

### Arguments

- `maze::MyMazeModel`: The maze to inspect. Its cell matrix is not modified.
- `state::EscapeState`: The current `(row, column, has_cornell_id)`, recorded after
  entering the cell. Check for the invalid inputs listed under Errors. The
  state does not have to be reachable from the start.

### Returns

- `Vector{EscapeState}`: States you can reach by moving one cell up, down,
  left, or right. Include each state once, in any order. Set `has_cornell_id`
  to `true` when entering `K` and keep it `true` afterward. Return an empty
  vector when you cannot move to any neighboring cell.

### Errors

- `ArgumentError`: The current position is outside the map or is a wall, or
  its cell is `K` or `D` while `has_cornell_id` is `false`.
"""
function nextstates(maze::MyMazeModel, state::EscapeState)::Vector{EscapeState}
  
  # declare row, column, and has_cornell_id for clarity
  row, col, has_cornell_id = state
  position = (row, col) # declare position for clarity
  
  # check if the current position is in bounds and not a wall, as we did before
  if !(row >= 1 && row <= size(maze.cells, 1) && col >= 1 && col <= size(maze.cells, 2))
    throw(ArgumentError("Position $position is outside the map."))
  end
  
  if (maze.cells[row, col] == '#')
    throw(ArgumentError("Position $position identifies a wall."))
  end

  # also check to make sure that if the current position is a K or D, has_cornell_id is true
  if (maze.cells[row, col] in ('K', 'D') && !has_cornell_id)
    throw(ArgumentError("Position $position requires has_cornell_id to be true."))
  end

  # declare an empty vector to hold the next states
  next_states = EscapeState[]

  # for each neighbor of the current position
  for neighbor in neighbors(maze, position)
    cell = maze.cells[neighbor[1], neighbor[2]] # get the cell value at the neighbor's position
    
    # if the neighbor is K, set next_has_cornell_id to true
    if (has_cornell_id || cell == 'K')
      next_has_cornell_id = true
    else
      next_has_cornell_id = false
    end

    # if the neighbor is D and next_has_cornell_id is false, skip this neighbor
    if (cell == 'D' && !next_has_cornell_id)
      continue
    end

    # add the neighbor's position and next_has_cornell_id to the next_states vector
    push!(next_states, (neighbor[1], neighbor[2], next_has_cornell_id))
  end

  return next_states # return the vector of next states

end

"""
    escape_part_2(maze::MyMazeModel) -> Union{Nothing, Vector{EscapeState}}

Find a route with the fewest moves using breadth-first search over
`(row, column, has_cornell_id)` states. Use `MyQueue` to hold states waiting
to be explored and `nextstates(...)` to find the states you can reach next.

### Arguments

- `maze::MyMazeModel`: A maze with at most one CornellID and any number of doors.
  Maps without a CornellID or doors are also accepted. The model and its
  cell matrix are not modified.

### Returns

- `Vector{EscapeState}`: A shortest route in travel order, starting at
  `(maze.start[1], maze.start[2], false)` and ending at the exit, with or
  without your CornellID. Include the start and exit; the move count is
  `length(route) - 1`. Any shortest route is accepted. The route may skip the
  CornellID if no door is needed, or revisit a cell after collecting the ID.
- `nothing`: There is no route to the exit. Return `nothing` rather than
  throwing an error when the exit is unreachable.
"""
function escape_part_2(maze::MyMazeModel)::Union{Nothing, Vector{EscapeState}}

  # declare the start state, queue, discovered set, and predecessors dictionary
  start_state = (maze.start[1], maze.start[2], false)
  queue = MyQueue{EscapeState}()
  discovered = Set{EscapeState}([start_state])
  predecessors = Dict{EscapeState, Union{Nothing, EscapeState}}(start_state => nothing)
  push!(queue, start_state)

  # while loop to process the queue until it's empty
  while !isempty(queue)
    current = popfirst!(queue) # pop the first state from the queue
    
    if (current[1], current[2]) == maze.goal # if the current position is the goal, reconstruct the path
      path = EscapeState[] # declare an empty vector to hold the path
      while current !== nothing # while the current state is not nothing (which would be at the start)
        push!(path, current) # add the current state to the path 
        current = predecessors[current] # move to the predecessor of the current state
      end
      return reverse(path) # reverse the path to get it in travel order and return it
    end

    # for each next state reachable from the current state
    for next_state in nextstates(maze, current)
      if !(next_state in discovered) # if the next state has not been discovered yet
        push!(discovered, next_state) # add the next state to the discovered set
        predecessors[next_state] = current # set the predecessor of the next state to the current state
        push!(queue, next_state) # add the next state to the queue for further exploration
      end
    end
  end

  return nothing # if the queue is empty and the goal was not found, return nothing

end
