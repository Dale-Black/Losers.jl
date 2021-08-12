@testset ExtendedTestSet "hausdorff" begin
    @testset ExtendedTestSet "hausdorff" begin
        y1 = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        y = cat(y1, y1; dims=3)
        ŷ = copy(y)

        ŷ_dtm1 = [
            3.0  2.0  1.0  0.0
            3.0  2.0  1.0  0.0
            3.0  2.0  1.0  0.0
            3.0  2.0  1.0  0.0
        ]
        ŷ_dtm = cat(ŷ_dtm1, ŷ_dtm1, dims=3)
        y_dtm = copy(ŷ_dtm)

        @test hausdorff(ŷ, y, ŷ_dtm, y_dtm) == 0.0
    end

    @testset ExtendedTestSet "hausdorff" begin
        y1 = [1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0]
        y = cat(y1, y1; dims=3)
        ŷ = copy(y)

        ŷ_dtm1 = [
            0.0  0.0  0.0  3.0
            0.0  0.0  0.0  3.0
            0.0  0.0  0.0  3.0
            0.0  0.0  0.0  3.0
        ]
        ŷ_dtm = cat(ŷ_dtm1, ŷ_dtm1, dims=3)
        y_dtm = copy(ŷ_dtm)

        @test hausdorff(ŷ, y, ŷ_dtm, y_dtm) == 0.0
    end
end