function [Sort_Eigen_Energies,Sort_Eigen_Vectors, BandEdge]=ScatteringCalculations(Global_cons, Material_cons, Mesh_cons, Device_param, Mesh,Sims_Constant, Silo)


[KineticEnergy, k] = MakeMeshEk(Sims_Constant, Silo);

## AcousticPhononScatteringRates = CalculateAcousticPhononScatteringRates();
## OpticalPhononScatteringRates = CalculateOpticalPhononScatteringRates();
## SurfaceRoughnessScatteringRates = CalculateSurfaceRoughnessScatteringRates();
## CoulombScatteringRates = CalculateCoulombScatteringRates();


end
