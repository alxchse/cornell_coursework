include("Include.jl") # load the assignment code, data path, and Test standard library


# ----------------------------------------------------------------------------------
# For more information on tests, see: https://docs.julialang.org/en/v1/stdlib/Test/
# ----------------------------------------------------------------------------------

# Testset - let's write a unit test for each *public* function in our code!
@testset verbose = true "PS1 Test Suite Part 1" begin

    @testset "massparse with atomic-masses.csv" begin

        # Setup -
        path_to_mass_file = joinpath(_PATH_TO_DATA, "atomic-masses.csv"); # portable path to the shared mass table

        # Load the mass table -
        masses = massparse(path_to_mass_file); # element symbol => atomic mass (amu)

        # Check the table shape and key/value types -
        @test typeof(masses) == Dict{String, Float64}
        @test length(masses) == 33

        # Spot-check two atomic masses (amu) -
        @test isapprox(masses["C"], 12.011; atol = 1e-6)
        @test isapprox(masses["O"], 15.999; atol = 1e-6)
    end

    @testset "formulaparse with test_part_1.txt" begin

        # Setup -
        path_to_test_file = joinpath(_PATH_TO_DATA, "test_part_1.txt"); # small public Part 1 manifest
        number_of_test_records = 4; # expected number of physical file lines

        # Parse the test manifest -
        d = formulaparse(path_to_test_file); # manifest line number => formula model

        # Check the collection shape and model type -
        @test length(d) == number_of_test_records;
        @test typeof(d) == Dict{Int64, MyChemicalFormulaModel}

        # Check that file line 1 becomes the expected water model -
        @test d[1].formula == "H2O"
        @test d[1].characters == ['H', '2', 'O']
        @test d[1].len == 3
    end

    @testset "decode_part_1 with test_part_1.txt" begin

        # Setup -
        path_to_test_file = joinpath(_PATH_TO_DATA, "test_part_1.txt"); # small public Part 1 manifest
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)

        # Parse the test manifest -
        d = formulaparse(path_to_test_file); # manifest line number => formula model

        # Decode the records -
        (total, weights) = decode_part_1(d, masses); # checksum (amu), plus line number => molecular weight (amu)

        # Check selected line weights and the complete manifest checksum (amu) -
        @test isapprox(weights[1], 18.015; atol = 1e-3)
        @test isapprox(weights[2], 180.156; atol = 1e-3)
        @test isapprox(total, 259.211; atol = 1e-3)
    end

    @testset "decode_part_1 rejects invalid formulas" begin

        # Setup -
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)
        invalid_formulas = [
            "",    # every formula must contain at least one element
            "H0",  # an explicit element count must be positive
            "2H",  # a count cannot appear before an element symbol
            "H-2", # a hyphen is not part of the Part 1 grammar
            "X2",  # X is absent from the supplied atomic-mass table
        ];

        # Check each defensive-interface case independently -
        for formula ∈ invalid_formulas
            model = build(MyChemicalFormulaModel, (formula = formula,)); # isolate one invalid formula
            d = Dict{Int64, MyChemicalFormulaModel}(1 => model); # one-line manifest for the error check
            @test_throws ArgumentError decode_part_1(d, masses)
        end
    end

    @testset "decode_part_1 with production_part_1.txt" begin

        # Setup -
        path_to_production_file = joinpath(_PATH_TO_DATA, "production_part_1.txt"); # full Part 1 manifest
        number_of_production_records = 150; # expected number of physical file lines
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)

        # Parse the production manifest -
        d = formulaparse(path_to_production_file); # manifest line number => formula model

        # Check the collection shape and model type -
        @test length(d) == number_of_production_records;
        @test typeof(d) == Dict{Int64, MyChemicalFormulaModel}

        # Decode the records -
        (total, weights) = decode_part_1(d, masses); # checksum (amu), plus line number => molecular weight (amu)

        # Check the complete production checksum (amu) -
        @test isapprox(total, 113188.572; atol = 1e-3)
    end
end
