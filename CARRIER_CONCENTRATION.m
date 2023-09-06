function [n_, p_, n2D] = CARRIER_CONCENTRATION(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)


v_ = Silo.V;
to=1./(Mesh_cons.Spatial_distance.^2);

if (Sims_Constant.QuantumCorrection == 0)
    for i=1:Mesh.Number_Mesh_point
        Index=Mesh.Material(i);
        
       % if (Mesh.Material(i)>1 && Mesh.Material(i)<3)
            kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
            Ec = -Global_cons.Electron_charge*v_(i);
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
        
        
        %else
        %    p_(i)=0.0;
        %    n_(i)=0.0;
        %end
    end 
    n2D = 0;
elseif (Sims_Constant.QuantumCorrection == 1)

    for i=1:Sims_Constant.NoOfValleys
      for j=1:Sims_Constant.NoOfEigEnePerValley
          kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
          % Here we are just considering the density of states effective mass and valley_degeneracy of material 2
          NC2D = Material_cons.valley_degeneracy(i,2)*(Material_cons.meDOS_(i,2)/(pi*Global_cons.hbar^2));
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
            Ec = -Global_cons.Electron_charge*v_(i);
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
end
 
end