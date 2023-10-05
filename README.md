# Losers
Loss functions for segmentation tasks in the field of computer vision.

[![Glass Notebook](https://img.shields.io/badge/Docs-Glass%20Notebook-aquamarine.svg)](https://glassnotebook.io/r/QU9DE9nl4P1y_1DhiK7Fp/docs/index.jl)
[![CI Stable](https://github.com/Dale-Black/Losers.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Dale-Black/Losers.jl/actions/workflows/CI.yml)
[![CI Nightly](https://github.com/Dale-Black/Losers.jl/actions/workflows/Nightly.yml/badge.svg?branch=master)](https://github.com/Dale-Black/Losers.jl/actions/workflows/Nightly.yml)
[![Coverage](https://codecov.io/gh/Dale-Black/Losers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Dale-Black/Losers.jl)

## Features

- Hausdorff Loss computations for 1D, 2D, and 3D data.
- Dice Loss computations for 1D, 2D, and 3D data.

## Getting Started

To get started, you'll need to import the Losers package:

```julia
using Losers
```

## Usage

### Hausdorff Loss

The Hausdorff loss can be used to compute the loss between two data structures. Here's an example for 1D data:

```julia
using DistanceTransforms: transform, Maurer # Losers pairs nicely with this library

y = rand([0, 1], n)
ŷ = y
y_dtm = transform(y, Maurer())
ŷ_dtm = transform(ŷ, Maurer())
hausdorff_loss(ŷ, y, ŷ_dtm, y_dtm)
```

### Dice Loss

Dice loss can be computed similarly. Here's an example for 1D data:

```julia
y = rand(n)
ŷ = y
dice_loss(ŷ, y)
```

