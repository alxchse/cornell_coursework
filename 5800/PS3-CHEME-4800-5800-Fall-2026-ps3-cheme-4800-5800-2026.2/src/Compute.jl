# Student implementation | Complete the three functions in Parts 1 and 2.
# The fourth function, supply_ranges, is the optional Advanced track (set TRACK.txt).
# Supplied support: Types.jl and Factory.jl define/build calculation models;
# Model.jl loads the data; Solver.jl solves; Reporting.jl writes plots and tables.

# Keep the supplied arguments and return fields.
# Replace each placeholder error(...) with your implementation and return value.
# The model argument is the baseline named tuple returned by load_model().
# Build a MyPrimalFluxBalanceAnalysisCalculationModel for each scenario and use
# solve(calculation; A=A, b=b). Keep the baseline data and their arrays unchanged.

# ----------------------------------------------------------------------------
# Part 1a: Select protein production
# ----------------------------------------------------------------------------

"""
    protein_objective(model) -> Vector{Float64}

Build the objective for maximizing protein output in mM/h.

# Arguments

- `model`: a named tuple with a stoichiometric matrix `S` and the integer
  column index `protein` of the protein-output reaction. The index must refer
  to a column of `S`; the caller supplies consistent model data.

# Returns

- A new `Vector{Float64}` with one entry per column of `model.S`. The entry at
  `model.protein` is one; every other entry is zero. Leave the model unchanged.

The coefficients are dimensionless, so `dot(c, flux)` is the protein rate in
mM/h. This output reaction carries positive flux; the urea example uses -1
because its uptake-positive exchange carries a negative flux during export.
"""
function protein_objective(model)

    # Use the number of columns in model.S for its length and model.protein
    # for the nonzero entry; the tests also use smaller, reordered networks.
    c = zeros(Float64, size(model.S, 2)) # declare a new vector of zeros with the same length as the number of columns in model.S
    c[model.protein] = 1.0 # set the entry at model.protein to 1.0
    return c
end


# ----------------------------------------------------------------------------
# Part 1b: Set the amino-acid supply limits
# ----------------------------------------------------------------------------

"""
    allocation_constraints(model, budget::Real; strategy::Symbol=:equal) -> NamedTuple

Construct the bounds and supply constraints for one allocation strategy.

# Arguments

- `model`: a named tuple with `S`, bound vectors `lower` and `upper`, and the
  distinct supply-column indices `amino_acid_uptake`. Supply fluxes are
  nonnegative; there is at least one supply column.
- `budget::Real`: a finite, nonnegative total amino-acid supply limit in mM/h.
- `strategy::Symbol`: `:equal` (default) or `:optimized`.

# Returns

A named tuple with fields `lower`, `upper`, `A`, and `b`. Use
`hcat(lower, upper)` for `calculation.fluxbounds` and pass `A`, `b` to `solve`.
Let K be the number of supply columns and n the number of columns in `model.S`.
Copy both bound vectors; leave the model unchanged. The returned bounds are
length n, and their order must match the columns of `S`.

**Equal allocation (`:equal`).** Set each supply upper bound to
`min(original_upper, budget/K)`.
Return `A=zeros(0, n)` and `b=Float64[]`; the individual limits enforce the budget.

**Optimized allocation (`:optimized`).** Keep the model bounds and add one
inequality limiting the sum of the K supply fluxes to `budget`. Return `A` of size (1,n), with ones in
the supply columns and zeros elsewhere, and a length-one vector `b=[budget]`.

Keep all lower bounds and all other upper bounds unchanged. Both strategies
limit supply rates rather than prescribing them: an upper bound may be unused.
This function constructs constraints only; it does not solve or test feasibility.

# Errors

Throw `ArgumentError` for a negative or nonfinite budget (`Inf`, `-Inf`, or
`NaN`), or a strategy other than `:equal` or `:optimized`.
"""
function allocation_constraints(model, budget::Real; strategy::Symbol=:equal)

    if !isfinite(budget) || budget < 0 # check if the budget is finite and nonnegative
        throw(ArgumentError("budget must be finite and nonnegative"))
    end
    if !(strategy in (:equal, :optimized)) # check if the strategy is either :equal or :optimized
        throw(ArgumentError("strategy must be :equal or :optimized"))
    end

    # Apply the selected allocation rule -
    # For :equal, change only the supply upper bounds using the actual number
    # of supply columns. For :optimized, build the single shared-budget row.
    # For :optimized, keep the original bounds and add one row to A and b.
    # The row sums the supply columns and limits them to the budget.

    lower = copy(model.lower) # copy the lower bounds from the model
    upper = copy(model.upper) # copy the upper bounds from the model
    n = size(model.S, 2) # get the number of columns in model.S

    if strategy == :equal 
        K = length(model.amino_acid_uptake) # get the number of supply columns
        for col in model.amino_acid_uptake # iterate over each supply column index
            upper[col] = min(upper[col], budget / K) # set the upper bound to the minimum of the og upper bound and budget/cols
        end
        A = zeros(Float64, 0, n) # create an empty matrix with 0 rows and n columns for A
        b = Float64[] # create an empty vector for b
    end

    if strategy == :optimized
        A = zeros(Float64, 1, n) # create a matrix with 1 row and n columns for A
        A[1, model.amino_acid_uptake] .= 1.0 # set the entries in the supply columns to 1.0
        b = Float64[budget] # create a vector with one entry equal to the budget for b
    end

    return (lower=lower, upper=upper, A=A, b=b)
