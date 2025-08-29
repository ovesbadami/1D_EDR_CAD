function [] = CalculateEffectiveElectricField(Mesh_cons,Mesh,Silo)

dz = Mesh_cons.Spatial_distance;
Z = dz*(1:1:Mesh.Number_Mesh_point);

Ninv = trapz(Silo.n)*dz; % /m2
Ninv = Ninv; % /cm2

Z = Z; 

E = diff(Silo.V)/dz;
E = E;
n = Silo.n(1:end-1);
Eeff = (trapz(E.*n)*dz)/(Ninv)
Eeff = Eeff/1E6
