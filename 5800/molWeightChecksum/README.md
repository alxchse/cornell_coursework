# PS1: Decode the Molecular-Weight Checksum of a Shipping Manifest
Problem set 1 `(PS1)` gives students practice working with [Strings](https://docs.julialang.org/en/v1/manual/strings/#man-strings), [Characters](https://docs.julialang.org/en/v1/manual/strings/#man-characters), [Arrays](https://docs.julialang.org/en/v1/manual/arrays/#man-arrays-1), [Dictionaries](https://docs.julialang.org/en/v1/base/collections/#Base.Dict), [Loops](https://docs.julialang.org/en/v1/manual/control-flow/#man-loops-1), and the function interfaces from Week 2.

Logistics:

* __Dates:__ Problem set 1 (PS1) will be released on Saturday, September 5 and is due (as a zip archive uploaded to Canvas) by 11:59 PM ET on Saturday, September 19. The reference solution will be published in this repository after the due date. You must submit __something__ by the deadline to be opted into the infinite-revision policy. If you do not submit anything by the deadline, you will receive a score of `0` for this assignment, and will be locked out of the infinite-revision policy.
* __Infinite-revision policy:__ After the due date, you may revise and resubmit your work as many times as you like until the end of the semester. Each resubmission will be graded, and the highest score will be recorded. The reference solution will be published in this repository after the due date. Use the reference solution to check your work and to help you understand any mistakes you made. You may also use the reference solution to help you debug your code, __but you may not copy it__. We check for plagiarism, and copying the reference solution will result in a score of `0` for this assignment.
* __Group and AI Policy:__ Students are expected to submit independent work on this assignment. However, you may discuss the problem set with classmates, but you may not directly share code or solutions. You are allowed to use any resources you like, including the Julia documentation, AI tools, and the internet.

## Getting started
This problem set is supported with Julia `1.12.7` and uses only Julia standard libraries; there are no external packages to install.

1. Download the `Source code (zip)` archive from the tagged [PS1 GitHub release](https://github.com/varnerlab/PS1-CHEME-4800-5800-Fall-2026/releases/tag/ps1-cheme-4800-5800-2026.1).
2. Extract the downloaded archive, then open a terminal in the extracted folder that contains this `README.md` file and `check_submission.jl`.
3. Complete the starter code in the `src` directory. Keep any additional solution helpers inside `src` as well.
4. Run `julia --startup-file=no check_submission.jl` from that folder whenever you want to check your progress.

The starter code is intentionally incomplete: it contains `TODO` comments and placeholder errors, so the tests are expected to fail before you begin. Do not edit `testme_part_1.jl`, `testme_part_2.jl`, `check_submission.jl`, or files in `data` to make a failing solution appear to pass. See [RUBRIC.md](RUBRIC.md) for the exact grading rules and completion review.

## The story
A chemical supplier ships you a manifest: a plain-text file with one molecular formula per line. Before the shipment is accepted, the receiving system must recompute the manifest `checksum`: the sum of the molecular weights of every compound listed in the file, in atomic mass units `amu`. Your job is to write the program that parses the manifest and recovers the checksum.

You are given an atomic-mass table in the file `atomic-masses.csv` in the `data` directory. The first line is a header; every following line has the form `symbol,mass`, e.g., `C,12.011`. The molecular weight of a formula is the sum over its elements of the atomic mass of the element multiplied by its count, e.g., the molecular weight of water `H2O` is `2*(1.008) + 15.999 = 18.015 amu`.

`PS1` is divided into two parts.

## Part 1
In Part 1, the manifest uses a simplified formula grammar: every element symbol is a `single uppercase letter`, optionally followed by a positive integer count written as one or more digits. A missing count means `1`, and every formula line must contain at least one element. There are no parentheses, hydrates, or charges.

For example, consider the following `4-line` manifest, provided in the file `test_part_1.txt` in the `data` directory:
```
H2O
C6H12O6
CO2
NH3
```

The molecular weights of these four lines are `18.015`, `180.156`, `44.009`, and `17.031 amu`. Adding these together produces `259.211 amu`, the manifest checksum. Notice the count can have more than one digit: glucose contains `12` hydrogens.

### Tasks Part 1
The public `application programming interface (API)` for this problem set consists of the following types and functions:
1. Create the `MyChemicalFormulaModel` type in the `Types.jl` file. The `MyChemicalFormulaModel` type should be `mutable` and have three fields:
    * The `formula::String` field holds a single formula line of text,
    * The `characters::Array{Char, 1}` field holds the characters of the formula,
    * The `len::Int64` field holds the length (number of characters) of the formula.
2. Create a `build` method in the `Factory.jl` file that takes the `MyChemicalFormulaModel` type and a [NamedTuple](https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple) holding the formula in its `formula` field, and returns a `MyChemicalFormulaModel` instance (with all the fields populated).
3. Complete the implementation of the two functions in the `Files.jl` file:
   - The `formulaparse` function takes a manifest file path as input and returns a [Dictionary](https://docs.julialang.org/en/v1/base/collections/#Base.Dict) whose `key` is the line number (starting from index 1) and whose `value` is a `MyChemicalFormulaModel` instance holding that line's formula.
   - The `massparse` function takes the atomic-mass file path as input and returns a `Dict{String, Float64}` mapping each element symbol to its atomic mass.
4. Complete the implementation of the `decode_part_1` function in the `Compute.jl` file. The `decode_part_1` function takes `models::Dict{Int64, MyChemicalFormulaModel}` and `masses::Dict{String, Float64}` as input and returns a [Tuple](https://docs.julialang.org/en/v1/manual/functions/#Tuples) with two elements:
   - The `first` element should be the overall manifest `checksum` computed by processing `all` the formulas in a file. The checksum is of type `Float64`.
   - The `second` element should be a dictionary of type `Dict{Int64, Float64}` whose `key` is the line number (starting from index 1) and whose `value` is the molecular weight of that line's formula.
   - A formula containing a character the grammar does not recognize, or an element symbol missing from the mass table, should throw a descriptive [ArgumentError](https://docs.julialang.org/en/v1/base/base/#Core.ArgumentError). This is the defensive-interface contract from the Week 2 labs.

The Part 1 decoder must reject malformed formulas rather than skipping or repairing them. For example, an empty formula is invalid because every formula needs at least one element; `H0` is invalid because an explicit element count must be positive; `2H` is invalid because a count cannot appear before an element; `H-2` is invalid because a hyphen is not part of the grammar; and `X2` is invalid because `X` is not present in the supplied atomic-mass table. Each of these cases must throw an `ArgumentError`.

To test your implementation, execute the `testme_part_1.jl` script in the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) by using [the `include(...)` function](https://docs.julialang.org/en/v1/base/base/#Base.include). This checks the functions developed above and the final checksum on the `production_part_1.txt` manifest (`150` formulas). The Part 1 production checksum should be `113188.572 amu` (compared with a tolerance of `0.001`).

## Part 2
As it turns out, the supplier's real manifests draw from the broader, `33`-element mass table supplied with this problem set. Their element symbols can have `one uppercase letter followed by zero or more lowercase letters`: sodium chloride is `NaCl`, and tin(IV) oxide is `SnO2`.

The Part 1 decoder is intentionally restricted to single-letter symbols and must remain that way: its job is to reject Part 2 formulas that contain lowercase letters. Implement the broader grammar separately in `decode_part_2`.

* `Interesting wrinkle`: Case is the only thing separating some inputs. The molecular formula `CO` is carbon monoxide, one carbon and one oxygen, weighing `28.010 amu`. On the other hand, the element symbol `Co` denotes cobalt, weighing `58.933 amu`. Your decoder has to read the characters carefully: an uppercase letter starts a symbol, and any lowercase letters that follow belong to that same symbol. This is the Week 2 lesson about characters and code points: `O` and `o` are different code points, and here they are worth `30.923 amu`.

For example, consider the following `6-line` manifest, provided in the `test_part_2.txt` file in the `data` directory:
```
NaCl
Co
CO
CuSO4
Sn
Mg3N2
```
The molecular weights of these six lines are `58.440`, `58.933`, `28.010`, `159.602`, `118.710`, and `100.929 amu`. Adding these together produces `524.624 amu`, the Part 2 checksum of the test manifest.

### Tasks Part 2
We can use all of the types and functions from [Part 1](#part-1) to solve this problem, except the `decode_part_1` function, because it does not understand multi-letter element symbols. Thus, we need to construct a new function that does:

1. Complete the implementation of the `decode_part_2` function in the `Compute.jl` file. The `decode_part_2` function has the same signature, return contract, and error contract as `decode_part_1`, but reads element symbols under the Part 2 grammar: one uppercase letter followed by zero or more lowercase letters, then an optional positive integer count.

The Part 2 grammar still requires a nonempty formula and excludes zero counts, leading counts, parentheses, hydrates, and charges. For example, an empty formula, `H0`, `2H`, and `H(2)` must throw an `ArgumentError`. A syntactically valid symbol that is absent from the mass table must also throw an `ArgumentError`; the public tests use `Xx2` to check this requirement.

To test your [Part 2](#part-2) implementation, execute the `testme_part_2.jl` script in the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) by using [the `include(...)` function](https://docs.julialang.org/en/v1/base/base/#Base.include). This script also confirms that `decode_part_1` throws an `ArgumentError` when handed a Part 2 manifest, because refusing bad input loudly beats returning a wrong number quietly. The Part 2 production checksum on the `production_part_2.txt` manifest (`150` formulas) should be `190707.141 amu` (compared with a tolerance of `0.001`).

## Checking and submitting your work
When you are done (or as far as you got; partial solutions earn partial credit), run the `check_submission.jl` script from the repository root:

```
julia --startup-file=no check_submission.jl
```

**This script does not connect to Canvas or upload your work.** It runs both test suites, reports what passes, and writes a `MANIFEST.txt` file recording a digest of your source files. If a test fails, review the failure, fix as much as you can, and run the script again. If the deadline is imminent, submit your current work even if a test is still failing: submitting something is required for partial credit and for the infinite-revision policy.

When your work is ready—or before the deadline if you cannot resolve every failure—zip the whole problem-set folder and upload it manually to the PS1 assignment on Canvas. Rename the archive to `CHEME-4800-5800-PS1-<your netid>.zip`, replacing the entire `<your netid>` placeholder, including the angle brackets, with your actual NetID. For example, NetID `abc123` should submit `CHEME-4800-5800-PS1-abc123.zip`. The zip should contain everything: your `src` files, the `data` folder, and the generated `MANIFEST.txt`.
