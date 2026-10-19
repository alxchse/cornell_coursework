# ===== PRIVATE METHODS BELOW HERE =================================================================================== #
"""
    _element_weight(elementSymbol, atomCount, line_number, masses)

Validate one completed element and return its contribution to the molecular weight.
"""
function _element_weight(elementSymbol::String, atomCount::Int64,
    line_number::Int64, masses::Dict{String, Float64})::Float64
  if atomCount <= 0
    throw(ArgumentError("Formula on line $line_number has a nonpositive atom count for element $elementSymbol."))
  end
  if !haskey(masses, elementSymbol)
    throw(ArgumentError("Element symbol $elementSymbol on line $line_number not found in mass table."))
  end
  return masses[elementSymbol] * atomCount
end
# ===== PRIVATE METHODS ABOVE HERE =================================================================================== #

# ===== PUBLIC METHODS BELOW HERE ==================================================================================== #
"""
    function decode_part_1(models::Dict{Int64, MyChemicalFormulaModel},
        masses::Dict{String, Float64}) -> Tuple{Float64, Dict{Int64, Float64}}

The `decode_part_1` function computes the molecular weight of every formula in the `models` dictionary
using the Part 1 grammar: every element is a single uppercase letter, optionally followed by a positive
integer count written as one or more digits (a missing count means 1). A formula must not be empty.

### Arguments
- `models::Dict{Int64, MyChemicalFormulaModel}`: The parsed manifest. The key is the line number, the value is the formula model.
- `masses::Dict{String, Float64}`: The atomic-mass table. The key is the element symbol, the value is the mass in amu.

### Returns
- A `Tuple` with two elements. The `first` element is the manifest checksum, i.e., the sum of the molecular
  weights of every formula in the manifest, of type `Float64`. The `second` element is a `Dict{Int64, Float64}`
  where the key is the line number and the value is the molecular weight of that line's formula.

### Errors
- An `ArgumentError` is thrown when a formula is empty, contains a nonpositive count, contains a character
  that the Part 1 grammar does not recognize, or uses an element symbol that is not in the mass table.
"""
function decode_part_1(models::Dict{Int64, MyChemicalFormulaModel},
  masses::Dict{String, Float64})::Tuple{Float64, Dict{Int64, Float64}}

  checksum = 0.0 # first element: running total of molecular weights as a Float64
  weights = Dict{Int64, Float64}() # second element: line number => molecular weight

  for (line_number, model) ∈ models # for every line in the manifest, compute the molecular weight of its formula
    formula = model.formula 

    # error case: empty formula is invalid
    if isempty(formula)
      throw(ArgumentError("Formula on line $line_number is empty."))
    end

    # compute the molecular weight of that particular formula
    weight = 0.0 # declare weight as a Float64 for the current formula
    weights[line_number] = weight # store it as a value in the weights dictionary
    elementSymbol = ""
    atomCount = 1
    start = 0

    i = 1
    while i <= model.len # parsing through every char in the formula string

      # error case: formula contains invalid characters (not uppercase letters or digits)
      if !isuppercase(formula[i]) && !isdigit(formula[i])
        throw(ArgumentError("Formula on line $line_number contains invalid characters."))
      end
      
      char = formula[i]

      if isuppercase(char) # if the character is an uppercase letter, it's part of the element symbol
        
        # BASE CASE: we now have a complete element symbol (the previous run) and can compute its contribution to the molecular weight
        if i > 1
          weight += _element_weight(elementSymbol, atomCount, line_number, masses)
        end 
        
        # now declare the new element symbol and reset the atom count
        start = i
        elementSymbol = string(char) # convert the character to a string for lookup in the masses dictionary later
        atomCount = 1 # default count is 1 if no digit follows the element symbol
      end # end if isuppercase

      if isdigit(char) # if the character is a digit, it's part of the atom count
        if i == 1
          throw(ArgumentError("Formula on line $line_number contains a count before an element symbol."))
        end
        atomCount = parse(Int64, formula[start + 1:i]) # parse the complete count for the current element
      end # end if isdigit
      i += 1
    end # end while loop for parsing the formula string

    # now we can actually perform the molecular weight calculation for this formula
    weight += _element_weight(elementSymbol, atomCount, line_number, masses)
    weights[line_number] = weight # store the molecular weight for this line
    checksum += weight # add the molecular weight of this formula to the checksum
  end # end for loop for this line's formula
  return (checksum, weights) # return the checksum and the dictionary of molecular weights
end # end function decode_part_1

