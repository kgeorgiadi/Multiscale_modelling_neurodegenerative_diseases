function MatrixCorrelation = WholeBrainCorrelateNetworkMetricsEBMMatrix(Matrix, Seed, Network, EBM, save_path, savepdf)
[valuesToSeeds, valuesToSeedsAbs, valuesToSeedsMin, valuesToSeedsAbsMin, valuesToSeedsAbsRevMin ] = WholeBrainAbsMinRevMatrix(Network, Matrix, Seed);

MatrixCorrelation.Normal    = WholeBrainCorrelateNetworkMetricEBM(valuesToSeeds,          Network, EBM, [save_path 'Normal'], savepdf);
MatrixCorrelation.Abs       = WholeBrainCorrelateNetworkMetricEBM(valuesToSeedsAbs,       Network, EBM, [save_path 'Abs'], savepdf);
MatrixCorrelation.Min       = WholeBrainCorrelateNetworkMetricEBM(valuesToSeedsMin,       Network, EBM, [save_path 'Min'], savepdf);
MatrixCorrelation.AbsMin    = WholeBrainCorrelateNetworkMetricEBM(valuesToSeedsAbsMin,    Network, EBM, [save_path 'AbsMin'], savepdf);
MatrixCorrelation.AbsRevMin = WholeBrainCorrelateNetworkMetricEBM(valuesToSeedsAbsRevMin, Network, EBM, [save_path 'AbsRevMin'], savepdf);
end