### A Pluto.jl notebook ###
# v0.19.14

using Markdown
using InteractiveUtils

# ╔═╡ 9eacf83e-2da5-4e45-9c3f-5d1e243c925e
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate("..")
	Pkg.instantiate()
	using Revise, PlutoUI, Losers, PlutoTest, Statistics, Tullio, CUDA
	using CUDA:i32
end

# ╔═╡ dbbf5f4e-b262-4ee0-9dbe-d97fb21cd99d


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
function hausdorff(ŷ, y, ŷ_dtm, y_dtm)
    return loss = mean((ŷ .- y) .^ 2 .* (ŷ_dtm .^ 2 .+ y_dtm .^ 2))
end

# ╔═╡ 3d923edb-682c-4827-95f1-5f8a55a810e1
md"""
## Tullio
"""

# ╔═╡ 7d69d599-a6cb-4034-beb9-894408534b92
md"""
### 1D
"""

# ╔═╡ c16e2ec5-6919-497b-bcc4-153fdb7470a1
"""
	hausdorff_tullio(ŷ::AbstractVector, y::AbstractVector, ŷ_dtm::AbstractVector, y_dtm::AbstractVector)
	
	hausdorff_tullio(ŷ::AbstractMatrix, y::AbstractMatrix, ŷ_dtm::AbstractMatrix, y_dtm::AbstractMatrix)

	hausdorff_tullio(ŷ::AbstractArray, y::AbstractArray, ŷ_dtm::AbstractArray, y_dtm::AbstractArray)

Loss function based on the Hausdorff metric and utilizes [Tullio.jl](https://github.com/mcabbott/Tullio.jl) for increased performance on 1D, 2D, or 3D arrays. Measures the distance between the boundaries of predicted array `ŷ` and ground truth array `y`. Both the predicted and ground truth arrays require a distance transform `ŷ_dtm` and `y_dtm` as inputs for this boundary operation to work.

[Citation](https://doi.org/10.48550/arXiv.1904.10030)
"""
function hausdorff_tullio(ŷ::AbstractVector, y::AbstractVector, ŷ_dtm::AbstractVector, y_dtm::AbstractVector)
    @tullio tot := (ŷ[i] .- y[i])^2 * (ŷ_dtm[i]^2 + y_dtm[i]^2)
    return loss = tot / length(y)
end

# ╔═╡ 75e2e541-6f2e-4749-b0d3-f7096f1338e8
md"""
### 2D
"""

# ╔═╡ d09dac60-9593-4596-ab2e-2bbea1e15cf2
function hausdorff_tullio(ŷ::AbstractMatrix, y::AbstractMatrix, ŷ_dtm::AbstractMatrix, y_dtm::AbstractMatrix)
    @tullio tot := (ŷ[i, j] .- y[i, j])^2 * (ŷ_dtm[i, j]^2 + y_dtm[i, j]^2)
    return loss = tot / length(y)
end

# ╔═╡ 153f3c85-b8a3-4699-8b96-91ee166b1e9c
md"""
### 3D
"""

# ╔═╡ a864253e-5a3a-4fdc-89e8-bfcacaaf1a8b
function hausdorff_tullio(ŷ::AbstractArray, y::AbstractArray, ŷ_dtm::AbstractArray, y_dtm::AbstractArray)
    @tullio tot := (ŷ[i, j, k] .- y[i, j, k])^2 * (ŷ_dtm[i, j, k]^2 + y_dtm[i, j, k]^2)
    return loss = tot / length(y)
end

# ╔═╡ e54e6ce7-2ff3-4505-937e-f62504f76613
md"""
## GPU - CuArray compatible
"""

