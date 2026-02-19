function [Global_cons,Material_cons,Mesh_cons,Device_param,Sims_Constant]=FileRead(Directory)


Sims_Constant.eQuantumCorrection = 0;
Sims_Constant.hQuantumCorrection = 0;
Sims_Constant.MaxIterations = 1000;
Sims_Constant.OuputFileLocation = "./";

Global_cons.hbar = 1.05457e-34;
Global_cons.Free_electron_mass = 9.108e-31;
Global_cons.Boltzmann_cons = 1.38e-23;
Global_cons.Electron_charge = 1.602e-19;
Global_cons.Free_permittivity = 8.854e-12;
Global_cons.TEMPERATURE = 300;
Sims_Constant.PoissonTol = 0.5E-3;

FileName = strcat(Directory,'/','InputFile.txt');
fid=fopen(FileName,'r');

fseek(fid, 0, 'eof');
fileSize = ftell(fid);
frewind(fid);
%# Read the whole file.
data = fread(fid, fileSize, 'uint8');
%# Count number of line-feeds and increase by one.
num_of_lines = sum(data == 10) + 1;
fclose(fid);


%num_of_lines = fskipl(fid, Inf);
%fclose (fid);

fid=fopen(FileName,'r');
for i=1:num_of_lines
    txt = fgetl (fid);
    if (txt == -1)
      break
    end
    
    indexS = 1;
%    IndexM = index(txt,":");
%    IndexE = index(txt,";");
    IndexM = strfind(txt,":");
    IndexE = strfind(txt,";");
    
    if strcmp(txt(indexS:IndexM-1),"TEMPERATURE")
        Global_cons.TEMPERATURE = str2double(txt(IndexM+1:IndexE-1));
    %elseif strcmp(txt(indexS:IndexM-1),"hbar")
    %    Global_cons.hbar = str2double(txt(IndexM+1:IndexE-1));
    %elseif strcmp(txt(indexS:IndexM-1),"FREE_ELECTRON_MASS")
    %    Global_cons.Free_electron_mass = str2double(txt(IndexM+1:IndexE-1));
    %elseif strcmp(txt(indexS:IndexM-1),"BOLTZMANN_CONSTANT")
    %    Global_cons.Boltzmann_cons = str2double(txt(IndexM+1:IndexE-1));
    %elseif strcmp(txt(indexS:IndexM-1),"ELECTRON_CHARGE")
    %    Global_cons.Electron_charge = str2double(txt(IndexM+1:IndexE-1));
    %elseif strcmp(txt(indexS:IndexM-1),"PERMITTIVITY")
    %    Global_cons.Free_permittivity = str2double(txt(IndexM+1:IndexE-1));
   elseif strcmp(txt(indexS:IndexM-1),"OUTPUTFILE_LOCATION")
        Sims_Constant.OuputFileLocation = txt(IndexM+1:IndexE-1);
   elseif strcmp(txt(indexS:IndexM-1),"DAMPING")
        Sims_Constant.Damping = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"MAX_ITERATIONS")
        Sims_Constant.MaxIterations = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"POISSON_TOL")
        Sims_Constant.PoissonTol = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"eQUANTUM_CORRECTION")
        Sims_Constant.eQuantumCorrection = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"hQUANTUM_CORRECTION")
        Sims_Constant.hQuantumCorrection = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"NO_OF_VALLEYS")
        Sims_Constant.NoOfValleys = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"NO_EIGEN_PER_VALLEY")
        Sims_Constant.NoOfEigEnePerValley = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"MESH_SPATIAL_DISTANCE_m")
        Mesh_cons.Spatial_distance = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"SYMMETRIC_DOUBLE_GATE")
        Device_param.Double_Gate_Symmetry = txt(IndexM+1:IndexE-1);
    elseif strcmp(txt(indexS:IndexM-1),"GATE_BIAS")
        temp = strsplit(txt(IndexM+1:IndexE-1));
        Device_param.MinGateBias = str2double(temp(1,1));
        Device_param.GateBiasStep = str2double(temp(1,2));
        Device_param.MaxGateBias = str2double(temp(1,3));
    elseif strcmp(txt(indexS:IndexM-1),"BACK_GATE_BIAS")
        temp = strsplit(txt(IndexM+1:IndexE-1));
        Device_param.MinBackGateBias = str2double(temp(1,1));
        Device_param.BackGateBiasStep = str2double(temp(1,2));
        Device_param.MaxBackGateBias = str2double(temp(1,3));    
    elseif strcmp(txt(indexS:IndexM-1),"WORKFUNCTION_DIFF")
        Device_param.WFDiff = str2double(txt(IndexM+1:IndexE-1));
