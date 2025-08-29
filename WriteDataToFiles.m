function [] = WriteDataToFiles(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo,GateBias)

dx = Mesh_cons.Spatial_distance;
x = dx*(1:1:Mesh.Number_Mesh_point)*(1E+9);
for i=1:1:Mesh.Number_Mesh_point
    Index = Mesh.Material(i);
    Ec(i) = -Silo.V(i) + Material_cons.delta_Ec_(Index);
    Ev(i) = Ec(i) - Material_cons.bandgap(Index)/(1.6E-19);
end
Ec = Ec';
Ev = Ev';
dlmwrite ('Geometry.dat', x')
dlmwrite (strcat("ElectrostaticPotential_",num2str(GateBias),".dat"), Silo.V')
dlmwrite (strcat("Bands_",num2str(GateBias),".dat"), [Ec Ev])
dlmwrite (strcat("ElectronConc_",num2str(GateBias),".dat"), Silo.n')
dlmwrite (strcat("ElectronEigenEnergy_",num2str(GateBias),".dat"), Silo.EigenEnergy')


for Valley=1:1:Sims_Constant.NoOfValleys
    for i=1:1:Sims_Constant.NoOfEigEnePerValley
        for j=1:Mesh.Number_Mesh_point
            EV(j,i) = Silo.EigenVector(Valley, i,j);
        end
    end
    FileName = strcat("ElectronEigenFunctions_",num2str(Valley),"_",num2str(GateBias),".dat");
    dlmwrite (FileName, EV);
    clear EV
end
