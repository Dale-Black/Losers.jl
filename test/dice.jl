@testset ExtendedTestSet "dice" begin
    @testset ExtendedTestSet "dice" begin
        ŷ = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        y = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        @test dice(ŷ, y) == 0.0
    end

    @testset ExtendedTestSet "dice" begin
        y1 = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        y2 = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        y = cat(y1, y2; dims=3)

        ŷ1 = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        ŷ2 = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        ŷ = cat(ŷ1, ŷ2; dims=3)
        @test dice(ŷ, y) == 0.0
    end
end