# ╔═╡ d7261cc2-3b6b-4b0c-b223-faaac574caf2
function _hausdorff_kernel(f, ŷ, y, ŷ_dtm, y_dtm, l, thread_stride, b_max)
    index = threadIdx().x
	i = index + (blockIdx().x - 1i32) * thread_stride
    if i > l
        return
    end

	b_l = blockIdx().x == b_max ? l - (blockIdx().x - 1i32) * thread_stride : thread_stride
    cache = CuDynamicSharedArray(Float64, (thread_stride,))

    @inbounds temp1 = ŷ[i] - y[i]
    @inbounds temp2 = ŷ_dtm[i]
    @inbounds temp3 = y_dtm[i]
    @inbounds cache[index] = muladd(temp2, temp2, temp3*temp3) * temp1 * temp1
    
	sync_threads()
    prev_mid = b_l
    while true
        mid = (prev_mid - 1i32) ÷ 2i32 + 1i32
        if index+mid <= prev_mid
            @inbounds cache[index] += cache[index+mid]
        end
        sync_threads()
        prev_mid = mid
        mid == 1i32 && break
    end
    
    if index == 1i32
        @inbounds CUDA.@atomic f[1] += cache[1]
    end
    return nothing
end

# ╔═╡ a577ff0e-52a0-4518-a48b-164392266821
begin
	k = @cuda launch=false _hausdorff_kernel(CuArray([0]), CuArray{Float32, 1}(undef, 0), CuArray{Float32, 1}(undef, 0), CuArray{Float32, 1}(undef, 0), CuArray{Float32, 1}(undef, 0), 0,0,0)
    GPU_threads = launch_configuration(k.fun).threads
end

# ╔═╡ 3dd96b72-c07f-487c-98b8-23bdcd58f7c7
"""
	hausdorff(ŷ::CuArray, y::CuArray, ŷ_dtm::CuArray, y_dtm::CuArray)

Loss function based on the Hausdorff metric. Measures the distance between the boundaries of predicted array `ŷ` and ground truth array `y`. Both the predicted and ground truth arrays require a distance transform `ŷ_dtm` and `y_dtm` as inputs for this boundary operation to work. GPU version of 'hausdorff'.

[Citation](https://doi.org/10.48550/arXiv.1904.10030)
"""
function hausdorff(ŷ::CuArray, y::CuArray, ŷ_dtm::CuArray, y_dtm::CuArray)
    f = CuArray([0.0])
    l = length(ŷ)

    threads = min(l, GPU_threads)
    blocks = cld(l, threads)

    @cuda threads=threads blocks=blocks shmem=threads*8 _hausdorff_kernel(f, ŷ, y, ŷ_dtm, y_dtm, l,threads, blocks)
    @inbounds CUDA.@allowscalar return f[1]/l
end

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

# ╔═╡ ccb9a7ea-dd0e-4af5-be20-dd9eaf9a5105
let
	y = rand(n)
	ŷ = rand(n)

	y_dtm = rand(n)
	ŷ_dtm = rand(n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) ≈ hausdorff_tullio(ŷ, y, ŷ_dtm, y_dtm)
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

# ╔═╡ c26566ac-f69e-4a31-8281-395e050d4e72
let
	y = rand(n, n)
	ŷ = rand(n, n)

	y_dtm = rand(n, n)
	ŷ_dtm = rand(n, n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) ≈ hausdorff_tullio(ŷ, y, ŷ_dtm, y_dtm)
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

# ╔═╡ 3ba5cc63-d8d6-4586-8e65-e5ec15d88c59
let
	y = rand(n, n, n)
	ŷ = rand(n, n, n)

	y_dtm = rand(n, n, n)
	ŷ_dtm = rand(n, n, n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) ≈ hausdorff_tullio(ŷ, y, ŷ_dtm, y_dtm)
end

# ╔═╡ 46349d0d-1e93-44b6-a58e-2d2f0f7f0c06
let
	y = Bool.(rand([0, 1], n, n, n))
	ŷ = Bool.(rand([0, 1], n, n, n))

	y_dtm = rand(n, n, n)
	ŷ_dtm = rand(n, n, n)
	@test hausdorff(ŷ, y, ŷ_dtm, y_dtm) ≈ hausdorff_tullio(ŷ, y, ŷ_dtm, y_dtm)
end

