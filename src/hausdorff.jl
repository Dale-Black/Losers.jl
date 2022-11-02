### A Pluto.jl notebook ###
# v0.19.13

using Markdown
using InteractiveUtils

# ╔═╡ 9eacf83e-2da5-4e45-9c3f-5d1e243c925e
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate("..")
	using Revise, PlutoUI, Losers, PlutoTest
end

# ╔═╡ 6a0f40ae-375d-4bf5-99ce-9a8872090ad3
TableOfContents()

# ╔═╡ af6254b9-b46a-4b9c-a132-fb0139adf646
md"""
# Hausdorff Loss
"""

# ╔═╡ fa4bda11-6edb-4239-8ce2-825dc57168b3
md"""
## Regular
"""

# ╔═╡ 525f77e0-5afa-11ed-0023-c584662f3e75
"""
	hausdorff(ŷ, y, ŷ_dtm, y_dtm)

Loss function based on the Hausdorff metric. Measures the distance between the boundaries of predicted array `ŷ` and ground truth array `y`. Both the predicted and ground truth arrays require a distance transform `ŷ_dtm` and `y_dtm` as inputs for this boundary operation to work.

[Citation](https://doi.org/10.48550/arXiv.1904.10030)
"""
function hd_loss(ŷ, y, ŷ_dtm, y_dtm)
    M = (ŷ .- y) .^ 2 .* (ŷ_dtm .^ 2 .+ y_dtm .^ 2)
    return mean(M)
end

# ╔═╡ 3d923edb-682c-4827-95f1-5f8a55a810e1
md"""
## Tullio
"""

# ╔═╡ d09dac60-9593-4596-ab2e-2bbea1e15cf2
# TODO: make functional tullio.jl hausdorff loss
# function hausdorff(ŷ, y, ŷ_dtm, y_dtm)
#     @tullio tot :=
#         (ŷ[i, j, k, c, b] .- y[i, j, k, c, b])^2 *
#         (ŷ_dtm[i, j, k, c, b]^2 + y_dtm[i, j, k, c, b]^2)
#     return loss = tot / length(y)
# end

# ╔═╡ 739ee739-f528-4e6f-a935-8c8306c8c8db
md"""
# Tests
"""

# ╔═╡ 3c78a53d-a54a-4fe1-904e-426435f4b5f1
md"""
## 1D
"""

# ╔═╡ 29e10037-b40e-4838-bc0d-c7d04715b2d2
n = rand(10:100)

# ╔═╡ d2add41c-3cd7-4f1f-8ddd-b87d870dea00
let
	y = rand(n)
	ŷ = y

	y_dtm = rand(n)
	ŷ_dtm = y_dtm
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) == 0
end

# ╔═╡ 34f1a4a0-845a-44d7-ae12-75b9470748c8
let
	y = rand(n)
	ŷ = rand(n)

	y_dtm = rand(n)
	ŷ_dtm = rand(n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) != 0
end

# ╔═╡ 9dd2b329-e2e2-4c2b-85cf-3f4239dbe659
md"""
## 2D
"""

# ╔═╡ 82d98c5e-fcb8-47b3-a229-549430e2f583
let
	y = rand(n, n)
	ŷ = y

	y_dtm = rand(n, n)
	ŷ_dtm = y_dtm
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) == 0
end

# ╔═╡ 50ff5136-4f85-48e5-b2e6-364ad8f8a2fc
let
	y = rand(n, n)
	ŷ = rand(n, n)

	y_dtm = rand(n, n)
	ŷ_dtm = rand(n, n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) != 0
end

# ╔═╡ e6d10d26-31ca-45d7-82c5-3f959b96561e
md"""
## 3D
"""

# ╔═╡ f37d54ab-89c5-4f86-bffd-0076372c0261
let
	y = rand(n, n, n)
	ŷ = y

	y_dtm = rand(n, n, n)
	ŷ_dtm = y_dtm
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) == 0
end

# ╔═╡ 1687bf6a-ed40-49b5-a1cc-625907db2ce5
let
	y = rand(n, n, n)
	ŷ = rand(n, n, n)

	y_dtm = rand(n, n, n)
	ŷ_dtm = rand(n, n, n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) != 0
end

# ╔═╡ Cell order:
# ╠═9eacf83e-2da5-4e45-9c3f-5d1e243c925e
# ╠═6a0f40ae-375d-4bf5-99ce-9a8872090ad3
# ╟─af6254b9-b46a-4b9c-a132-fb0139adf646
# ╟─fa4bda11-6edb-4239-8ce2-825dc57168b3
# ╠═525f77e0-5afa-11ed-0023-c584662f3e75
# ╟─3d923edb-682c-4827-95f1-5f8a55a810e1
# ╠═d09dac60-9593-4596-ab2e-2bbea1e15cf2
# ╟─739ee739-f528-4e6f-a935-8c8306c8c8db
# ╟─3c78a53d-a54a-4fe1-904e-426435f4b5f1
# ╠═29e10037-b40e-4838-bc0d-c7d04715b2d2
# ╠═d2add41c-3cd7-4f1f-8ddd-b87d870dea00
# ╠═34f1a4a0-845a-44d7-ae12-75b9470748c8
# ╟─9dd2b329-e2e2-4c2b-85cf-3f4239dbe659
# ╠═82d98c5e-fcb8-47b3-a229-549430e2f583
# ╠═50ff5136-4f85-48e5-b2e6-364ad8f8a2fc
# ╟─e6d10d26-31ca-45d7-82c5-3f959b96561e
# ╠═f37d54ab-89c5-4f86-bffd-0076372c0261
# ╠═1687bf6a-ed40-49b5-a1cc-625907db2ce5
