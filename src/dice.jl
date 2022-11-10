### A Pluto.jl notebook ###
# v0.19.14

using Markdown
using InteractiveUtils

# ╔═╡ 3be2fb08-5af3-11ed-14e8-29e0153c3fd6
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate("..")
	using Revise, PlutoUI, Losers, PlutoTest, CUDA
	using CUDA:i32
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

# ╔═╡ e5f2575f-5e12-44fa-9364-f44b68b7ac18
md"""
## GPU - CuArray compatible
"""

# ╔═╡ f3eae42a-8686-4213-83c9-65ce48240d4d
function _dice_kernel(f, x, y, l, thread_stride, j, b_max)
    index = threadIdx().x
	i = index + (blockIdx().x - 1i32) * thread_stride

    if i > l
		return
    end
	
    b_l = blockIdx().x == b_max ? l - (blockIdx().x - 1i32) * thread_stride : thread_stride
    cache = CuDynamicSharedArray(Float64, (thread_stride,))

	@inbounds cache[index] = x[i] * y[i]
		
    sync_threads()
    prev_mid = b_l
    while true
        mid = (prev_mid - 1i32) ÷ 2i32 + 1i32
        if index+mid <= prev_mid
            @inbounds cache[index] += cache[index+mid]
        end
        prev_mid = mid
        sync_threads()
        mid == 1i32 && break
    end
    
    if index == 1i32
        @inbounds CUDA.@atomic f[j] += cache[1]
    end
    return nothing
end

# ╔═╡ 6933edad-970b-4e09-b275-a925c8e695a2
"""
	dice(ŷ::CuArray, y::CuArray, ϵ=1e-5)

Simple dice loss function. Penalizes based on the overlap between predicted `ŷ` and ground truth `y`. A Dice coefficient of 1 corresponds to perfect overlap and is equal to a Dice loss of 0. A Dice coefficient of 0 corresponds to no overlap and is equal to a Dice loss of 1. GPU version of 'Dice'.

[Citation](https://doi.org/10.48550/arXiv.1707.03237)
"""
function dice(ŷ::CuArray, y::CuArray, ϵ=1e-5)
	f = CuArray([0.0, 0.0])
	l = length(ŷ)
	
	k = @cuda launch=false _dice_kernel(f, ŷ, y, l, 0, 0, 0)
    GPU_threads = launch_configuration(k.fun).threads
	t = min(l, GPU_threads)
    b= cld(l, t)
	
    k(f, ŷ, y, l, t, 1, b; threads=t, blocks=b, shmem=t*8)
	k(f, ŷ, ŷ, l, t, 2, b; threads=t, blocks=b, shmem=t*8)
	k(f, y, y, l, t, 2, b; threads=t, blocks=b, shmem=t*8)

    f = Array(f)
    @inbounds return 1 - muladd(2, f[1], ϵ) / (f[2] + ϵ)
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

# ╔═╡ ca0b25bd-329f-496d-8460-0504d2ae0938
md"""
## GPU
"""

# ╔═╡ 1c61d537-f8fe-4f67-831e-051939056255
# let
# 	if has_cuda_gpu()
# 		y = rand(n)
# 		ŷ = rand(n)
		
# 		y_GPU = CuArray(y)
# 		ŷ_GPU = CuArray(ŷ)
	
# 		rslt_cpu = dice(ŷ, y)
# 		rslt_gpu = dice(ŷ_GPU, y_GPU)
# 		@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
# 	end
# end

# ╔═╡ 68d82e76-5175-4e8a-aeea-1bf83c1dddfa
# let
# 	if has_cuda_gpu()
# 		y = rand(n, n)
# 		ŷ = rand(n, n)
		
# 		y_GPU = CuArray(y)
# 		ŷ_GPU = CuArray(ŷ)
	
# 		rslt_cpu = dice(ŷ, y)
# 		rslt_gpu = dice(ŷ_GPU, y_GPU)
# 		@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
# 	end
# end

# ╔═╡ 7a22ca61-04fb-4a58-8e9b-a4b76857be06
# let
# 	if has_cuda_gpu()
# 		y = rand(n, n, n)
# 		ŷ = rand(n, n, n)
		
# 		y_GPU = CuArray(y)
# 		ŷ_GPU = CuArray(ŷ)
	
# 		rslt_cpu = dice(ŷ, y)
# 		rslt_gpu = dice(ŷ_GPU, y_GPU)
# 		@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
# 	end
# end

# ╔═╡ d175c618-0781-42d3-956c-931f6bd8a246
# let
# 	if has_cuda_gpu()
# 		y = Bool.(rand([0, 1], n))
# 		ŷ = Bool.(rand([0, 1], n))
		
# 		y_GPU = CuArray(y)
# 		ŷ_GPU = CuArray(ŷ)
		
# 		rslt_cpu = dice(ŷ, y)
# 		rslt_gpu = dice(ŷ_GPU, y_GPU)
# 		@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
# 	end
# end

# ╔═╡ c5dedcf1-5434-4094-b890-ae3b1da423f1
# let
# 	if has_cuda_gpu()
# 		y = Bool.(rand([0, 1], n, n))
# 		ŷ = Bool.(rand([0, 1], n, n))
		
# 		y_GPU = CuArray(y)
# 		ŷ_GPU = CuArray(ŷ)
		
# 		rslt_cpu = dice(ŷ, y)
# 		rslt_gpu = dice(ŷ_GPU, y_GPU)
# 		@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
# 	end
# end

# ╔═╡ 2a2b3b27-680a-45b4-9472-0abcbd4ae3e7
# let
# 	if has_cuda_gpu()
# 		y = Bool.(rand([0, 1], n, n, n))
# 		ŷ = Bool.(rand([0, 1], n, n, n))
		
# 		y_GPU = CuArray(y)
# 		ŷ_GPU = CuArray(ŷ)
		
# 		rslt_cpu = dice(ŷ, y)
# 		rslt_gpu = dice(ŷ_GPU, y_GPU)
# 		@test isapprox(rslt_cpu, rslt_gpu; rtol = 1e-10)
# 	end
# end

# ╔═╡ Cell order:
# ╠═3be2fb08-5af3-11ed-14e8-29e0153c3fd6
# ╠═7beedc0f-78dc-49bb-8b1d-d3d9fe028a6d
# ╟─6619b6d9-ba5c-45a0-82f5-d51f3cb00b7d
# ╟─bff2cc8d-4731-4178-9a12-5dd5fc32bfe6
# ╠═0a3e4e30-69c7-4cba-b7dd-2a979f3b37f9
# ╟─e5f2575f-5e12-44fa-9364-f44b68b7ac18
# ╠═f3eae42a-8686-4213-83c9-65ce48240d4d
# ╠═6933edad-970b-4e09-b275-a925c8e695a2
# ╟─fe277f06-6ac2-4654-b245-c12aa6d438ea
# ╟─e60745ee-7748-4036-be48-57da006eeccf
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
# ╟─ca0b25bd-329f-496d-8460-0504d2ae0938
# ╠═1c61d537-f8fe-4f67-831e-051939056255
# ╠═68d82e76-5175-4e8a-aeea-1bf83c1dddfa
# ╠═7a22ca61-04fb-4a58-8e9b-a4b76857be06
# ╠═d175c618-0781-42d3-956c-931f6bd8a246
# ╠═c5dedcf1-5434-4094-b890-ae3b1da423f1
# ╠═2a2b3b27-680a-45b4-9472-0abcbd4ae3e7
