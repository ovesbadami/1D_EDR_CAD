function [Factor] = IMLDA(Global_cons, Sims_Constant, Material_cons, Mesh)

mt = Sims_Constant.MLDAeConfMass(1)*Global_cons.Free_electron_mass;
ml = Sims_Constant.MLDAeConfMass(2)*Global_cons.Free_electron_mass;

lambdaT2 = (2*mt*Global_cons.Boltzmann_cons*Global_cons.TEMPERATURE/Global_cons.hbar^2);
lambdaL2 = (2*ml*Global_cons.Boltzmann_cons*Global_cons.TEMPERATURE/Global_cons.hbar^2);

LastFrontOxideNode = -5;
FirstBackOxideNode = -5;

    for i=1:(Mesh.Number_Mesh_point)-1
        Dom = Mesh.Material(i);
        Domp1 = Mesh.Material(i+1);
        if (Material_cons.MatType(Dom) =='o' && Material_cons.MatType(Domp1) =='s')
          LastFrontOxideNode = i;
        elseif (Material_cons.MatType(Dom) =='s' && Material_cons.MatType(Domp1) =='o')
          FirstBackOxideNode = i+1;
        end
    end

    for i=1:(Mesh.Number_Mesh_point)

            if (i > LastFrontOxideNode && FirstBackOxideNode < 0) % Single Gate
                z = Mesh.Width(i)- Mesh.Width(LastFrontOxideNode);
            elseif (i > LastFrontOxideNode && i < FirstBackOxideNode) % Double Gate
                z1 = Mesh.Width(i)- Mesh.Width(LastFrontOxideNode);
                z2 = Mesh.Width(FirstBackOxideNode)- Mesh.Width(i);
                if (z1>z2)
                  z = z2;
                elseif (z1<z2)
                  z = z1;
                end
            else 
                z = 0;
            end
            zSq = z*z;    
            Factor(i) = (1.01-(2/3)*exp(-lambdaT2*zSq)-(1/3)*exp(-lambdaL2*zSq));
            % QuantumCorrection(i) = -(Global_cons.Boltzmann_cons*Global_cons.TEMPERATURE/Global_cons.Electron_charge)*log(Factor);
    end
end



