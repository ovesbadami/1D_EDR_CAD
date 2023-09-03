function [GateCurrent]=GateLeakageCurrent(GateBias, Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)
    Ig = 0.0;
    dx = Mesh_cons.Spatial_distance;
    kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
    hbar = Global_cons.hbar;
    e = Global_cons.Electron_charge;
    
    
    % Classical Method
    Efl =  0.0;
    Efr = -GateBias;
    mDOS = Material_cons.meDOS_(1,2);
    Prefactor = kBT*e*mDOS/(2*pi*pi*hbar*hbar*hbar);
    Ig = 0.0;
    Emin = -e*Silo.V(Mesh.SemiFirst);
    Emax = Emin + 1*e;
    NoOfEnergyPoints = 50;
    dE = (Emax-Emin)/NoOfEnergyPoints;
    ValleyIndex = 1;
    for i=1:1:NoOfEnergyPoints
        E = Emin+(i-1)*dE;
        T = WKB_TunnelProbability(E/e,ValleyIndex,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
        Supplyfunction = log((1+exp(Global_cons.Electron_charge*(Efl-E)/kBT))/(1+exp(Global_cons.Electron_charge*(Efr-E)/kBT)));
        
        Ig = Ig + Prefactor*T*Supplyfunction*dE;
        
    endfor
    GateCurrent.Ig_total = Ig; 
    
%    % Method by Rana et al.
%    for i=1:1:Sims_Constant.NoOfValleys
%        for j=1:1:Sims_Constant.NoOfEigEnePerValley
%            EE = Silo.EigenEnergy(i,j);
%            xl = GetLeftTurningPoint(EE,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
%            xr = GetRightTurningPoint(EE,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
            
%            Vel_Inv(i,j)=0.0;
%            for k=xl:1:xr 
%                Index = Mesh.Material(k);
%                Vel_Inv(i,j) = Vel_Inv(i,j) + sqrt(2*Material_cons.effective_mass_(i,Index)/(Global_cons.Electron_charge*(EE-(-Silo.V(k) + Material_cons.delta_Ec_(Index)))))*dx;
%            endfor
                        
%            T(i,j) = WKB_TunnelProbability(EE,i,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo);
            
%            if (Vel_Inv(i,j) == 0.0)
%              temp_BP = 0.0
%            endif
            
%            Tau_inv(i,j) = T(i,j)/Vel_Inv(i,j);
%            Efl =  0.0;
%            Efr = -GateBias;
#            SupplyFunction = (1+exp(Global_cons.Electron_charge*(Efl-EE)/kBT))/(1+exp(Global_cons.Electron_charge*(Efr-EE)/kBT));
#            mDOS = Material_cons.meDOS_(i,2);
#            Ig = Ig + Material_cons.valley_degeneracy(i,2)*(Global_cons.Electron_charge*mDOS*kBT)/(pi*Global_cons.hbar^2)*log(SupplyFunction)*Tau_inv(i,j);
#            
#            IG_Val_EE(i,j) = Material_cons.valley_degeneracy(i,2)*((Global_cons.Electron_charge*mDOS*kBT)/(pi*Global_cons.hbar^2))*log(SupplyFunction)*Tau_inv(i,j);
#        endfor
#   endfor
##   GateCurrent.T = T;
##   GateCurrent.Ig = IG_Val_EE;      
##   GateCurrent.Tau_inv = Tau_inv;
##   GateCurrent.Ig_total = Ig; 
   
function [T] = WKB_TunnelProbability(EE,Valley,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)
  
    Integrand = 0.0;
    dx = Mesh_cons.Spatial_distance;
    for i=Mesh.SemiFirst-1:-1:1
        Index = Mesh.Material(i);
        mi = Material_cons.effective_mass_(Valley, Index);
        Ec(i) = -Silo.V(i) + Material_cons.delta_Ec_(Index);
        if (Ec(i)> EE)
            Integrand = Integrand + sqrt(2*mi*Global_cons.Electron_charge*(Ec(i)-EE))*dx;
        else 
            Integrand = Integrand + 0.0;
        endif
    endfor
  
    T = exp(-2*Integrand/Global_cons.hbar);
   
function [xl] = GetLeftTurningPoint(EE,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)
    xl = 0;  
    for i=Mesh.SemiFirst-1:1:Mesh.Number_Mesh_point-1
        Index = Mesh.Material(i);
        Ec_i = -Silo.V(i) + Material_cons.delta_Ec_(Index);
        Index = Mesh.Material(i+1);
        Ec_ip1 = -Silo.V(i+1) + Material_cons.delta_Ec_(Index);
        if (Ec_i > EE && Ec_ip1<EE)
            xl = i+1;
            break;
        end
    end
    
function [xr] = GetRightTurningPoint(EE,Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)
    xr = 0;
    for i=Mesh.SemiFirst:1:Mesh.Number_Mesh_point
        Index = Mesh.Material(i);
        Ec_i = -Silo.V(i) + Material_cons.delta_Ec_(Index);
        Index = Mesh.Material(i-1);
        Ec_im1 = -Silo.V(i-1) + Material_cons.delta_Ec_(Index);
        if (Ec_i > EE && Ec_im1<EE)
            xr = i-1;
            break;
        end
    end

function [ITAT] = CalculateTrapAssistedTunneling()
    kBT=(Global_cons.Boltzmann_cons.*Global_cons.TEMPERATURE);
    fB = 1/(1+exp(PhononEnergy/kBT));
    MaximumNoOfPhonons = 10;
    DoSStartPrefactor = ((sqrt(2)/(pi*pi))*(MassStart/(hbar*hbar))^1.5);
    DoSEndPrefactor = ((sqrt(2)/(pi*pi))*(MassEnd/(hbar*hbar))^1.5);
    
    j = 0;
    for i=Mesh.SemiFirst:1:Mesh.Number_Mesh_point
        Ec(i) = -Silo.V(i) + Material_cons.delta_Ec_(Index);
        EtD = 3;      
        Et = Ec-EtD;
        rt = hbar/(sqrt(2*Et_D*m0*meff));
        c0=(4*pi*4*pi*rt*rt*rt/(hbar*Eg))*ElectroOpticalEnergy;
        fB = 1+(exp(PhononEnergy/kBT)-1);
        DoS_Start = DoSPrefactor*sqrt(E-EcStart);
        DoS_End = DoSPrefactor*sqrt(E-EcEnd);
        
        TauS_Inv = 0.0;
        TauG_Inv = 0.0;
        for j = 0:1:MaximumNoOfPhonons        
            E = Et+j*PhononEnergy
            
            Lm = MultiphononTransitionProbability(NoOfPhonon, fB);
            
            f_S = 1+(1+exp((E-EfS)/kBT));
            f_G = 1+(1+exp((E-EfG)/kBT));
            
            TauS_Inv = TauS_Inv + DoS_Start*f_S*TwkbS2T*Lm;
            TauG_Inv = TauG_Inv + DoS_End*(1.0-f_G)*TwkbT2G*Lm*exp(-j*PhononEnergy/kBT);
        end    
        TauS_Inv = c0*TauS_Inv;
        TauG_Inv = c0*TauG_Inv;
        
        j = j+Nt*(1/(TauS_Inv+TauG_Inv))*dX
        
    end
  
function [Lm] = MultiphononTransitionProbability (NoOfPhonon, fB)
    Lm = (((fB+1)/fB)^(NoOfPhonon/2))*(exp(-S*(2*fB+1)))* besseli(NoOfPhonon, 2*S*sqrt(fB*(fB+1)));
  
function [T] = TransmissionRateForTAT(E, x)
   NoOfDiscPoints = 20;
   dx = 0/(NoOfDiscPoints);
   
    Integrand = 0.0;
    for i=1:1:NoOfDiscPoints
		x = xStart+i*dx;
		[ibefore,iafter] = GetTheBeforeAndAfterMeshPoints(x);		
        IndexBefore = Mesh.Material(ibefore);
		IndexAfter = Mesh.Material(iafter);
		
		mi = Material_cons.effective_mass_(Valley, Index);
        Ec = -0.5(Silo.V(ibefore)+Silo.V(iafter)) + 0.5*(Material_cons.delta_Ec_(IndexAfter)+Material_cons.delta_Ec_(IndexBefore));
        if (Ec > E)
            Integrand = Integrand + sqrt(2*mi*Global_cons.Electron_charge*(Ec(i)-E))*dx;
        else 
            Integrand = Integrand + 0.0;
        endif
    endfor
  
    T = exp(-2*Integrand/Global_cons.hbar);
 