function [v_] = POISSON_SOLVER(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)

to=1./(Mesh_cons.Spatial_distance.^2);
v_ = Silo.V;

for i=1:Mesh.Number_Mesh_point
    Index=Mesh.Material(i);
##    if (Mesh.Material(i)>1&&Mesh.Material(i)<3)
        kBT=(Global_cons.Boltzmann_cons*Global_cons.TEMPERATURE);
        rho(i)=Global_cons.Electron_charge*(Material_cons.ND_(Index)-Material_cons.NA_(Index)+Silo.p(i)-Silo.n(i));
        drho(i)=-(Global_cons.Electron_charge/kBT)*Global_cons.Electron_charge*(Silo.p(i)+Silo.n(i)); 
##    else
##        rho(i)=0;
##        drho(i)=0;
##    end
end

Jacobian_MATRIX=zeros(Mesh.Number_Mesh_point);
Residual_FUNCTION=zeros(Mesh.Number_Mesh_point,1);

% First_row
i=1;
Jacobian_MATRIX(i,i)=1;
Residual_FUNCTION(i)=0;
Jacobian_MATRIX(i,i+1)=0;

for i=2:(Mesh.Number_Mesh_point-1)
    Index=Mesh.Material(i-1);
    Ind=Mesh.Material(i);
    Indx=Mesh.Material(i+1);
    
    %for i-1th position
    Jacobian_MATRIX(i,i-1)=(1.*to)*((Material_cons.permittivity_(Index)+Material_cons.permittivity_(Ind))*0.5);
    Residual(i-1)=(1.*to)*((Material_cons.permittivity_(Index)+Material_cons.permittivity_(Ind))*0.5)*v_(i-1);
   
    %for ith position
    Jacobian_MATRIX(i,i)=((-1.*to)*(Material_cons.permittivity_(Ind)+((Material_cons.permittivity_(Index)+Material_cons.permittivity_(Indx))*0.5)))+drho(i);
    Residual(i)=(((-1.*to)*(Material_cons.permittivity_(Ind)+((Material_cons.permittivity_(Index)+Material_cons.permittivity_(Indx))*0.5))))*v_(i)+rho(i);
    
    %for i+1th position
    Jacobian_MATRIX(i,i+1)=(1.*to)*((Material_cons.permittivity_(Ind)+Material_cons.permittivity_(Indx))*0.5);
    Residual(i+1)=((1.*to)*((Material_cons.permittivity_(Ind)+Material_cons.permittivity_(Indx))*0.5))*v_(i+1);
    
    %Residual function (Ri)
    Residual_FUNCTION(i)=-(Residual(i-1)+Residual(i)+Residual(i+1));  
end

% Last_row
i=(Mesh.Number_Mesh_point);
Jacobian_MATRIX(i,i-1)=0;
Jacobian_MATRIX(i,i)=1;

Residual_FUNCTION(i)=0;

%calculation of delV
delV=Jacobian_MATRIX\(Residual_FUNCTION);

v_=v_+Sims_Constant.Damping.*delV';

end