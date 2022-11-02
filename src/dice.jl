### A Pluto.jl notebook ###
# v0.19.13

using Markdown
using InteractiveUtils

# ╔═╡ 3be2fb08-5af3-11ed-14e8-29e0153c3fd6
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate("..")
	using Revise, PlutoUI, Losers, PlutoTest
end

# ╔═╡ 7beedc0f-78dc-49bb-8b1d-d3d9fe028a6d
TableOfContents()

# ╔═╡ 6619b6d9-ba5c-45a0-82f5-d51f3cb00b7d
md"""
# Dice Loss
"""

# ╔═╡ bff2cc8d-4731-4178-9a12-5dd5fc32bfe6
md"""
## Regular
"""

# ╔═╡ 0a3e4e30-69c7-4cba-b7dd-2a979f3b37f9
"""
	dice(ŷ, y, ϵ=1e-5)

Simple dice loss function. Penalizes based on the overlap between predicted `ŷ` and ground truth `y`. A Dice coefficient of 1 corresponds to perfect overlap and is equal to a Dice loss of 0. A Dice coefficient of 0 corresponds to no overlap and is equal to a Dice loss of 1.

[Citation](https://doi.org/10.48550/arXiv.1707.03237)
"""
function dice(ŷ, y, ϵ=1e-5)
    return loss = 1 - ((2 * sum(ŷ .* y) + ϵ) / (sum(ŷ .* ŷ) + sum(y .* y) + ϵ))
end

# ╔═╡ fe277f06-6ac2-4654-b245-c12aa6d438ea
md"""
## Tullio
"""

# ╔═╡ e60745ee-7748-4036-be48-57da006eeccf
# TODO: make functional tullio.jl dice loss
# function dice(ŷ, y)
#     ϵ = 1e-5
#     @tullio loss :=
#         1 - (
#             (2 * sum(ŷ[i, j, k, c, b] .* y[i, j, k, c, b]) + ϵ) / (
#                 sum(ŷ[i, j, k, c, b] .* ŷ[i, j, k, c, b]) +
#                 sum(y[i, j, k, c, b] .* y[i, j, k, c, b]) +
#                 ϵ
#             )
#         )
# end

# ╔═╡ 1a759c85-d553-4d95-8277-095398059c10
md"""
# Tests
"""

# ╔═╡ b516cc05-b185-411f-b3ea-a44ec102bf93
md"""
## 1D
"""

# ╔═╡ 1173c99a-e684-4ced-8757-dfcf06c92ef2
n = rand(10:100)

# ╔═╡ d06e0911-c59c-4a25-a0ed-70e260fa785c
let
	y = rand(n)
	ŷ = y
	@test dice(ŷ, y) == 0
end

# ╔═╡ 561f3633-524e-465f-a3f7-25a290b693f5
let
	y = rand(n)
	ŷ = rand(n)
	@test dice(ŷ, y) != 0
end

# ╔═╡ c3ca018c-2d63-495a-b327-c7543afdbe69
md"""
## 2D
"""

# ╔═╡ 7bab7bbf-802f-4ff2-a147-8300712bf688
let
	y = rand(n, n)
	ŷ = y
	@test dice(ŷ, y) == 0
end

# ╔═╡ e5a6dad8-6729-4cde-a3f9-3236fcaa3b98
let
	y = rand(n, n)
	ŷ = rand(n, n)
	@test dice(ŷ, y) != 0
end

# ╔═╡ 623d6b6a-f40a-4813-943f-f2883addaf6b
md"""
## 3D
"""

# ╔═╡ 9dc0af23-55e4-49f4-a38f-7f514c202799
let
	y = rand(n, n, n)
	ŷ = y
	@test dice(ŷ, y) == 0
end

# ╔═╡ e97a5721-87db-4c76-b33b-d554443a8d56
let
	y = rand(n, n, n)
	ŷ = rand(n, n, n)
	@test dice(ŷ, y) != 0
end

# ╔═╡ Cell order:
# ╠═3be2fb08-5af3-11ed-14e8-29e0153c3fd6
# ╠═7beedc0f-78dc-49bb-8b1d-d3d9fe028a6d
# ╟─6619b6d9-ba5c-45a0-82f5-d51f3cb00b7d
# ╟─bff2cc8d-4731-4178-9a12-5dd5fc32bfe6
# ╠═0a3e4e30-69c7-4cba-b7dd-2a979f3b37f9
# ╟─fe277f06-6ac2-4654-b245-c12aa6d438ea
# ╠═e60745ee-7748-4036-be48-57da006eeccf
# ╟─1a759c85-d553-4d95-8277-095398059c10
# ╟─b516cc05-b185-411f-b3ea-a44ec102bf93
# ╠═1173c99a-e684-4ced-8757-dfcf06c92ef2
# ╠═d06e0911-c59c-4a25-a0ed-70e260fa785c
# ╠═561f3633-524e-465f-a3f7-25a290b693f5
# ╟─c3ca018c-2d63-495a-b327-c7543afdbe69
# ╠═7bab7bbf-802f-4ff2-a147-8300712bf688
# ╠═e5a6dad8-6729-4cde-a3f9-3236fcaa3b98
# ╟─623d6b6a-f40a-4813-943f-f2883addaf6b
# ╠═9dc0af23-55e4-49f4-a38f-7f514c202799
# ╠═e97a5721-87db-4c76-b33b-d554443a8d56
