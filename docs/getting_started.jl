### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> title = "Getting Started"
#> category = "Tutorials"

using Markdown
using InteractiveUtils

# ╔═╡ 4f4d8462-6301-11ee-2ca4-e7f0724d728d
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(temp = true)
	Pkg.add(url = "https://github.com/Dale-Black/Losers.jl")
	Pkg.add(url = "https://github.com/Dale-Black/DistanceTransforms.jl")

	using Losers
	using DistanceTransforms: transform, Maurer # Losers pairs nicely with this library
end

# ╔═╡ 6822f0bf-f953-40e9-8969-289fc841c882
prediction = rand([0, 1], 10, 10, 10);

# ╔═╡ 5d56ab65-fab5-47d5-8452-4330ee589241
ground_truth = rand([0, 1], 10, 10, 10);

# ╔═╡ 53f96607-6f10-41a7-9ae4-2397924ce41d
dice_loss(prediction, ground_truth)

# ╔═╡ ef42160d-d599-42e1-95f2-be11e8e168e4
prediction_dtm, ground_truth_dtm = transform(prediction, Maurer()), transform(ground_truth, Maurer())

# ╔═╡ 063e9158-50d8-41fc-a2f2-311b40caa376
hausdorff_loss(prediction, ground_truth, prediction_dtm, ground_truth_dtm)

# ╔═╡ Cell order:
# ╠═4f4d8462-6301-11ee-2ca4-e7f0724d728d
# ╠═6822f0bf-f953-40e9-8969-289fc841c882
# ╠═5d56ab65-fab5-47d5-8452-4330ee589241
# ╠═53f96607-6f10-41a7-9ae4-2397924ce41d
# ╠═ef42160d-d599-42e1-95f2-be11e8e168e4
# ╠═063e9158-50d8-41fc-a2f2-311b40caa376
