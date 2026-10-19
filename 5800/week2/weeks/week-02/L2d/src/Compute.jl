module L2dUnicodeTable

import DataFrames: DataFrame

export character_table

"""
    character_table(text::AbstractString) -> DataFrame

Build one table row for each character in `text`.

### Arguments
- `text::AbstractString`: Text to analyze. The empty string is supported and
  returns an empty table with the documented columns.

### Returns
- `DataFrame`: A table with the columns `position`, `character`,
  `decimal_codepoint`, `unicode_codepoint`, and `utf8_byte_count`. Position is
  the character's ordinal position in the text, not a byte index.

### Errors
- `ArgumentError`: The input is not a string.
"""
function character_table(text::AbstractString)::DataFrame

    # TODO 1: Allocate an empty DataFrame with these typed columns:
    # position::Int, character::Char, decimal_codepoint::Int,
    # unicode_codepoint::String, and utf8_byte_count::Int.
    
    df = DataFrame(
            position = Int[], 
            character = Char[], 
            decimal_codepoint = Int[], 
            unicode_codepoint = String[], 
            utf8_byte_count = Int[]
            )

    # TODO 2: Iterate over enumerate(text). For each character, compute its
    # base-10 code point, format that value as uppercase U+XXXX text, and count
    # the UTF-8 bytes used by string(character). Add the completed row to the
    # table. Do not index the String with 1:length(text).

    for (i, char) in enumerate(text) # enumerate returns tuples of index and character itself
        decimal_codepoint = Int(char)
        unicode_codepoint = "U+" * uppercase(string(decimal_codepoint, base=16, pad=4))
        utf8_byte_count = sizeof(string(char))
        push!(df, (
            position = i,
            character = char,
            decimal_codepoint = decimal_codepoint,
            unicode_codepoint = unicode_codepoint,
            utf8_byte_count = utf8_byte_count
        ))
    end

    # TODO 3: Return the completed DataFrame. The same code should return an
    # empty table with the correct columns when text == "".
    return df
end
end
