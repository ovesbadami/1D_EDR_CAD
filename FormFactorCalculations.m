%clc
%clear
close all

nm2m = 1E-9;
m2cm = 1E2;

Geom = load ("Geometry.dat");
X = Geom(:,1);
dX = (X(2,1)-X(1,1))*nm2m;

StartOfSemi = find(X == 5);
EndOfSemi = find(X == 5+150);
zeta = zeros(Sims_Constant.NoOfValleys,Sims_Constant.NoOfEigEnePerValley,length(Geom));
for v = 1:1:Sims_Constant.NoOfValleys
    Filename = "ElectronEigenFunctions_"+num2str(v)+".dat";
    EV = load(Filename);
    zeta(v,:,:) = EV';
end

FormFactor = zeros(Sims_Constant.NoOfValleys,Sims_Constant.NoOfEigEnePerValley, Sims_Constant.NoOfValleys,Sims_Constant.NoOfEigEnePerValley);
for v = 1:1:Sims_Constant.NoOfValleys
     for s = 1:1:Sims_Constant.NoOfEigEnePerValley
         for vp = 1:1:Sims_Constant.NoOfValleys
             for sp = 1:1:Sims_Constant.NoOfEigEnePerValley
                 FormFactor(v,s,vp,sp) = trapz((zeta(v,s,StartOfSemi:EndOfSemi).^2).*(zeta(vp,sp,StartOfSemi:EndOfSemi).^2))*dX;
                  %FormFactor(v,s,vp,sp) = trapz((zeta(v,s,:).^2).*(zeta(vp,sp,:).^2))*dX;  
             end
         end
     end
end

% Constants
e = Global_cons.Electron_charge;
hbar = Global_cons.hbar;
kBT = 0.026*e;
Dac = 14.6*e;
Density = 2.33 * (10^-3)/(1E-6);
SoundVel = 9620;

Prefactor0 = (Dac^2)*(kBT)/((SoundVel^2)*Density*hbar^3);

Energy = min(min(Silo.EigenEnergy)):0.005:(min(min(Silo.EigenEnergy))+1);
Energy = Energy*e;

S_AP = zeros(Sims_Constant.NoOfValleys,Sims_Constant.NoOfEigEnePerValley,length(Energy));
for E = 1:1:length(Energy)
    for v = 1:1:Sims_Constant.NoOfValleys
         for s = 1:1:Sims_Constant.NoOfEigEnePerValley
             for vp = 1:1:Sims_Constant.NoOfValleys
                 if (v ~= vp)
                     continue
                 end
                 for sp = 1:1:Sims_Constant.NoOfEigEnePerValley
                     if (Energy(E)>e*Silo.EigenEnergy(vp,sp))
                         Prefactor = Prefactor0*Material_cons.meDOS_(vp,2);
                         S_AP(v,s,E) = S_AP(v,s,E) + Prefactor* FormFactor(v,s,vp,sp);                       
                     end
                 end
             end
         end    
    end
end


%S_AP_11=squeeze(S_AP(1,1,:));
%plot(Energy/e-min(min(Silo.EigenEnergy)), S_AP_11)