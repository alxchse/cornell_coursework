module L2bFibonacci

export fibonacci_sequence

"""
    fibonacci_sequence(n::Integer) -> Vector{Int64}

Return the vector `[F_0, F_1, ..., F_n]`, where `F_0 = 0`, `F_1 = 1`, and
`F_k = F_{k-1} + F_{k-2}`.

### Arguments
- `n::Integer`: Largest Fibonacci index to compute. The supported range is
  `0 <= n <= 92`. Boolean values are not valid indices.

### Returns
- `Vector{Int64}`: Fibonacci values from `F_0` through `F_n`. Julia arrays use
  one-based indexing, so `F_n` is stored at position `n + 1`.

### Errors
- `ArgumentError`: The input is a Boolean, is negative, or is greater than 92.
  The upper bound prevents `Int64` overflow.
"""
function fibonacci_sequence(n::Integer)::Vector{Int64}

    # TODO 1: Validate the input before allocating the result.
    # Reject Boolean values, negative indices, and indices above 92 with a
    # descriptive ArgumentError.

    if n isa Bool 
        throw(ArgumentError("You passed n as a Bool. The n argument must be a non-negative integer less than or equal to 92."))
    end
    if n < 0
        throw(ArgumentError("You passed a negative value for n. The n argument must be a non-negative integer less than or equal to 92."))
    end
    if n > 92
        throw(ArgumentError("You passed a value for n that exceeds the maximum (92). The n argument must be a non-negative integer less than or equal to 92."))
    end

    # TODO 2: Allocate an Int64 vector with n + 1 positions. Store F_0 in the
    # first position and return immediately when n == 0. Then store F_1 in the
    # second position.

    if n == 0
        return [0]
    end

    fib = Vector{Int64}(undef, n + 1)
    fib[1] = 0
    fib[2] = 1

    # TODO 3: Compute F_2 through F_n from the two preceding values. Use
    # Base.Checked.checked_add so any unexpected overflow raises an error.

    for i in 3:n + 1
        fib[i] = Base.Checked.checked_add(fib[i - 1], fib[i - 2])
    end
    return fib
    
end

# Reject values that do not match the public Integer method with one clear error.
fibonacci_sequence(n) = throw(ArgumentError("n must be an integer index"))

end
