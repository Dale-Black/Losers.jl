function dice(ŷ, y, ϵ=1e-5)
    return loss = 1 - ((2 * sum(ŷ .* y) + ϵ) / (sum(ŷ .* ŷ) + sum(y .* y) + ϵ))
end

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