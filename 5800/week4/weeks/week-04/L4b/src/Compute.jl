module L4bTraversal

using VLDataScienceMachineLearningPackage: MyQueue # FIFO queue introduced in L3b

export adjacency_from_edges, breadth_first_order, depth_first_order

# The adjacency and validation helpers are supplied. Complete only the traversal
# TODOs below; keep the function signatures and the caller's adjacency list unchanged.

"""
    adjacency_from_edges(edges) -> Dict{Int64, Vector{Int64}}

Build a directed adjacency list from `(source, target)` edge pairs. Every vertex
appearing in an edge becomes a key, including vertices with no outgoing edges.
Duplicate edges are removed, and each outgoing-neighbor vector is sorted so
subsequent traversals have a reproducible order.
"""
function adjacency_from_edges(edges)::Dict{Int64, Vector{Int64}}
    # Initialize -
    adjacency = Dict{Int64, Vector{Int64}}() # one outgoing-neighbor vector per vertex

    # Populate directed neighbor lists -
    for edge in edges
        source, target = Int64(edge[1]), Int64(edge[2])
        get!(adjacency, source, Int64[]) # create a list only for a new source; retain earlier neighbors
        get!(adjacency, target, Int64[]) # include targets with no outgoing edges
        push!(adjacency[source], target) # source → target does not imply target → source
    end

    # Remove repeated edges, then sort so input order cannot change neighbor choices -
    for neighbors in values(adjacency)
        sort!(unique!(neighbors))
    end
    return adjacency
end

# Reject missing start vertices and Boolean identifiers (Bool <: Integer in Julia).
function _validate_start(adjacency::AbstractDict, start::Integer)::Int64
    start isa Bool && throw(ArgumentError("start must be a vertex identifier, not Bool"))
    start_id = Int64(start)
    haskey(adjacency, start_id) ||
        throw(ArgumentError("start vertex $(start_id) is not in the graph"))
    return start_id
end

# Work on a fresh vector: unique! and sort! must not change the caller's lists.
# An absent key gives an empty vector, so a vertex with no recorded edges ends a branch.
function _ordered_neighbors(adjacency::AbstractDict, vertex::Int64)::Vector{Int64}
    return sort!(unique!(Int64.(collect(get(adjacency, vertex, Int64[])))))
end

function visit_dfs(vertex::Int64)
    if vertex in visited
        return
    end
    push!(visited, vertex)
    push!(order, vertex)
    for neighbor in _ordered_neighbors(adjacency, start_id)
        visit_dfs(neighbor)
    end

end

"""
    depth_first_order(adjacency::AbstractDict, start::Integer) -> Vector{Int64}

Return every vertex reachable from `start` in deterministic recursive
depth-first order.

### Arguments
- `adjacency::AbstractDict`: Mapping from each vertex identifier to its outgoing
  neighbors. The function does not mutate this mapping or its neighbor lists.
- `start::Integer`: Vertex at which the traversal begins. Boolean values are not
  valid vertex identifiers.

### Returns
- `Vector{Int64}`: Reachable vertices in first-visit order. Outgoing neighbors
  are considered in ascending identifier order.

### Errors
- `ArgumentError`: `start` is a Boolean or is not a key in `adjacency`.
"""
function depth_first_order(adjacency::AbstractDict, start::Integer)::Vector{Int64}

    start_id = _validate_start(adjacency, start)
    visited = Set{Int64}()
    order = Int64[]

    visit_dfs(start_id)
    return order

end

"""
    breadth_first_order(adjacency::AbstractDict, start::Integer) -> Vector{Int64}

Return every vertex reachable from `start` in deterministic breadth-first layer
order.

### Arguments
- `adjacency::AbstractDict`: Mapping from each vertex identifier to its outgoing
  neighbors. The function does not mutate this mapping or its neighbor lists.
- `start::Integer`: Vertex at which the traversal begins. Boolean values are not
  valid vertex identifiers.

### Returns
- `Vector{Int64}`: Reachable vertices in first-visit order. Outgoing neighbors
  are considered in ascending identifier order.

### Errors
- `ArgumentError`: `start` is a Boolean or is not a key in `adjacency`.
"""
function breadth_first_order(adjacency::AbstractDict, start::Integer)::Vector{Int64}

    _validate_start(adjacency, start)
    visited = Set{Int64}()
    order = Int64[]
    queue = MyQueue{Int64}()
    push!(queue, start)
    push!(visited, start)

    while !isempty(queue)
        vertex = popfirst!(queue)
        push!(order, vertex)
        for neighbor in _ordered_neighbors(adjacency, vertex)
            if !(neighbor in visited)
                push!(visited, neighbor)
                push!(queue, neighbor)
            end
        end
    end

    return order
end

end # module L4bTraversal
