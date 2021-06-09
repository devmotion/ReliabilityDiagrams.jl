# ReliabilityDiagrams

*Visualization of model calibration*

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://devmotion.github.io/ReliabilityDiagrams.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://devmotion.github.io/ReliabilityDiagrams.jl/dev)
[![Build Status](https://github.com/devmotion/ReliabilityDiagrams.jl/workflows/CI/badge.svg?branch=main)](https://github.com/devmotion/ReliabilityDiagrams.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![DOI](https://zenodo.org/badge/359381120.svg)](https://zenodo.org/badge/latestdoi/359381120)
[![Coverage](https://codecov.io/gh/devmotion/ReliabilityDiagrams.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/devmotion/ReliabilityDiagrams.jl)
[![Coverage](https://coveralls.io/repos/github/devmotion/ReliabilityDiagrams.jl/badge.svg?branch=main)](https://coveralls.io/github/devmotion/ReliabilityDiagrams.jl?branch=main)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

[![Example of a reliability diagram](https://devmotion.github.io/ReliabilityDiagrams.jl/dev/reliability_example.svg)](https://devmotion.github.io/ReliabilityDiagrams.jl/dev)

## Related packages

- [CalibrationErrors.jl](https://github.com/devmotion/CalibrationErrors.jl): Estimation of calibration errors such as the expected calibration error (ECE), the squared kernel calibration error (SKCE), and the unnormalized calibration mean embedding (UCME).
- [CalibrationErrorsDistributions.jl](https://github.com/devmotion/CalibrationErrorsDistributions.jl): Estimation of calibration errors for probabilistic predictive models that output probability distributions from [Distributions.jl](https://github.com/JuliaStats/Distributions.jl).
- [CalibrationTests.jl](https://github.com/devmotion/CalibrationTests.jl): Statistical hypothesis tests of calibration.

## References

Bröcker, J., & Smith, L. A. (2007). [Increasing the reliability of reliability diagrams](https://doi.org/10.1175/WAF993.1). Weather and forecasting, 22(3), 651-661.

Murphy, A., & Winkler, R. (1977). [Reliability of Subjective Probability Forecasts of Precipitation and Temperature](https://doi.org/10.2307/2346866). Journal of the Royal Statistical Society. Series C (Applied Statistics), 26(1), 41-47.

Vaicenavicius, J., Widmann, D., Andersson, C., Lindsten, F., Roll, J. & Schön, T. B. (2019). [Evaluating model calibration in classification](http://proceedings.mlr.press/v89/vaicenavicius19a.html). Proceedings of Machine Learning Research, in Proceedings of Machine Learning Research 89:3459-3467 (AISTATS 2019).
