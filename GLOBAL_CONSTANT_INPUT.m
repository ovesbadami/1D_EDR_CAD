function [Global_cons,Material_cons,Mesh_cons,Device_param,Sims_Constant]=GLOBAL_CONSTANT_INPUT()


%GLOBAL_CONSTANTS READ THE TEXT FILE 
Variable_import=fopen('C:\Users\ovesb\Desktop\1D_SchPoiSolver\Data_import_SI_unit.txt','r');

%GLOBAL VARIABLES
%GLOBAL_CONSTANTS STORE IN STRING
Global_TEMP=fscanf(Variable_import,'%s',1);
Global_hbar=fscanf(Variable_import,'%s',1);
Global_FREE_ELECTRON_MASS=fscanf(Variable_import,'%s',1);
Global_boltz_cons=fscanf(Variable_import,'%s',1);
Global_Elec_charge=fscanf(Variable_import,'%s',1);
Global_permittivity=fscanf(Variable_import,'%s',1);

Sims_Damping=fscanf(Variable_import,'%s',1);
Sims_Quantum_Correction=fscanf(Variable_import,'%s',1);
Sims_NO_OF_VALLEYS=fscanf(Variable_import,'%s',1);
Sims_NO_EIGEN_PER_VALLEY=fscanf(Variable_import,'%s',1);

%TO STORE GLOBAL_CONSTANTS NUMBERS IN CELL
TEMP1 = regexp(Global_TEMP, '\d*','match');
hbar1 = regexp(Global_hbar,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
m01 = regexp(Global_FREE_ELECTRON_MASS,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
boltz_cons1 = regexp(Global_boltz_cons,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
Elec_charge = regexp(Global_Elec_charge,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
permittivity = regexp(Global_permittivity,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');

Damping = regexp(Sims_Damping,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
QuantumCorrection = regexp(Sims_Quantum_Correction,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
NoOfValleys = regexp(Sims_NO_OF_VALLEYS,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
NoOfEigEnePerValley = regexp(Sims_NO_EIGEN_PER_VALLEY,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');

%GLOBAL_CONSTANTS NUMBERS FROM CELL AS DOUBLE
Global_cons.TEMPERATURE=str2double(TEMP1) ;
Global_cons.hbar=str2double(hbar1) ;
Global_cons.Free_electron_mass=str2double(m01) ;
Global_cons.Boltzmann_cons=str2double(boltz_cons1) ;
Global_cons.Electron_charge=str2double(Elec_charge) ;
Global_cons.Free_permittivity=str2double(permittivity) ;

Global_cons.Ef=0;

Sims_Constant.Damping = str2double(Damping);
Sims_Constant.QuantumCorrection = str2double(QuantumCorrection);
Sims_Constant.NoOfValleys = str2double(NoOfValleys);
Sims_Constant.NoOfEigEnePerValley = str2double(NoOfEigEnePerValley);

%SiO2_MATERIAL
%MATERIAL_CONSTANTS STORE IN STRING
Material_SiO2_effective_mass=fscanf(Variable_import,'%s',1);
Material_SiO2_permittivity=fscanf(Variable_import,'%s',1);

%TO STORE MATERIAL_CONSTANTS NUMBERS IN CELL
SiO2_effective_mass1= regexp(Material_SiO2_effective_mass,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
SiO2_permittivity1= regexp(Material_SiO2_permittivity,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');

%MATERIAL_CONSTANTS NUMBERS FROM CELL AS DOUBLE
Material_cons.effective_mass_(1)=str2double(SiO2_effective_mass1)*Global_cons.Free_electron_mass;
Material_cons.permittivity_(1)=str2double(SiO2_permittivity1)*Global_cons.Free_permittivity;
Material_cons.delta_Ec_(1)=3.2;

%SILICON_MATERIAL
%MATERIAL_CONSTANTS STORE IN STRING
Material_Si_effective_mass=fscanf(Variable_import,'%s',1);
Material_Si_permittivity=fscanf(Variable_import,'%s',1);
Material_Si_bandgap=fscanf(Variable_import,'%s',1);

%TO STORE MATERIAL_CONSTANTS NUMBERS IN CELL
Si_effective_mass1= regexp(Material_Si_effective_mass,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
Si_permittivity1= regexp(Material_Si_permittivity,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
Si_bandgap1= regexp(Material_Si_bandgap,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');

%MATERIAL_CONSTANTS NUMBERS FROM CELL AS DOUBLE
Material_cons.effective_mass_(2)=str2double(Si_effective_mass1)*Global_cons.Free_electron_mass;
Material_cons.permittivity_(2)=str2double(Si_permittivity1)*Global_cons.Free_permittivity;
Material_cons.bandgap=str2double(Si_bandgap1)*Global_cons.Electron_charge;
Material_cons.delta_Ec_(2)=0;

%in m-3 order
Material_cons.ND_(2)=0.0;
Material_cons.NA_(2)=1e24;
%in m-3 order
Material_cons.NC3D_(2)=3e25;
Material_cons.NV3D_(2)=1e25;

%in m-2 order for confined Systems
Material_cons.NC2D=1e37;

%HfO2_MATERIAL
%MATERIAL_CONSTANTS STORE IN STRING
Material_HfO2_effective_mass=fscanf(Variable_import,'%s',1);
Material_HfO2_permittivity=fscanf(Variable_import,'%s',1);

%TO STORE MATERIAL_CONSTANTS NUMBERS IN CELL
HfO2_effective_mass1= regexp(Material_HfO2_effective_mass,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');
HfO2_permittivity1= regexp(Material_HfO2_permittivity,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');

%MATERIAL_CONSTANTS NUMBERS FROM CELL AS DOUBLE
Material_cons.effective_mass_(3)=str2double(HfO2_effective_mass1)*Global_cons.Free_electron_mass;
Material_cons.permittivity_(3)=str2double(HfO2_permittivity1)*Global_cons.Free_permittivity;
Material_cons.delta_Ec_(3)=3.2;


%MESH_PROPERTIES
%MESH_CONSTANTS STORE IN STRING
Mesh_Spatial_dist=fscanf(Variable_import,'%s',1);

%TO STORE MATERIAL_CONSTANTS NUMBERS IN CELL
Mesh_Spatial_distance1= regexp(Mesh_Spatial_dist,'[+-]?\d+\.?\d*([eE][+-]?\d+)?','match');

%MESH_CONSTANTS NUMBERS FROM CELL AS DOUBLE
Mesh_cons.Spatial_distance=str2double(Mesh_Spatial_distance1) ;

%SiO2
Device_param.Region_(1)=2e-9;

%Si
Device_param.Region_(2)=10e-9;

%HfO2
Device_param.Region_(3)=2e-9;
%A
fclose('all');