# ╔═╡ d9dbc443-1724-467f-8da8-c1e09ccd14f8
md"""
## GPU
"""

# ╔═╡ dab5a3d4-5e5d-4d57-8630-bfe59d6ce5cc
let
	y = rand(n)
	ŷ = rand(n)
	y_dtm = rand(n)
	ŷ_dtm = rand(n)
	
	y_GPU = CuArray(y)
	ŷ_GPU  = CuArray(ŷ)
	y_dtm_GPU  = CuArray(y_dtm)
	ŷ_dtm_GPU  = CuArray(ŷ_dtm)

	rslt_cpu = hausdorff(ŷ, y, ŷ_dtm, y_dtm)
	rslt_gpu = hausdorff(ŷ_GPU, y_GPU, ŷ_dtm_GPU, y_dtm_GPU)
	@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
end

# ╔═╡ 2cfd9b05-eb7e-4fd1-b09e-6349b45dc633
let
	y = rand(n, n)
	ŷ = rand(n, n)
	y_dtm = rand(n, n)
	ŷ_dtm = rand(n, n)
	
	y_GPU = CuArray(y)
	ŷ_GPU  = CuArray(ŷ)
	y_dtm_GPU  = CuArray(y_dtm)
	ŷ_dtm_GPU  = CuArray(ŷ_dtm)

	rslt_cpu = hausdorff(ŷ, y, ŷ_dtm, y_dtm)
	rslt_gpu = hausdorff(ŷ_GPU, y_GPU, ŷ_dtm_GPU, y_dtm_GPU)
	@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
end

# ╔═╡ ce51a142-c6ff-41d6-b17c-63b30e1dadf2
let
	y = rand(n, n, n)
	ŷ = rand(n, n, n)
	y_dtm = rand(n, n, n)
	ŷ_dtm = rand(n, n, n)
	
	y_GPU = CuArray(y)
	ŷ_GPU  = CuArray(ŷ)
	y_dtm_GPU  = CuArray(y_dtm)
	ŷ_dtm_GPU  = CuArray(ŷ_dtm)

	rslt_cpu = hausdorff(ŷ, y, ŷ_dtm, y_dtm)
	rslt_gpu = hausdorff(ŷ_GPU, y_GPU, ŷ_dtm_GPU, y_dtm_GPU)
	@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
end

# ╔═╡ 9439da4e-aabd-4971-8d00-94c411aef2f1
let
	y = Bool.(rand([0, 1], n))
	ŷ = Bool.(rand([0, 1], n))
	y_dtm = Bool.(rand([0, 1], n))
	ŷ_dtm = Bool.(rand([0, 1], n))
	
	y_GPU = CuArray(y)
	ŷ_GPU  = CuArray(ŷ)
	y_dtm_GPU  = CuArray(y_dtm)
	ŷ_dtm_GPU  = CuArray(ŷ_dtm)

	rslt_cpu = hausdorff(ŷ, y, ŷ_dtm, y_dtm)
	rslt_gpu = hausdorff(ŷ_GPU, y_GPU, ŷ_dtm_GPU, y_dtm_GPU)
	@test	isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
end

# ╔═╡ 7ce8d1f1-3be4-450d-9268-610fa7b0c02b
let
	y = Bool.(rand([0, 1], n, n))
	ŷ = Bool.(rand([0, 1], n, n))
	y_dtm = Bool.(rand([0, 1], n, n))
	ŷ_dtm = Bool.(rand([0, 1], n, n))
	
	y_GPU = CuArray(y)
	ŷ_GPU  = CuArray(ŷ)
	y_dtm_GPU  = CuArray(y_dtm)
	ŷ_dtm_GPU  = CuArray(ŷ_dtm)

	rslt_cpu = hausdorff(ŷ, y, ŷ_dtm, y_dtm)
	rslt_gpu = hausdorff(ŷ_GPU, y_GPU, ŷ_dtm_GPU, y_dtm_GPU)
	@test	isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
end