end

# ----------------------------------------------------------------------------
# Part 2: Compare production across supply budgets
# ----------------------------------------------------------------------------

"""
    production_curve(model, budgets::AbstractVector{<:Real}) -> Vector{NamedTuple}

Compute protein production under both allocation strategies at each budget.

# Arguments

- `model`: data accepted by `protein_objective` and `allocation_constraints`,
  including `metabolites` and `reactions` identifiers for the calculation model.
- `budgets`: a vector of finite, nonnegative supply limits in mM/h. Its entries
  may be unsorted or repeated; an empty vector is allowed.

# Returns

A vector of named tuples with fields `(budget, equal, optimized)`, one per input
entry in the original order, including duplicates. The budget is in mM/h;
`equal` and `optimized` are protein production rates in micromolar/h (multiply
the protein flux in mM/h by 1000). An empty input returns an empty vector.
Leave the model and budget vector unchanged.

# Method

Set `c = protein_objective(model)` and obtain `limits` from
`allocation_constraints` for each scenario. Following the urea example, use
`build(MyPrimalFluxBalanceAnalysisCalculationModel, data)` with these fields:

- `S = model.S`
- `fluxbounds = hcat(limits.lower, limits.upper)`
- `objective = c`
- `species = model.metabolites`
- `reactions = model.reactions`

Call `solve(calculation; A=limits.A, b=limits.b)` and check the solver status.
Then read the protein entry of `result["argmax"]` and convert it to μM/h.

Start each strategy from the original bounds, so an equal-allocation cap
cannot restrict the optimized solve.

# Errors

Throw `ArgumentError` for any negative or nonfinite budget. If either solve is
not optimal, throw `ErrorException` with the budget, strategy, and solver status
in its message. Check `result["termination_status"] == JuMP.MOI.OPTIMAL` before
reading a flux or objective value.
"""
function production_curve(model, budgets::AbstractVector{<:Real})

    for budget in budgets # iterate over each budget in the input vector
        if !isfinite(budget) || budget < 0 # check if the budget is finite and nonnegative
            throw(ArgumentError("budget must be finite and nonnegative"))
        end
    end

    isempty(budgets) && return NamedTuple[] # return an empty vector of named tuples if the input vector is empty

    c = protein_objective(model) # get the protein objective vector
    production_rows = Vector{NamedTuple}(undef, length(budgets)) # create a vector of named tuples to hold the results

    for (i, budget) in enumerate(budgets) # iterate over each budget with its index
        strategy_production = Dict{Symbol,Float64}() # create a dictionary to hold the production values for each strategy

        for strategy in (:equal, :optimized) # iterate over each strategy
            limits = allocation_constraints(model, budget; strategy=strategy) # get the allocation constraints for the current budget and strategy
            calculation = build(MyPrimalFluxBalanceAnalysisCalculationModel, (
                S=model.S,
                fluxbounds=hcat(limits.lower, limits.upper),
                objective=c,
                species=model.metabolites,
                reactions=model.reactions,
            ))

            result = solve(calculation; A=limits.A, b=limits.b) # solve the optimization problem with the current constraints
            status = result["termination_status"] # get the termination status of the solver
            status == JuMP.MOI.OPTIMAL || # check if the solver status is optimal otherwise throw error
                throw(ErrorException("$strategy allocation solve failed for budget $budget with status $status"))

            strategy_production[strategy] = 1000 * result["argmax"][model.protein] # convert the protein flux to μM/h and store it in the dictionary
        end

        production_rows[i] = ( # create a named tuple for the current budget and its production values
            budget=budget,
            equal=strategy_production[:equal],
            optimized=strategy_production[:optimized],
        )
    end

    return production_rows
