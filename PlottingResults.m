clc
% close all
Valley = 1

dx = Mesh_cons.Spatial_distance;
x = dx*(1:1:Mesh.Number_Mesh_point)*(1E+9);
for i=1:1:Mesh.Number_Mesh_point
    Index = Mesh.Material(i);
    Ec(i) = -Silo.V(i) + Material_cons.delta_Ec_(Index);
    Ev(i) = Ec(i) - Material_cons.bandgap(Index)/(1.6E-19);
    Ef(i) = 0.0;
end


grid on


figure(1)
plot(x,Silo.n,'-','linewidth', 3)
ylabel('Electron Concentration [m^{-3}]')
xlabel('Position [nm]')
%axis ("tic", "tight");
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

figure(2)
plot(x,Silo.p,'-','linewidth', 3)
ylabel('Hole Concentration [m^{-3}]')
xlabel('Position [nm]')
%axis ("tic", "tight");
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

figure(3)
plot(x,Ec,'linewidth', 3); hold on
plot(x,Ev,'linewidth', 3); hold on
plot(x,Ef,'--','linewidth', 3); hold on


if (Sims_Constant.eQuantumCorrection == 1)
  plot(x,Ec,'linewidth', 3); hold on
  EE1(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(Valley,1);
  EE2(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(Valley,2);
  EE3(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(Valley,3);
  EE4(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(Valley,4);
  EE5(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(Valley,5);
  hold on; plot(x,EE1,'--','linewidth', 3); plot(x,EE2,'--','linewidth', 3)
  plot(x,EE3,'--','linewidth', 3); plot(x,EE4,'--','linewidth', 3)
  plot(x,EE5,'--','linewidth', 3);
end

if (Sims_Constant.hQuantumCorrection == 1)
  plot(x,Ev,'linewidth', 3);
  EE1(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(Valley,1);
  EE2(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(Valley,2);
  EE3(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(Valley,3);
  EE4(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(Valley,4);
  EE5(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(Valley,5);
  hold on; plot(x,EE1,'--','linewidth', 3); plot(x,EE2,'--','linewidth', 3)
  plot(x,EE3,'--','linewidth', 3); plot(x,EE4,'--','linewidth', 3)
  plot(x,EE5,'--','linewidth', 3);
end
ylabel('Band edge [eV]')
xlabel('Position [nm]')
%axis ([0 x(end) 0 Silo.hEigenEnergy(1,5);] )
%axis ("tic", "tight");
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

if (Sims_Constant.eQuantumCorrection == 1)
  figure(4)
  hold on
  %plot(x, abs(Silo.hEigenVector(1,1,:)).^2, '--','linewidth', 3); hold on;
  %plot(x, abs(Silo.hEigenVector(1,2,:)).^2, 'o','linewidth', 3); hold on;
  EV1(1:length(Silo.EigenVector(1,1,:)),1) = Silo.EigenVector(Valley,1,:);
  plot(x,EV1,'-','linewidth', 3);
%   EV2(1:length(Silo.EigenVector(1,1,:)),1) = Silo.EigenVector(Valley,2,:);
%   plot(x,EV2,'--','linewidth', 3);
%   EV3(1:length(Silo.EigenVector(1,1,:)),1) = Silo.EigenVector(Valley,3,:);
%   plot(x,EV3,'--','linewidth', 3);
%   EV4(1:length(Silo.EigenVector(1,1,:)),1) = Silo.EigenVector(Valley,4,:);
%   plot(x,EV4,'--','linewidth', 3);
%   EV5(1:length(Silo.EigenVector(1,1,:)),1) = Silo.EigenVector(Valley,5,:);
%   plot(x,EV5,'--','linewidth', 3);
%   
  
  
  
 
%   plot(x,Ec,'linewidth', 3);
  ylabel('Wave function [eV]')
  xlabel('Position [nm]')
  %axis ("tic", "tight");
  %axis ([0 x(end) -5E4 5E4] )
  set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

end



