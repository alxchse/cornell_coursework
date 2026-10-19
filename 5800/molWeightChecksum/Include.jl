# Resolve repository-local paths -
const _ROOT = dirname(@__FILE__); # directory containing Include.jl, independent of the caller's working directory
const _PATH_TO_SRC = joinpath(_ROOT, "src"); # student implementation files
const _PATH_TO_DATA = joinpath(_ROOT, "data"); # atomic masses and formula manifests

# Load Julia standard libraries -
using Test # @test, @test_throws, and nested @testset blocks
using SHA  # SHA-256 utilities used by the submission-checking workflow

# Load the assignment implementation in dependency order -
include(joinpath(_PATH_TO_SRC, "Types.jl")); # define the shared model type first
include(joinpath(_PATH_TO_SRC, "Factory.jl")); # construct fully populated model instances
include(joinpath(_PATH_TO_SRC, "Files.jl")); # read manifests and the atomic-mass table
include(joinpath(_PATH_TO_SRC, "Compute.jl")); # calculate line weights and manifest checksums
