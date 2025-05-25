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

%[Global_cons,Material_cons,Mesh_cons,Device_param,Sims_Constant] = GLOBAL_CONSTANT_INPUT();

[Global_cons,Material_cons,Mesh_cons,Device_param,Sims_Constant] = FileRead(Directory);

Mesh=Make_mesh(Mesh_cons,Device_param);

Silo=DataSilo(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant);

n_ = zeros(1,Mesh.Number_Mesh_point);
p_ = zeros(1,Mesh.Number_Mesh_point);
v_ = zeros(1,Mesh.Number_Mesh_point);

for GateBias = Device_param.MinGateBias:Device_param.GateBiasStep:Device_param.MaxGateBias
    Silo.V(1) = GateBias+Device_param.WFDiff;
    Silo.V(end) = Device_param.BackGateBias+Device_param.WFDiff;

    for iteration=1:1:1500
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
        ErrorN(iteration) = max(abs((Silo.n-n_))./n_);
        ErrorP(iteration) = max(abs((Silo.p-p_))./p_);
        Silo.p = p_;
        Silo.n = n_;
        
       fprintf("%d %f %f %f \n", iteration, ErrorV(iteration), ErrorN(iteration), ErrorP(iteration));

        if(ErrorV(iteration) < 0.001 && iteration > 5)
            if (Sims_Constant.eQuantumCorrection == 1)
%                 Silo = EigenFunctionPostProcessing(Mesh_cons, Mesh,Sims_Constant,Silo);
                [n_, p_, n2D, p2D] = CARRIER_CONCENTRATION(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
            end
            disp("Convegence Reached.\n")
            break;
        end
    end
   
   
%    [GateCurrent] = GateLeakageCurrent(GateBias, Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
%    printf("%e %e \n",0.5*sum(sum(n2D))*1E-4*(1E-13), sum(sum(GateCurrent.Ig))*1E-4);
%    printf("%e %e \n",GateBias, GateCurrent.Ig_total*1E-4 )
end
