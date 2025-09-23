function [Silo]=DataSilo(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant)

for index=1:Mesh.Number_Mesh_point
    Silo.n(index)=0.0;
    Silo.p(index)=0.0;
    Silo.V(index)=0.0;
end
  
Silo.V(1) = Device_param.MinGateBias;
Silo.V(end) = Device_param.MinBackGateBias;

for i=1:1:Sims_Constant.NoOfValleys
    for j=1:1:Sims_Constant.NoOfEigEnePerValley
        Silo.EigenEnergy(i,j)=0.0;
        Silo.hEigenEnergy(i,j)=0.0;
    end
end
for i=1:1:Sims_Constant.NoOfValleys
    for j=1:1:Sims_Constant.NoOfEigEnePerValley
        for k=1:1:Mesh.Number_Mesh_point
            Silo.EigenVector(i,j,k) = 0.0;
            Silo.hEigenVector(i,j,k) = 0.0;
        end
    end
end

   
end
