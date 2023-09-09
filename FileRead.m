function [Global_cons,Material_cons,Mesh_cons,Device_param,Sims_Constant]=FileRead(Directory)


Sims_Constant.eQuantumCorrection = 0;
Sims_Constant.hQuantumCorrection = 0;


FileName = strcat(Directory,'\','InputFile.txt')
fid=fopen(FileName,'r');
num_of_lines = fskipl(fid, Inf);
fclose (fid);

fid=fopen(FileName,'r');
for i=1:num_of_lines,
    txt = fgetl (fid);
    indexS = 1;
    IndexM = index(txt,":");
    IndexE = index(txt,";");
    
    if strcmp(txt(indexS:IndexM-1),"Temperature")
        Global_cons.TEMPERATURE = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"hbar")
        Global_cons.hbar = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"FREE_ELECTRON_MASS")
        Global_cons.Free_electron_mass = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"BOLTZMANN_CONSTANT")
        Global_cons.Boltzmann_cons = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"ELECTRON_CHARGE")
        Global_cons.Electron_charge = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"PERMITTIVITY")
        Global_cons.Free_permittivity = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"DAMPING")
        Sims_Constant.Damping = str2double(txt(IndexM+1:IndexE-1));
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
    elseif strcmp(txt(indexS:IndexM-1),"GATE_BIAS")
        temp = strsplit(txt(IndexM+1:IndexE-1));
        Device_param.MinGateBias = str2double(temp(1,1));
        Device_param.GateBiasStep = str2double(temp(1,2));
        Device_param.MaxGateBias = str2double(temp(1,3));
    elseif strcmp(txt(indexS:IndexM-1),"BACK_GATE_BIAS")
        Device_param.BackGateBias = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"WORKFUNCTION_DIFF")
        Device_param.WFDiff = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"L1_m")
##        Device_param.Region_(1) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"L2_m")
##        Device_param.Region_(2) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"L3_m")
##        Device_param.Region_(3) = str2double(txt(IndexM+1:IndexE-1));
    elseif strcmp(txt(indexS:IndexM-1),"NO_OF_DOMAINS")
        temp = strsplit(txt(IndexM+1:IndexE-1));
        Device_param.NoOfDomains = str2double(temp(1,1));
        Device_param.Region_ = zeros(Device_param.NoOfDomains, 1);    
        for k = 1:1:Device_param.NoOfDomains
          Device_param.Region_(k) = str2double(temp(1,k+1));
        endfor
    elseif strcmp(txt(indexS:IndexM-1),"material_type")
        Device_param.MatType = txt(IndexM+1:IndexE-1);
    endif
endfor
fclose (fid);

