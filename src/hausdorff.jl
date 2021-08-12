function hausdorff(ŷ, y, ŷ_dtm, y_dtm)
    M = (ŷ .- y) .^ 2 .* (ŷ_dtm .^ 2 .+ y_dtm .^ 2)
    return loss = mean(M)
end

# function hd_lossP(ŷ, y, ŷ_dtm, y_dtm)
#     @tullio tot :=
#         (ŷ[i, j, k, c, b] .- y[i, j, k, c, b])^2 *
#         (ŷ_dtm[i, j, k, c, b]^2 + y_dtm[i, j, k, c, b]^2)
#     return loss = tot / length(y)
# end