"""
    function decode_part_2(models::Dict{Int64, MyChemicalFormulaModel},
        masses::Dict{String, Float64}) -> Tuple{Float64, Dict{Int64, Float64}}

The `decode_part_2` function computes the molecular weight of every formula in the `models` dictionary
using the Part 2 grammar: an element symbol is one uppercase letter followed by zero or more lowercase
letters, optionally followed by a positive integer count written as one or more digits (a missing count
means 1). A formula must not be empty.

### Arguments
- `models::Dict{Int64, MyChemicalFormulaModel}`: The parsed manifest. The key is the line number, the value is the formula model.
- `masses::Dict{String, Float64}`: The atomic-mass table. The key is the element symbol, the value is the mass in amu.

### Returns
- A `Tuple` with two elements. The `first` element is the manifest checksum, i.e., the sum of the molecular
  weights of every formula in the manifest, of type `Float64`. The `second` element is a `Dict{Int64, Float64}`
  where the key is the line number and the value is the molecular weight of that line's formula.

### Errors
- An `ArgumentError` is thrown when a formula is empty, contains a nonpositive count, contains a character
  that the Part 2 grammar does not recognize, or uses an element symbol that is not in the mass table.
"""
function decode_part_2(models::Dict{Int64, MyChemicalFormulaModel},
    masses::Dict{String, Float64})::Tuple{Float64, Dict{Int64, Float64}}

  checksum = 0.0 # first element: running total of molecular weights as a Float64
  weights = Dict{Int64, Float64}() # second element: line number => molecular weight

  for (line_number, model) ∈ models # for every line in the manifest, compute the molecular weight of its formula
    formula = model.formula 

    # error case: empty formula is invalid
    if isempty(formula)
      throw(ArgumentError("Formula on line $line_number is empty."))
    end

    # compute the molecular weight of that particular formula
    weight = 0.0 # declare weight as a Float64 for the current formula
    weights[line_number] = weight # store it as a value in the weights dictionary
    elementSymbol = ""
    atomCount = 1
    start = 0
    countStart = 0

    i = 1
    while i <= model.len # parsing through every char in the formula string

      # error case: formula contains invalid characters (not uppercase letters or digits)
      if !isuppercase(formula[i]) && !islowercase(formula[i]) && !isdigit(formula[i])
        throw(ArgumentError("Formula on line $line_number contains invalid characters."))
      end
      
      char = formula[i]

      if isuppercase(char) # if the character is an uppercase letter, it's part of the element symbol
        
        # BASE CASE: we now have a complete element symbol (the previous run) and can compute its contribution to the molecular weight
        if i > 1
          weight += _element_weight(elementSymbol, atomCount, line_number, masses)
        end 
        
        # now declare the new element symbol and reset the atom count
        start = i
        elementSymbol = string(char) # convert the character to a string for lookup in the masses dictionary later
        atomCount = 1 # default count is 1 if no digit follows the element symbol
        countStart = 0
      end # end if isuppercase

      if islowercase(char)
        # if the character is a lowercase letter, it's just part of the element symbol
        if i == 1 # if the first character is a lowercase letter, it's invalid
          throw(ArgumentError("Formula on line $line_number contains a lowercase letter before an uppercase letter."))
        end
        if isdigit(formula[i - 1]) # if the previous character was a digit, then this lowercase letter is invalid in Part 2 grammar
          throw(ArgumentError("Formula on line $line_number contains lowercase letters after an atom count."))
        end
        elementSymbol *= string(char) # append the lowercase letter to the current element symbol
      end # end if islowercase
      
      if isdigit(char) # if the character is a digit, it's part of the atom count
        if i == 1 # if the first character is a digit, it's invalid
          throw(ArgumentError("Formula on line $line_number contains a count before an element symbol."))
        end
        if i == start + 1 || !isdigit(formula[i - 1]) # if this is the first digit after the element symbol
          countStart = i # mark the start of the count for parsing later
        end
        atomCount = parse(Int64, formula[countStart:i]) # parse the complete count for the current element
      end # end if isdigit
      i += 1
    end # end while loop for parsing the formula string

    # now we can actually perform the molecular weight calculation for this formula
    weight += _element_weight(elementSymbol, atomCount, line_number, masses)
    weights[line_number] = weight # store the molecular weight for this line
    checksum += weight # add the molecular weight of this formula to the checksum
  end # end for loop for this line's formula
  return (checksum, weights) # return the checksum and the dictionary of molecular weights
end # end function decode_part_2
# ===== PUBLIC METHODS ABOVE HERE ==================================================================================== #