##FileName = strcat(Directory,'\','Mat1.txt')
##fid=fopen(FileName,'r');
##num_of_lines = fskipl(fid, Inf);
##fclose (fid);
##
##fid=fopen(FileName,'r');
##for i=1:num_of_lines,
##    txt = fgetl (fid);
##    indexS = 1;
##    IndexM = index(txt,":");
##    IndexE = index(txt,";");
##
##    if strcmp(txt(indexS:IndexM-1),"effective_mass")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.effective_mass_(k,1) = Global_cons.Free_electron_mass*str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"permittivity")
##        Material_cons.permittivity_(1) = Global_cons.Free_permittivity *str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"deltaEc")
##        Material_cons.delta_Ec_(1) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"meDOS")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.meDOS_(k,1) = Global_cons.Free_electron_mass*str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"mhDOS")
##            Material_cons.mhDOS_(1) = Global_cons.Free_electron_mass*str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"bandgap")
##        Material_cons.bandgap(1) = Global_cons.Electron_charge*str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"valley_degeneracy")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.valley_degeneracy(k,1) = str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"Doping_NA")
##            Material_cons.NA_(1) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"Doping_ND")
##            Material_cons.ND_(1) = str2double(txt(IndexM+1:IndexE-1));
##    endif
##
##endfor
##fclose (fid);
##
##FileName = strcat(Directory,'\','Mat2.txt')
##fid=fopen(FileName,'r');
##num_of_lines = fskipl(fid, Inf);
##fclose (fid);
##
##fid=fopen(FileName,'r');
##for i=1:num_of_lines,
##    txt = fgetl (fid);
##    indexS = 1;
##    IndexM = index(txt,":");
##    IndexE = index(txt,";");
##
##    if strcmp(txt(indexS:IndexM-1),"effective_mass")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.effective_mass_(k,2) = Global_cons.Free_electron_mass*str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"permittivity")
##        Material_cons.permittivity_(2) = Global_cons.Free_permittivity *str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"deltaEc")
##        Material_cons.delta_Ec_(2) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"meDOS")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.meDOS_(k,2) = Global_cons.Free_electron_mass*str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"mhDOS")
##            Material_cons.mhDOS_(2) = Global_cons.Free_electron_mass*str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"bandgap")
##          Material_cons.bandgap(2) = Global_cons.Electron_charge*str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"valley_degeneracy")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.valley_degeneracy(k,2) = str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"Doping_NA")
##            Material_cons.NA_(2) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"Doping_ND")
##            Material_cons.ND_(2) = str2double(txt(IndexM+1:IndexE-1));
##    endif
##endfor
##fclose (fid);
##
##FileName = strcat(Directory,'\','Mat3.txt')
##fid=fopen(FileName,'r');
##num_of_lines = fskipl(fid, Inf);
##fclose (fid);
##
##fid=fopen(FileName,'r');
##for i=1:num_of_lines,
##    txt = fgetl (fid);
##    indexS = 1;
##    IndexM = index(txt,":");
##    IndexE = index(txt,";");
##
##    if strcmp(txt(indexS:IndexM-1),"effective_mass")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.effective_mass_(k,3) = Global_cons.Free_electron_mass*str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"permittivity")
##        Material_cons.permittivity_(3) = Global_cons.Free_permittivity *str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"deltaEc")
##        Material_cons.delta_Ec_(3) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"meDOS")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.meDOS_(k,3) = Global_cons.Free_electron_mass*str2double(temp(1,k));
##        end
##    elseif strcmp(txt(indexS:IndexM-1),"mhDOS")
##            Material_cons.mhDOS_(3) = Global_cons.Free_electron_mass*str2double(txt(IndexM+1:IndexE-1));    
##    elseif strcmp(txt(indexS:IndexM-1),"bandgap")
##        Material_cons.bandgap(3) = Global_cons.Electron_charge*str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"valley_degeneracy")
##        temp = strsplit(txt(IndexM+1:IndexE-1));
##        for k=1:Sims_Constant.NoOfValleys
##            Material_cons.valley_degeneracy(k,3) = str2double(temp(1,k));
##        end
##        elseif strcmp(txt(indexS:IndexM-1),"Doping_NA")
##            Material_cons.NA_(3) = str2double(txt(IndexM+1:IndexE-1));
##    elseif strcmp(txt(indexS:IndexM-1),"Doping_ND")
##            Material_cons.ND_(3) = str2double(txt(IndexM+1:IndexE-1));
##    endif
##
##
##
##endfor
##fclose (fid);


for i=1:1:3
  
    LocalFileName = strcat('Mat',num2str(i),'.txt')
    FileName = strcat(Directory,'\',LocalFileName)
    fid=fopen(FileName,'r');
    num_of_lines = fskipl(fid, Inf);
    fclose (fid);

    fid=fopen(FileName,'r');
    for j=1:num_of_lines,
        txt = fgetl (fid);
        indexS = 1;
        IndexM = index(txt,":");
        IndexE = index(txt,";");

        if strcmp(txt(indexS:IndexM-1),"effective_mass")
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.effective_mass_(k,i) = Global_cons.Free_electron_mass*str2double(temp(1,k));
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
        elseif strcmp(txt(indexS:IndexM-1),"bandgap")
            Material_cons.bandgap(i) = Global_cons.Electron_charge*str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"valley_degeneracy")
            temp = strsplit(txt(IndexM+1:IndexE-1));
            for k=1:Sims_Constant.NoOfValleys
                Material_cons.valley_degeneracy(k,i) = str2double(temp(1,k));
            end
        elseif strcmp(txt(indexS:IndexM-1),"Doping_NA")
                Material_cons.NA_(i) = str2double(txt(IndexM+1:IndexE-1));
        elseif strcmp(txt(indexS:IndexM-1),"Doping_ND")
                Material_cons.ND_(i) = str2double(txt(IndexM+1:IndexE-1));
        endif

    endfor
    fclose (fid);

endfor
  
  

Global_cons.Ef=0;

