abstract type AbstractChemicalFormula end
"""
    MyChemicalFormulaModel

The `MyChemicalFormulaModel` type is a mutable struct that represents one molecular
formula read from a manifest file.

### Fields
- `formula`: A string representing the chemical formula
- `characters`: An array of characters representing the individual characters in the formula
- `length`: An integer representing the number of characters in the formula
"""
mutable struct MyChemicalFormulaModel <: AbstractChemicalFormula

    formula::String
    characters::Array{Char,1}
    len::Int64

    # Default constructor -
    MyChemicalFormulaModel() = new(); # `build(...)` populates the fields after allocation, we can leave it empty
end
