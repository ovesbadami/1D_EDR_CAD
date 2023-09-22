clc
close all

dx = Mesh_cons.Spatial_distance;
x = dx*(1:1:Mesh.Number_Mesh_point)*(1E+9);
for i=1:1:Mesh.Number_Mesh_point
  Index = Mesh.Material(i);
  Ec(i) = -Silo.V(i) + Material_cons.delta_Ec_(Index);
endfor


grid on


figure(1)
plot(x,Silo.n,'-','linewidth', 3)
ylabel('Electron Concentration [m^{-3}]')
xlabel('Position [nm]')
axis ("tic", "tight");
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

figure(2)
plot(x,Silo.p,'-','linewidth', 3)
ylabel('Hole Concentration [m^{-3}]')
xlabel('Position [nm]')
axis ("tic", "tight");
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

figure(3)
plot(x,Ec,'linewidth', 3);
EE1(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(1,1);
EE2(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(1,2);
EE3(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(1,3);
EE4(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(1,4);
EE5(1:Mesh.Number_Mesh_point) = Silo.EigenEnergy(1,5);
hold on; plot(x,EE1,'--','linewidth', 3); plot(x,EE2,'--','linewidth', 3)
plot(x,EE3,'--','linewidth', 3); plot(x,EE4,'--','linewidth', 3)
plot(x,EE5,'--','linewidth', 3);


plot(x,Ev,'linewidth', 3);
EE1(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(1,1);
EE2(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(1,2);
EE3(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(1,3);
EE4(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(1,4);
EE5(1:Mesh.Number_Mesh_point) = Silo.hEigenEnergy(1,5);
hold on; plot(x,EE1,'--','linewidth', 3); plot(x,EE2,'--','linewidth', 3)
plot(x,EE3,'--','linewidth', 3); plot(x,EE4,'--','linewidth', 3)
plot(x,EE5,'--','linewidth', 3);
ylabel('Band edge [eV]')
xlabel('Position [nm]')
%axis ([0 x(end) 0 Silo.hEigenEnergy(1,5);] )
axis ("tic", "tight");
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])

figure(4)
plot(x, abs(Silo.hEigenVector(1,1,:)).^2, '--','linewidth', 3); hold on;
plot(x, abs(Silo.hEigenVector(2,1,:)).^2, 'o','linewidth', 3); hold on;
%plot(x,(Silo.EigenVector(1,2,:)).^2,'--','linewidth', 3);
%plot(x,(Silo.EigenVector(1,3,:)).^2,'--','linewidth', 3);
%plot(x,Ec,'linewidth', 3);
ylabel('Wave function [eV]')
xlabel('Position [nm]')
axis ("tic", "tight");
%axis ([0 x(end) -5E4 5E4] )
set(gca, "linewidth", 2, "fontsize", 20, "ticklength", [0.025, 0.25])





