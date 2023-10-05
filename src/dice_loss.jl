"""
## `dice_loss`
```julia
dice_loss(ŷ, y, ϵ=1e-5)
```

Simple dice loss function. Penalizes based on the overlap between predicted `ŷ` and ground truth `y`. A Dice coefficient of 1 corresponds to perfect overlap and is equal to a Dice loss of 0. A Dice coefficient of 0 corresponds to no overlap and is equal to a Dice loss of 1.

[Citation](https://doi.org/10.48550/arXiv.1707.03237)
"""
function dice_loss(ŷ, y, ϵ=1e-5)
    return loss = 1 - ((2 * sum(ŷ .* y) + ϵ) / (sum(ŷ .* ŷ) + sum(y .* y) + ϵ))
end

export dice_loss

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