%    elseif strcmp(txt(indexS:IndexM-1),"L1_m")
%        Device_param.Region_(1) = str2double(txt(IndexM+1:IndexE-1));
%    elseif strcmp(txt(indexS:IndexM-1),"L2_m")
%        Device_param.Region_(2) = str2double(txt(IndexM+1:IndexE-1));
%    elseif strcmp(txt(indexS:IndexM-1),"L3_m")
%        Device_param.Region_(3) = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"NO_OF_DOMAINS")
        temp = strsplit(txt(IndexM+1:IndexE-1));
        Device_param.NoOfDomains = str2double(temp(1,1));
        Device_param.Region_ = zeros(Device_param.NoOfDomains, 1);
        for k = 1:1:Device_param.NoOfDomains
          Device_param.Region_(k) = str2double(temp(1,k+1));
        end
    end
end
fclose (fid);

for i=1:1:Device_param.NoOfDomains
    Material_cons.NonParabolicityFactor(i) = 0;
    Material_cons.hNonParabolicityFactor(i) = 0;
    LocalFileName = strcat('Mat',num2str(i),'.txt');
    FileName = strcat(Directory,'/',LocalFileName);
    fid=fopen(FileName,'r');
    %num_of_lines = fskipl(fid, Inf);
    
    fseek(fid, 0, 'eof');
    fileSize = ftell(fid);
    frewind(fid);
    %# Read the whole file.
    data = fread(fid, fileSize, 'uint8');
    %# Count number of line-feeds and increase by one.
    num_of_lines = sum(data == 10) + 1;
    fclose(fid);

    fid=fopen(FileName,'r');
    for j=1:num_of_lines
        txt = fgetl (fid);
        if (txt == -1)
          break
        end
        
        indexS = 1;
%         IndexM = index(txt,":");
%         IndexE = index(txt,";");
        IndexM = strfind(txt,":");
        IndexE = strfind(txt,";");
        
        if strcmp(txt(indexS:IndexM-1),"material_type")
            if (strcmp(txt(IndexM+1:IndexE-1),'oxide'))  
                Material_cons.MatType(i) ='o';
            elseif (strcmp(txt(IndexM+1:IndexE-1), 'semiconductor'))  
                Material_cons.MatType(i) ='s';
            end
        elseif strcmp(txt(indexS:IndexM-1),"effective_mass") % Confinement Masses
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.effective_mass_(k,i) = Global_cons.Free_electron_mass*str2double(temp(1,k));
            end
        elseif strcmp(txt(indexS:IndexM-1),"hole_effective_mass") % Confinement Masses
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.hole_effective_mass_(k,i) = Global_cons.Free_electron_mass*str2double(temp(1,k));
            end

        elseif strcmp(txt(indexS:IndexM-1),"permittivity")
            Material_cons.permittivity_(i) = Global_cons.Free_permittivity *str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"deltaEc")
            Material_cons.delta_Ec_(i) = str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"meDOS")
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.meDOS_(k,i) = Global_cons.Free_electron_mass*str2double(temp(1,k));
            end
        elseif strcmp(txt(indexS:IndexM-1),"mhDOS")
                temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.mhDOS_(k,i) = Global_cons.Free_electron_mass*str2double(temp(1,k));
            end
        elseif strcmp(txt(indexS:IndexM-1),"nonparabolicity")
            Material_cons.NonParabolicityFactor(i) = str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"hnonparabolicity")
            Material_cons.hNonParabolicityFactor(i) = str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"bandgap")
            Material_cons.bandgap(i) = Global_cons.Electron_charge*str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"valley_degeneracy")
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.valley_degeneracy(k,i) = str2double(temp(1,k));
            end
        elseif strcmp(txt(indexS:IndexM-1),"hole_valley_degeneracy")
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.hole_valley_degeneracy(k,i) = str2double(temp(1,k));
            end
        elseif strcmp(txt(indexS:IndexM-1),"Doping_NA")
                Material_cons.NA_(i) = str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"Doping_ND")
                Material_cons.ND_(i) = str2double(txt(IndexM+1:IndexE-1));
        end

    end
    fclose (fid);

end



Global_cons.Ef=0;

