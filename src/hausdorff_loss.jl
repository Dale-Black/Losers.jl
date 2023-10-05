using Statistics: mean

"""
	hausdorff(ŷ, y, ŷ_dtm, y_dtm)

Loss function based on the Hausdorff metric. Measures the distance between the boundaries of predicted array `ŷ` and ground truth array `y`. Both the predicted and ground truth arrays require a distance transform `ŷ_dtm` and `y_dtm` as inputs for this boundary operation to work.

[Citation](https://doi.org/10.48550/arXiv.1904.10030)
"""
function hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm)
    return mean((ŷ .- y) .^ 2 .* (ŷ_dtm .^ 2 .+ y_dtm .^ 2))
end

export hausdorff_loss


# """
# 	hausdorff_tullio(ŷ::AbstractVector, y::AbstractVector, ŷ_dtm::AbstractVector, y_dtm::AbstractVector)
	
# 	hausdorff_tullio(ŷ::AbstractMatrix, y::AbstractMatrix, ŷ_dtm::AbstractMatrix, y_dtm::AbstractMatrix)

# 	hausdorff_tullio(ŷ::AbstractArray, y::AbstractArray, ŷ_dtm::AbstractArray, y_dtm::AbstractArray)

# Loss function based on the Hausdorff metric and utilizes [Tullio.jl](https://github.com/mcabbott/Tullio.jl) for increased performance on 1D, 2D, or 3D arrays. Measures the distance between the boundaries of predicted array `ŷ` and ground truth array `y`. Both the predicted and ground truth arrays require a distance transform `ŷ_dtm` and `y_dtm` as inputs for this boundary operation to work.

# [Citation](https://doi.org/10.48550/arXiv.1904.10030)
# """
# function hausdorff_tullio(ŷ::AbstractVector, y::AbstractVector, ŷ_dtm::AbstractVector, y_dtm::AbstractVector)
#     @tullio tot := (ŷ[i] .- y[i])^2 * (ŷ_dtm[i]^2 + y_dtm[i]^2)
#     return loss = tot / length(y)
# end

# function hausdorff_tullio(ŷ::AbstractMatrix, y::AbstractMatrix, ŷ_dtm::AbstractMatrix, y_dtm::AbstractMatrix)
#     @tullio tot := (ŷ[i, j] .- y[i, j])^2 * (ŷ_dtm[i, j]^2 + y_dtm[i, j]^2)
#     return loss = tot / length(y)
# end

# function hausdorff_tullio(ŷ::AbstractArray, y::AbstractArray, ŷ_dtm::AbstractArray, y_dtm::AbstractArray)
#     @tullio tot := (ŷ[i, j, k] .- y[i, j, k])^2 * (ŷ_dtm[i, j, k]^2 + y_dtm[i, j, k]^2)
#     return loss = tot / length(y)
# end