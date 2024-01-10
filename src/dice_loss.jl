"""
## `dice_loss`
```julia
dice_loss(input, target; smooth_nr=1e-5, smooth_dr=1e-5)
```
Simple dice loss function. Penalizes based on the overlap between predicted `ŷ` and ground truth `y`.
A Dice coefficient of 1 corresponds to perfect overlap and is equal to a Dice loss of 0.
A Dice coefficient of 0 corresponds to no overlap and is equal to a Dice loss of 1.

#### Arguments
`input`: input array
`target`: target array
`smooth_nr`: a small constant added to the numerator to avoid zero.
`smooth_dr`: a small constant added to the denominator to avoid nan.


[Citation](https://doi.org/10.48550/arXiv.1707.03237)
"""
function dice_loss(input, target; smooth_nr=1e-5, smooth_dr=1e-5)
    intersection = sum(input .* target)
    sum_input_target = sum(input) + sum(target)
    dice_score = (2.0 * intersection + smooth_nr) / (sum_input_target + smooth_dr)
    return 1.0 - dice_score
end

export dice_loss

