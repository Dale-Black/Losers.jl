function hausdorff(ŷ, y, ŷ_dtm, y_dtm)
    return mean((ŷ .- y) .^ 2 .* (ŷ_dtm .^ 2 .+ y_dtm .^ 2))
end

# TODO: make functional tullio.jl hausdorff loss
# function hausdorff(ŷ, y, ŷ_dtm, y_dtm)
#     @tullio tot :=
#         (ŷ[i, j, k, c, b] .- y[i, j, k, c, b])^2 *
#         (ŷ_dtm[i, j, k, c, b]^2 + y_dtm[i, j, k, c, b]^2)
#     return loss = tot / length(y)
# end
