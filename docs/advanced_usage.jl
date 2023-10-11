### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> title = "Advanced Usage"
#> category = "Tutorials"

using Markdown
using InteractiveUtils

# ╔═╡ 3385de0a-6879-11ee-35e1-e19c861688de
md"""
In an actual training loop, losers (specifically `hausdorff_loss`) might look something like this

```julia
# Begin training loop
for epoch in 1:max_epochs
	step = 0
    α = some_constant .+ 0.01
	@info epoch
	
	# Loop through training data
	for (xs, ys) in train_loader
		step += 1
		@info step
		# Send data to GPU
		xs, ys = xs |> gpu, ys |> gpu		
		gs = Flux.gradient(ps) do
			ŷs = model(xs)
			# Apply distance transform using GPU compatible `Felzenszwalb`
			# Data will usually be 4D or 5D [x, y, (z), channel, batch]
			ys_dtm = CuArray{Float32}(undef, size(ys))
			ŷs_dtm = CuArray{Float32}(undef, size(ŷs))
			for b in size(ys, 5)
				for c in size(ys, 4)
					for z in size(ys, 3)
						bool_arr_gt = boolean_indicator(ys[:, :, z, c, b])
						bool_arr_pred = boolean_indicator(ŷs[:, :, z, c, b])
						tfm = Felzenszwalb()
						ys_dtm[:, :, z, c, b] = transform!(bool_arr_gt, tfm)
						ŷs_dtm[:, :, z, c, b] = transform!(bool_arr_pred, tfm)
					end
				end
			end
			hd_loss = hausdorff(ŷs, ys, ŷs_dtm, ys_dtm)
			dice_loss = dice(ŷs, ys)
			loss = α*dice_loss + (1-α)*hausdorff_loss
			return loss
		end
		Flux.update!(optimizer, ps, gs)
	end
end
```
"""

# ╔═╡ 1dfbc8e9-03dc-4fea-b63c-9a4aa5f57523
md"""
TODO:

Run full Lux.jl example
"""

# ╔═╡ Cell order:
# ╟─3385de0a-6879-11ee-35e1-e19c861688de
# ╟─1dfbc8e9-03dc-4fea-b63c-9a4aa5f57523
