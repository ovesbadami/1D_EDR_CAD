clc;
clear ;
close all;

x = date;
year = x(end-3:end);
if (year ~= "2025")
    disp('Something went wrong')
    exit()
end
Directory='./';

[Global_cons,Material_cons,Mesh_cons,Device_param,Sims_Constant] = FileRead(Directory);

Mesh=Make_mesh(Mesh_cons,Device_param);

Silo=DataSilo(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant);

for GateBias = Device_param.MinGateBias:Device_param.GateBiasStep:Device_param.MaxGateBias
    Silo.V(1) = GateBias+Silo.BuiltinPotLeft+Device_param.WFDiff;
    
    for BackGateBias = Device_param.MinBackGateBias:Device_param.BackGateBiasStep:Device_param.MaxBackGateBias
        fprintf("Gate Bias: %.3f V \n",GateBias);
        fprintf("Back Gate Bias: %.3f V\n",BackGateBias);

        Silo.V(end) = BackGateBias+Silo.BuiltinPotRight+Device_param.WFDiff;
        if (strcmp(Device_param.Double_Gate_Symmetry,"YES") && GateBias ~= BackGateBias)
            continue
        end
        
    fprintf("Iteration    ErrorV    ErrorN    ErrorP\n");

    for iteration=1:1:Sims_Constant.MaxIterations
        [v_] = POISSON_SOLVER(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
        
        ErrorV(iteration) = max(abs(Silo.V-v_))/Sims_Constant.Damping;
        Silo.V = v_;

        if (Sims_Constant.eQuantumCorrection == 1)
            CarrierType = 'electron';
            [Sort_Eigen_Energies,Sort_Eigen_Vectors, Ec]=SCHRODINGER_EQUATION_SOLVE(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo, CarrierType);
            Ec = Ec;
            Silo.EigenEnergy = Sort_Eigen_Energies;
            Silo.EigenVector = Sort_Eigen_Vectors;
        end

        if (Sims_Constant.hQuantumCorrection == 1)
            CarrierType = 'hole';
            [Sort_Eigen_Energies,Sort_Eigen_Vectors, Ev]=SCHRODINGER_EQUATION_SOLVE(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo, CarrierType);
            Ev = -Ev;
            Silo.hEigenEnergy = -Sort_Eigen_Energies;
            Silo.hEigenVector = Sort_Eigen_Vectors;
        end

        [n_, p_, n2D, p2D] = CARRIER_CONCENTRATION(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
        
        if (max(abs((Silo.n-n_))) == 0 || max(abs(n_)) == 0 )
            ErrorN(iteration) = 0;
        else
            ErrorN(iteration) = max(abs((Silo.n-n_))./n_);
        end
        if (max(abs((Silo.p-p_))) == 0 || max(abs(p_)) == 0)
            ErrorP(iteration) = 0;
        else
            ErrorP(iteration) = max(abs((Silo.p-p_))./p_);
        end
        
        Silo.p = p_;
        Silo.n = n_;
        
       fprintf("%9d %.3e %.3e %.3e \n", iteration, ErrorV(iteration), ErrorN(iteration), ErrorP(iteration));

        if(ErrorV(iteration) < Sims_Constant.PoissonTol && iteration > 5)
            if (Sims_Constant.eQuantumCorrection == 1)
                Silo = EigenFunctionPostProcessing(Mesh_cons, Mesh,Sims_Constant,Silo);
                [n_, p_, n2D, p2D] = CARRIER_CONCENTRATION(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
            end
            disp("Convegence Reached.")
            fprintf("\n \n \n")
            break;
        end
    end
    end
    WriteDataToFiles(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo,GateBias, BackGateBias)
%    [GateCurrent] = GateLeakageCurrent(GateBias, Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
%    printf("%e %e \n",0.5*sum(sum(n2D))*1E-4*(1E-13), sum(sum(GateCurrent.Ig))*1E-4);
%    printf("%e %e \n",GateBias, GateCurrent.Ig_total*1E-4 )
end

% PrintTheLeftHandSideMatrixOfPoisson(Material_cons,Mesh_cons,Mesh)
