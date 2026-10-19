include("Include.jl") # load the assignment code, data path, and Test standard library


# ----------------------------------------------------------------------------------
# For more information on tests, see: https://docs.julialang.org/en/v1/stdlib/Test/
# ----------------------------------------------------------------------------------

# Testset - let's write a unit test for each *public* function in our code!
@testset verbose = true "PS1 Test Suite Part 2" begin

    @testset "decode_part_2 with test_part_2.txt" begin

        # Setup -
        path_to_test_file = joinpath(_PATH_TO_DATA, "test_part_2.txt"); # small public Part 2 manifest
        number_of_test_records = 6; # expected number of physical file lines
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)

        # Parse the test manifest -
        d = formulaparse(path_to_test_file); # manifest line number => formula model
        @test length(d) == number_of_test_records;

        # Decode the records -
        (total, weights) = decode_part_2(d, masses); # checksum (amu), plus line number => molecular weight (amu)

        # Check the complete test-manifest checksum (amu) -
        @test isapprox(total, 524.624; atol = 1e-3)

        # Distinguish cobalt (`Co`) on line 2 from carbon monoxide (`CO`) on line 3 -
        @test isapprox(weights[2], 58.933; atol = 1e-3)
        @test isapprox(weights[3], 28.010; atol = 1e-3)
    end

    @testset "decode_part_1 rejects the Part 2 grammar" begin

        # Setup -
        path_to_test_file = joinpath(_PATH_TO_DATA, "test_part_2.txt"); # contains lowercase symbol characters
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)

        # Parse the test manifest -
        d = formulaparse(path_to_test_file); # manifest line number => formula model

        # Check the Part 1 grammar boundary -
        @test_throws ArgumentError decode_part_1(d, masses);
    end

    @testset "decode_part_2 rejects invalid formulas" begin

        # Setup -
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)
        invalid_formulas = [
            "",     # every formula must contain at least one element
            "H0",   # an explicit element count must be positive
            "2H",   # a count cannot appear before an element symbol
            "H(2)", # parentheses are not part of the Part 2 grammar
            "Xx2",  # Xx is absent from the supplied atomic-mass table
        ];

        # Check each defensive-interface case independently -
        for formula ∈ invalid_formulas
            model = build(MyChemicalFormulaModel, (formula = formula,)); # isolate one invalid formula
            d = Dict{Int64, MyChemicalFormulaModel}(1 => model); # one-line manifest for the error check
            @test_throws ArgumentError decode_part_2(d, masses)
        end
    end

    @testset "decode_part_2 with production_part_2.txt" begin

        # Setup -
        path_to_production_file = joinpath(_PATH_TO_DATA, "production_part_2.txt"); # full Part 2 manifest
        number_of_production_records = 150; # expected number of physical file lines
        masses = massparse(joinpath(_PATH_TO_DATA, "atomic-masses.csv")); # element symbol => atomic mass (amu)

        # Parse the production manifest -
        d = formulaparse(path_to_production_file); # manifest line number => formula model

        # Check the collection shape and model type -
        @test length(d) == number_of_production_records;
        @test typeof(d) == Dict{Int64, MyChemicalFormulaModel}

        # Decode the records -
        (total, weights) = decode_part_2(d, masses); # checksum (amu), plus line number => molecular weight (amu)

        # Check the complete production checksum (amu) -
        @test isapprox(total, 190707.141; atol = 1e-3)
    end
end