# ╔═╡ e9473d2a-46e1-43fc-94a6-99c6b71252d4
let
	y = Bool.(rand([0, 1], n, n, n))
	ŷ = Bool.(rand([0, 1], n, n, n))
	y_dtm = Bool.(rand([0, 1], n, n, n))
	ŷ_dtm = Bool.(rand([0, 1], n, n, n))
	
	y_GPU = CuArray(y)
	ŷ_GPU  = CuArray(ŷ)
	y_dtm_GPU  = CuArray(y_dtm)
	ŷ_dtm_GPU  = CuArray(ŷ_dtm)

	rslt_cpu = hausdorff(ŷ, y, ŷ_dtm, y_dtm)
	rslt_gpu = hausdorff(ŷ_GPU, y_GPU, ŷ_dtm_GPU, y_dtm_GPU)
	@test	isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
end

# ╔═╡ Cell order:
# ╠═9eacf83e-2da5-4e45-9c3f-5d1e243c925e
# ╠═6a0f40ae-375d-4bf5-99ce-9a8872090ad3
# ╟─af6254b9-b46a-4b9c-a132-fb0139adf646
# ╟─fa4bda11-6edb-4239-8ce2-825dc57168b3
# ╠═525f77e0-5afa-11ed-0023-c584662f3e75
# ╟─3d923edb-682c-4827-95f1-5f8a55a810e1
# ╟─7d69d599-a6cb-4034-beb9-894408534b92
# ╠═c16e2ec5-6919-497b-bcc4-153fdb7470a1
# ╟─75e2e541-6f2e-4749-b0d3-f7096f1338e8
# ╠═d09dac60-9593-4596-ab2e-2bbea1e15cf2
# ╟─153f3c85-b8a3-4699-8b96-91ee166b1e9c
# ╠═a864253e-5a3a-4fdc-89e8-bfcacaaf1a8b
# ╟─e54e6ce7-2ff3-4505-937e-f62504f76613
# ╠═d7261cc2-3b6b-4b0c-b223-faaac574caf2
# ╟─a577ff0e-52a0-4518-a48b-164392266821
# ╠═3dd96b72-c07f-487c-98b8-23bdcd58f7c7
# ╟─739ee739-f528-4e6f-a935-8c8306c8c8db
# ╟─3c78a53d-a54a-4fe1-904e-426435f4b5f1
# ╠═29e10037-b40e-4838-bc0d-c7d04715b2d2
# ╠═d2add41c-3cd7-4f1f-8ddd-b87d870dea00
# ╠═34f1a4a0-845a-44d7-ae12-75b9470748c8
# ╠═ccb9a7ea-dd0e-4af5-be20-dd9eaf9a5105
# ╟─9dd2b329-e2e2-4c2b-85cf-3f4239dbe659
# ╠═82d98c5e-fcb8-47b3-a229-549430e2f583
# ╠═50ff5136-4f85-48e5-b2e6-364ad8f8a2fc
# ╠═c26566ac-f69e-4a31-8281-395e050d4e72
# ╟─e6d10d26-31ca-45d7-82c5-3f959b96561e
# ╠═f37d54ab-89c5-4f86-bffd-0076372c0261
# ╠═1687bf6a-ed40-49b5-a1cc-625907db2ce5
# ╠═3ba5cc63-d8d6-4586-8e65-e5ec15d88c59
# ╠═46349d0d-1e93-44b6-a58e-2d2f0f7f0c06
# ╟─d9dbc443-1724-467f-8da8-c1e09ccd14f8
# ╠═dab5a3d4-5e5d-4d57-8630-bfe59d6ce5cc
# ╠═2cfd9b05-eb7e-4fd1-b09e-6349b45dc633
# ╠═ce51a142-c6ff-41d6-b17c-63b30e1dadf2
# ╠═9439da4e-aabd-4971-8d00-94c411aef2f1
# ╠═7ce8d1f1-3be4-450d-9268-610fa7b0c02b
# ╠═e9473d2a-46e1-43fc-94a6-99c6b71252d4