end

# ----------------------------------------------------------------------------
# Advanced (Part 3, optional): Find the range of each supply flux
# ----------------------------------------------------------------------------

"""
    supply_ranges(model, budget::Real;
        strategy::Symbol=:equal, fraction::Real=1.0) -> Vector{NamedTuple}

Compute the range of every amino-acid supply flux for one budget and strategy.

# Arguments

- `model`: data accepted by `protein_objective` and `allocation_constraints`,
  including `metabolites` and `reactions` identifiers for the calculation model.
- `budget::Real`: a finite, nonnegative total amino-acid supply limit in mM/h.
- `strategy::Symbol`: `:equal` (default) or `:optimized`.
- `fraction::Real`: the required fraction γ of the maximum protein output, with
  `0 <= fraction <= 1`. The default 1.0 keeps only optimal flux vectors.

# Returns

One named tuple per supply column, in the order of `model.amino_acid_uptake`,
with fields `column` (the column index in `model.S`), `minimum`, and `maximum`.
The endpoints are the smallest and largest values of that supply flux, in mM/h,
over all flux vectors that satisfy the strategy's constraints and reach at least
`fraction` times the maximum protein output. Leave the model unchanged.

Each endpoint comes from its own optimization; the complete set of minima or
maxima need not occur in one feasible flux vector. These ranges describe freedom
within the model, not measurement uncertainty. A zero fraction removes the
positive production requirement; balances and allocation constraints still apply.

# Method

1. Build the limits with `allocation_constraints` and `c = protein_objective(model)`,
   then build a calculation model and call `solve`. Set `z` to
   `result["objective_value"]`, in mM/h.

2. Build `vcat(A, -c')` and `vcat(b, -fraction*z)` from the limits' `A` and `b`.
   The new row requires protein output of at least `fraction*z`; do not relax it
   by a tolerance. `vcat` also converts a `b` that holds integers to `Float64`.

3. For each supply column `j`, solve twice with the strategy's bounds and the new
   arrays. Set the calculation's objective for each solve, either by replacing
   its `objective` field or by building a new calculation model. For the maximum,
   use a vector that is one at `j` and zero elsewhere. For the minimum, use minus
   one at `j` and negate `result["objective_value"]`: the solver always maximizes.
   Keep the original protein vector `c` when forming the production requirement;
   the objectives selecting individual supplies serve a different purpose.

# Errors

Throw `ArgumentError` for an invalid budget or strategy, or for a `fraction` that
is nonfinite or outside [0, 1]. If any solve is not optimal, throw `ErrorException`
with the budget, strategy, and solver status in its message. Check
`result["termination_status"] == JuMP.MOI.OPTIMAL` after every solve before
reading its objective value.
"""
function supply_ranges(model, budget::Real; strategy::Symbol=:equal, fraction::Real=1.0)

    if !isfinite(budget) || budget < 0 # check if the budget is finite and nonnegative
        throw(ArgumentError("budget must be finite and nonnegative"))
    end
    if !(strategy in (:equal, :optimized)) # check if the strategy is either :equal or :optimized
        throw(ArgumentError("strategy must be :equal or :optimized"))
    end
    if !isfinite(fraction) || fraction < 0 || fraction > 1 # check if the fraction is finite and between 0 and 1
        throw(ArgumentError("fraction must be finite and between 0 and 1"))
    end

    limits = allocation_constraints(model, budget; strategy=strategy) # get the allocation constraints for the current budget and strategy
    c = protein_objective(model) # get the protein objective vector

    fluxbounds = hcat(limits.lower, limits.upper) # create a matrix of flux bounds by concatenating the lower and upper bounds horizontally
    calculation = build(MyPrimalFluxBalanceAnalysisCalculationModel, (
        S=model.S,
        fluxbounds=fluxbounds,
        objective=c,
        species=model.metabolites,
        reactions=model.reactions,
    ))

    result = solve(calculation; A=limits.A, b=limits.b) # solve the optimization problem with the current constraints
    status = result["termination_status"] # get the termination status of the solver
    status == JuMP.MOI.OPTIMAL || # check if the solver status is optimal otherwise throw error
        throw(ErrorException("Protein solve failed for budget $budget, strategy $strategy with status $status"))

    z = result["objective_value"] # get the maximum protein output value from the result
    A_required = vcat(limits.A, -c') # create a new matrix by vertically concatenating the original A matrix and the negative transpose of the protein objective vector
    b_required = vcat(Float64.(limits.b), -fraction * z) # create a new vector by vertically concatenating the original b vector and the negative product of fraction and z

    ranges = Vector{NamedTuple}(undef, length(model.amino_acid_uptake)) # create a vector of named tuples to hold the ranges for each supply column

    # For each supply column, solve twice to find the minimum and maximum flux values
    for (i, column) in enumerate(model.amino_acid_uptake)
        maximum_objective = zeros(Float64, size(model.S, 2)) # create a new vector of zeros with the same length as the number of columns in model.S for the maximum objective
        maximum_objective[column] = 1.0 # set the entry at the current supply column index to 1.0 for the maximum objective
        calculation.objective = maximum_objective # set the calculation's objective to the maximum objective vector

        maximum_result = solve(calculation; A=A_required, b=b_required) # solve the optimization problem with the current constraints for the maximum supply
        maximum_status = maximum_result["termination_status"] # get the termination status of the solver for the maximum supply
        maximum_status == JuMP.MOI.OPTIMAL || # check if the solver status is optimal otherwise throw error
            throw(ErrorException("Maximum supply solve failed for budget $budget, strategy $strategy with status $maximum_status"))
        maximum_supply = maximum_result["objective_value"] # get the maximum supply value from the result

        minimum_objective = zeros(Float64, size(model.S, 2)) # create a new vector of zeros with the same length as the number of columns in model.S for the minimum objective
        minimum_objective[column] = -1.0 # set the entry at the current supply column index to -1.0 for the minimum objective
        calculation.objective = minimum_objective # set the calculation's objective to the minimum objective vector

        minimum_result = solve(calculation; A=A_required, b=b_required) # solve the optimization problem with the current constraints for the minimum supply
        minimum_status = minimum_result["termination_status"] # get the termination status of the solver for the minimum supply
        minimum_status == JuMP.MOI.OPTIMAL || # check if the solver status is optimal otherwise throw error
            throw(ErrorException("Minimum supply solve failed for budget $budget, strategy $strategy with status $minimum_status"))
        minimum_supply = -minimum_result["objective_value"] # get the minimum supply value from the result and negate it since we minimized the negative

        # Store the results in the ranges vector as a named tuple with the current supply column index, minimum supply, and maximum supply
        ranges[i] = (
            column=column,
            minimum=minimum_supply,
            maximum=maximum_supply,
        )
    end

    # restore the original protein objective vector to the calculation model
    calculation.objective = c
    return ranges
end
