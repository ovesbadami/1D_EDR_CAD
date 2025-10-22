function [Silo]=DataSilo(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant)

for index=1:Mesh.Number_Mesh_point
    Silo.n(index)=0.0;
    Silo.p(index)=0.0;
    Silo.V(index)=0.0;
end
  
for index=1:Mesh.Number_Mesh_point
    MatIndex=Mesh.Material(index);
    if (Material_cons.ND_(MatIndex) > Material_cons.NA_(MatIndex))
        Silo.n(index)=Material_cons.ND_(MatIndex);
        Silo.p(index)=0.0;
    else
        Silo.n(index)=0.0;
        Silo.p(index)=Material_cons.NA_(MatIndex);
    end
end

kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
kBT_q=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE)/Global_cons.Electron_charge;

% For the first node
% Locate closest Semiconductor node
if (Material_cons.MatType(Mesh.Material(1)) == 'o')
    for index=2:Mesh.Number_Mesh_point-1
        % Locating the closest semiconductor node
        MatIndex=Mesh.Material(index);
        if (Material_cons.MatType(MatIndex) == 's')
            break
        end
    end
elseif (Material_cons.MatType(Mesh.Material(1)) == 's')
    MatIndex=Mesh.Material(1);             
else
    disp('Incorrect material type')
    quit
end

NetDoping = Material_cons.ND_(MatIndex)-Material_cons.NA_(MatIndex);
if (NetDoping > 0)
    NC3D = 2*((Material_cons.meDOS_(1,Mesh.Material(index))/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
    EcMinusEf = kBT_q*log(abs(NetDoping)/NC3D);
elseif (NetDoping < 0)
    NV3D = 2*((Material_cons.mhDOS_(1,Mesh.Material(index))/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
    EcMinusEf = Material_cons.bandgap(MatIndex)/Global_cons.Electron_charge+kBT_q*log(abs(NetDoping)/NV3D);
end

Silo.BuiltinPotLeft = -EcMinusEf;

% For the last node
if (Material_cons.MatType(Mesh.Material(Mesh.Number_Mesh_point)) == 'o')
    for index = Mesh.Number_Mesh_point-1:-1:1
        % Locating the closest semiconductor node
        MatIndex=Mesh.Material(index);
        if (Material_cons.MatType(MatIndex) == 's')
            break
        end
    end
elseif (Material_cons.MatType(Mesh.Number_Mesh_point) == 's')
    MatIndex=Mesh.Material(Mesh.Number_Mesh_point); 
else
    disp('Incorrect material type')
    quit
end

NetDoping = Material_cons.ND_(MatIndex)-Material_cons.NA_(MatIndex);
if (NetDoping > 0)
    NC3D = 2*((Material_cons.meDOS_(1,Mesh.Material(index))/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
    EcMinusEf = kBT_q*log(abs(NetDoping)/NC3D);
elseif (NetDoping < 0)
    NV3D = 2*((Material_cons.mhDOS_(1,Mesh.Material(index))/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
    EcMinusEf = Material_cons.bandgap(MatIndex)/Global_cons.Electron_charge+kBT_q*log(abs(NetDoping)/NV3D);
end

Silo.BuiltinPotRight = -EcMinusEf;

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
