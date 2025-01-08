function [n_, p_, n2D, p2D] = CARRIER_CONCENTRATION(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)


v_ = Silo.V;
to=1./(Mesh_cons.Spatial_distance.^2);

if (Sims_Constant.eQuantumCorrection == 0 && Sims_Constant.hQuantumCorrection == 0)
    for i=1:Mesh.Number_Mesh_point
        Index=Mesh.Material(i);

       % if (Mesh.Material(i)>1 && Mesh.Material(i)<3)
            kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
            Ec = -Global_cons.Electron_charge*v_(i) + Global_cons.Electron_charge*Material_cons.delta_Ec_(Index);
            Ev = Ec - Material_cons.bandgap(Index);
            NC3D = 2*((Material_cons.meDOS_(1,Mesh.Material(i))/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
            NV3D = 2*((Material_cons.mhDOS_(1,Mesh.Material(i))/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
            if (NC3D == 0)
                n_(i) = 0;
            else
                n_(i)=NC3D*(exp(-(Ec-Global_cons.Ef)/kBT));
            endif
            if (NV3D == 0)
                p_(i) = 0;
            else
                p_(i)=NV3D*(exp(-(Global_cons.Ef-Ev)/kBT));
            endif
    end
    n2D = 0;
    p2D = 0;
elseif (Sims_Constant.eQuantumCorrection == 1 && Sims_Constant.hQuantumCorrection == 0)

    meff_DoS = zeros(Sims_Constant.NoOfValleys,1);
    for i=1:1:Sims_Constant.NoOfValleys
        Counter = 0;
        for j = 1:1:Device_param.NoOfDomains
            if (Material_cons.meDOS_(i,j) > 0)
                meff_DoS(i,1) = meff_DoS(i,1) + Material_cons.meDOS_(i,j);
                Counter = Counter + 1;
            endif
        end
        meff_DoS(i,1) = meff_DoS(i,1)/Counter;
    end

    for i=1:Sims_Constant.NoOfValleys
      for j=1:Sims_Constant.NoOfEigEnePerValley
          kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
          % Here we are just considering the density of states effective mass and valley_degeneracy of material 2
          NC2D = Material_cons.valley_degeneracy(i,2)*(meff_DoS(i,1)/(pi*Global_cons.hbar^2));
          n2D(i,j) = NC2D*kBT*log(1+exp((Global_cons.Ef-Global_cons.Electron_charge*Silo.EigenEnergy(i,j))/kBT));
        end
    end

    for i=1:Mesh.Number_Mesh_point
        n_(i) = 0.0;
        if (Material_cons.meDOS_(1,Mesh.Material(i)) != 0)
            for j=1:Sims_Constant.NoOfValleys
                for k=1:Sims_Constant.NoOfEigEnePerValley
                    n_(i) = n_(i) + n2D(j,k)*Silo.EigenVector(j,k,i)*Silo.EigenVector(j,k,i);
                end
            end
        else
            n_(i) = 0.0;
        end
    end

    for i=1:Mesh.Number_Mesh_point
        Index=Mesh.Material(i);
%        if (Mesh.Material(i)>1 && Mesh.Material(i)<3)
            kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
            NV3D = 2*((Material_cons.mhDOS_(1,2)/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
            Ec = -Global_cons.Electron_charge*v_(i) + Global_cons.Electron_charge*Material_cons.delta_Ec_(Index);
            Ev = Ec - Material_cons.bandgap(Index);

            if (NV3D == 0)
                p_(i)=0.0;
            else
                p_(i)=NV3D*(exp(-(Global_cons.Ef-Ev)/kBT));
            endif
%        else
%           p_(i)=0.0;
%        end
    end

    p2D = 0

elseif (Sims_Constant.hQuantumCorrection == 1 && Sims_Constant.eQuantumCorrection == 0)
    meff_DoS = zeros(Sims_Constant.NoOfValleys,1);
    for i=1:1:Sims_Constant.NoOfValleys
        Counter = 0;
        for j = 1:1:Device_param.NoOfDomains
            if (Material_cons.mhDOS_(i,j) > 0)
                meff_DoS(i,1) = meff_DoS(i,1) + Material_cons.mhDOS_(i,j);
                Counter = Counter + 1;
            endif
        end
        meff_DoS(i,1) = meff_DoS(i,1)/Counter;
%        printf("Effective Mass %d %d %f \n",i, Counter, meff_DoS(i,1)/9.1080e-31);
    end

    for i=1:Sims_Constant.NoOfValleys
      for j=1:Sims_Constant.NoOfEigEnePerValley
          kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
          % Here we are just considering the density of states effective mass and valley_degeneracy of material 2
          NV2D = Material_cons.hole_valley_degeneracy(i,2)*(meff_DoS(i,1)/(pi*Global_cons.hbar^2));
          p2D(i,j) = NV2D*kBT*log(1+exp(-(Global_cons.Ef-Global_cons.Electron_charge*Silo.hEigenEnergy(i,j))/kBT));
        end
    end

    for i=1:Mesh.Number_Mesh_point
        p_(i) = 0.0;
        if (Material_cons.mhDOS_(1,Mesh.Material(i)) != 0)
            for j=1:Sims_Constant.NoOfValleys
                for k=1:Sims_Constant.NoOfEigEnePerValley
                    p_(i) = p_(i) + p2D(j,k)*Silo.hEigenVector(j,k,i)*Silo.hEigenVector(j,k,i);
                end
            end
        else
            p_(i) = 0.0;
        end
    end

    for i=1:Mesh.Number_Mesh_point
        Index=Mesh.Material(i);
%        if (Mesh.Material(i)>1 && Mesh.Material(i)<3)
            kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
            NC3D = 2*((Material_cons.meDOS_(1,2)/(2*pi*Global_cons.hbar^2))^1.5) *(kBT^1.5);
            Ec = -Global_cons.Electron_charge*v_(i)+ Global_cons.Electron_charge*Material_cons.delta_Ec_(Index);

            if (NC3D == 0)
                n_(i)=0.0;
            else
                n_(i)=NC3D*(exp((Global_cons.Ef-Ec)/kBT));
            endif
%        else
%           p_(i)=0.0;
%        end
    end

    n2D = 0;


elseif (Sims_Constant.hQuantumCorrection == 1 && Sims_Constant.eQuantumCorrection == 1)
    disp('error')
end

end
