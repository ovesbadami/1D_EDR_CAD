function [] = WriteDataToFiles(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo,GateBias, BackGateBias)


if ~isfolder(Sims_Constant.OuputFileLocation)
    mkdir(Sims_Constant.OuputFileLocation)
end


dx = Mesh_cons.Spatial_distance;
x = dx*(1:1:Mesh.Number_Mesh_point)*(1E+9);
for i=1:1:Mesh.Number_Mesh_point
    Index = Mesh.Material(i);
    Ec(i) = -Silo.V(i) + Material_cons.delta_Ec_(Index);
    Ev(i) = Ec(i) - Material_cons.bandgap(Index)/(1.6E-19);
end
Ec = Ec';
Ev = Ev';
FileName = strcat(Sims_Constant.OuputFileLocation,"Geometry.dat");
dlmwrite (FileName, x')
FileName = strcat(Sims_Constant.OuputFileLocation,strcat("ElectrostaticPotential_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
dlmwrite (FileName, Silo.V')
FileName = strcat(Sims_Constant.OuputFileLocation,strcat("Bands_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
dlmwrite (FileName, [Ec Ev])
FileName = strcat(Sims_Constant.OuputFileLocation,strcat("ElectronConc_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
dlmwrite (FileName, Silo.n')
FileName = strcat(Sims_Constant.OuputFileLocation,strcat("ElectronEigenEnergy_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
dlmwrite (FileName, Silo.EigenEnergy')
FileName = strcat(Sims_Constant.OuputFileLocation,strcat("HoleEigenEnergy_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
dlmwrite (FileName, Silo.hEigenEnergy')


for Valley=1:1:Sims_Constant.NoOfValleys
    for i=1:1:Sims_Constant.NoOfEigEnePerValley
        for j=1:Mesh.Number_Mesh_point
            EV(j,i) = Silo.EigenVector(Valley, i,j);
            hEV(j,i) = Silo.hEigenVector(Valley, i,j);
        end
    end
    FileName = strcat(Sims_Constant.OuputFileLocation,strcat("ElectronEigenFunctions_",num2str(Valley),"_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
    dlmwrite (FileName, EV);
    FileName = strcat(Sims_Constant.OuputFileLocation,strcat("HoleEigenFunctions_",num2str(Valley),"_",num2str(GateBias), "_", num2str(BackGateBias),".dat"));
    dlmwrite (FileName, EV);
    clear EV
    clear hEV

end
