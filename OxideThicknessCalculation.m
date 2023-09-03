clc
clear 
close

nm2m = 1E-9;
EpsOx1 = 3.9;
EpsOx2 = 22.0;
EpsSc = 11.7;
Lg = 14*nm2m;
tsi = 5*nm2m;
Lambda = Lg/7.5;
tsio2 = 0.5;
% Bulk 
disp('SG MOSFET')
tox_Bulk = (Lambda^2/tsi) * (EpsOx1/EpsSc);
tox_Bulk = tox_Bulk/nm2m
tSiO2 = tsio2
tHiK = (tox_Bulk-tSiO2)*(EpsOx2/EpsOx1)
% Double Gate Structure / SOI
disp('DG MOSFET')
tox_DG = (Lambda^2/tsi) * (2*EpsOx1/EpsSc);
tox_DG = tox_DG/nm2m
tSiO2 = tsio2
tHiK = (tox_DG-tSiO2)*(EpsOx2/EpsOx1)
% FinFET (Trigated)
disp('FinFET/ TriG MOSFET')
tox_FF = (Lambda^2/tsi) * (pi*EpsOx1/EpsSc);
tox_FF = tox_FF/nm2m
tSiO2 = tsio2
tHiK = (tox_FF-tSiO2)*(EpsOx2/EpsOx1)
% Square
disp('Square GAA MOSFET')
tox_QG = (Lambda^2/tsi) * (4*EpsOx1/EpsSc);
tox_QG = tox_QG/nm2m
tSiO2 = tsio2
tHiK = (tox_QG-tSiO2)*(EpsOx2/EpsOx1)
% Circular