using Losers
using Test
using ImageMorphology: distance_transform, feature_transform

n = rand(10:100)

@testset "Haussdorf Loss 1D" begin
	y = rand([0, 1], n)
	ŷ = y

    y_dtm = distance_transform(feature_transform(Bool.(y)))
	ŷ_dtm = distance_transform(feature_transform(Bool.(ŷ)))
	@test hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm) == 0

	y = rand([0, 1], n)
	ŷ = rand([0, 1], n)

    y_dtm = distance_transform(feature_transform(Bool.(y)))
	ŷ_dtm = distance_transform(feature_transform(Bool.(ŷ)))
	@test hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm) != 0
end

@testset "Haussdorf Loss 2D" begin
	y = rand([0, 1], n, n)
	ŷ = y

    y_dtm = distance_transform(feature_transform(Bool.(y)))
	ŷ_dtm = distance_transform(feature_transform(Bool.(ŷ)))
	@test hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm) == 0

	y = rand([0, 1], n, n)
	ŷ = rand([0, 1], n, n)

    y_dtm = distance_transform(feature_transform(Bool.(y)))
	ŷ_dtm = distance_transform(feature_transform(Bool.(ŷ)))
	@test hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm) != 0
end

@testset "Haussdorf Loss 3D" begin
	y = rand([0, 1], n, n, n)
	ŷ = y

    y_dtm = distance_transform(feature_transform(Bool.(y)))
	ŷ_dtm = distance_transform(feature_transform(Bool.(ŷ)))
	@test hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm) == 0

	y = rand([0, 1], n, n, n)
	ŷ = rand([0, 1], n, n, n)

    y_dtm = distance_transform(feature_transform(Bool.(y)))
	ŷ_dtm = distance_transform(feature_transform(Bool.(ŷ)))
	@test hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm) != 0
end