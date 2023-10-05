using Losers
using Test

n = rand(10:100)

@testset "Dice Loss 1D" begin
	y = rand(n)
	ŷ = y
	@test dice_loss(ŷ, y) == 0

	y = rand(n)
	ŷ = rand(n)
	@test dice_loss(ŷ, y) != 0
end

@testset "Dice Loss 2D" begin
	y = rand(n, n)
	ŷ = y
	@test dice_loss(ŷ, y) == 0

	y = rand(n, n)
	ŷ = rand(n, n)
	@test dice_loss(ŷ, y) != 0
end

@testset "Dice Loss 3D" begin
	y = rand(n, n, n)
	ŷ = y
	@test dice_loss(ŷ, y) == 0

	y = rand(n, n, n)
	ŷ = rand(n, n, n)
	@test dice_loss(ŷ, y) != 0
end