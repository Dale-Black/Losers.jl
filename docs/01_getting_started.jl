### A Pluto.jl notebook ###
# v0.19.36

#> [frontmatter]
#> title = "Getting Started"
#> category = "Tutorials"

using Markdown
using InteractiveUtils

# ╔═╡ 5d2009a9-41c7-4d61-beb6-898d769580e3
# ╠═╡ show_logs = false
using Pkg; Pkg.activate("."); Pkg.instantiate()

# ╔═╡ 6db0f829-4f62-4bd7-ac4e-ca6c79ddd499
using PlutoUI: TableOfContents

# ╔═╡ fc750837-b2d4-4de2-9f7a-df7d6529c76c
using Losers: dice_loss, hausdorff_loss

# ╔═╡ 397fbed0-ddae-4dad-9ad3-7c3b982acd65
using DistanceTransforms: transform, boolean_indicator # Losers pairs nicely with this library

# ╔═╡ 81fe4387-a8f9-42a6-81c3-8f06f9e6dff4
md"""
# Introduction to Losers.jl

In this notebook, we explore two important loss functions from the `Losers` library - `dice_loss` and `hausdorff_loss`. These loss functions are particularly useful in machine learning tasks involving image processing and computer vision. We'll demonstrate how they can be effectively paired with `DistanceTransforms.jl` for enhanced performance.

## Setting Up the Environment

Let's begin by setting up our Julia environment and importing the required libraries.

"""

# ╔═╡ 28b95cd9-2099-4e87-b91e-002bd247fb92
TableOfContents()

# ╔═╡ 7c0e734c-52ed-4a09-8b6e-4d91080e2186
md"""
# Dice Loss

The `dice_loss` function is a standard tool in image segmentation tasks. It quantifies the similarity between two samples, making it ideal for comparing a predicted segmentation against a ground truth.

## Example
Let's compute the `dice_loss` between a predicted image and a ground truth.
"""

# ╔═╡ 6822f0bf-f953-40e9-8969-289fc841c882
prediction = rand([0, 1], 10, 10, 10);

# ╔═╡ 5d56ab65-fab5-47d5-8452-4330ee589241
ground_truth = rand([0, 1], 10, 10, 10);

# ╔═╡ 53f96607-6f10-41a7-9ae4-2397924ce41d
dice_loss(prediction, ground_truth)

# ╔═╡ 429925ef-5c1c-4b66-a2d3-06ba462c557d
md"""
# Hausdorff Loss
**and Distance Transforms**

`hausdorff_loss` is particularly effective in scenarios where measuring the distance between the surfaces of two volumes is crucial. Combined with `DistanceTransforms.jl`, it offers a powerful tool for comparing shapes in a 3D space.

## Example
"""

# ╔═╡ ef42160d-d599-42e1-95f2-be11e8e168e4
prediction_dtm = transform(boolean_indicator(prediction));

# ╔═╡ 46c00bab-5bf6-4481-88c2-2d09ba5b1337
ground_truth_dtm = transform(boolean_indicator(ground_truth));

# ╔═╡ 063e9158-50d8-41fc-a2f2-311b40caa376
hausdorff_loss(prediction, ground_truth, prediction_dtm, ground_truth_dtm)

# ╔═╡ 616ea984-9a97-4a2b-8313-823408fefbc3
md"""
# Training with Losers.jl

In practical machine learning applications, particularly in deep learning, the integration of effective loss functions is crucial for model optimization. Here, we demonstrate how `dice_loss` and `hausdorff_loss` can be seamlessly integrated into a training loop.

## Example with `Losers` and `DistanceTransforms`
The following example illustrates a typical training loop where both `dice_loss` and `hausdorff_loss` are employed. The `hausdorff_loss` is enhanced with distance transforms for more accurate shape comparison in 3D space.

```julia
# Begin training loop
for epoch in 1:max_epochs
	for (xs, ys) in train_loader
		# Process data and predictions
		ŷs = model(xs)

		# Apply distance transforms
		ys_dtm = transform(boolean_indicator(ys))
		ŷs_dtm = transform(boolean_indicator(ŷs))

		# Calculate losses
		dice_loss_value = dice_loss(ŷs, ys)
		hausdorff_loss_value = hausdorff_loss(ŷs, ys, ŷs_dtm, ys_dtm)

		# Combine losses for the final loss function
		total_loss = α * dice_loss_value + (1 - α) * hausdorff_loss_value

		# Backpropagation and optimization steps
		# ...
	end
end
```

This example showcases how both loss functions can be used in tandem during model training. The combination of `dice_loss` and `hausdorff_loss` provides a comprehensive loss calculation that considers both segmentation accuracy and shape similarity.
"""

# ╔═╡ Cell order:
# ╟─81fe4387-a8f9-42a6-81c3-8f06f9e6dff4
# ╠═5d2009a9-41c7-4d61-beb6-898d769580e3
# ╠═6db0f829-4f62-4bd7-ac4e-ca6c79ddd499
# ╠═fc750837-b2d4-4de2-9f7a-df7d6529c76c
# ╠═397fbed0-ddae-4dad-9ad3-7c3b982acd65
# ╠═28b95cd9-2099-4e87-b91e-002bd247fb92
# ╟─7c0e734c-52ed-4a09-8b6e-4d91080e2186
# ╠═6822f0bf-f953-40e9-8969-289fc841c882
# ╠═5d56ab65-fab5-47d5-8452-4330ee589241
# ╠═53f96607-6f10-41a7-9ae4-2397924ce41d
# ╟─429925ef-5c1c-4b66-a2d3-06ba462c557d
# ╠═ef42160d-d599-42e1-95f2-be11e8e168e4
# ╠═46c00bab-5bf6-4481-88c2-2d09ba5b1337
# ╠═063e9158-50d8-41fc-a2f2-311b40caa376
# ╟─616ea984-9a97-4a2b-8313-823408fefbc3
