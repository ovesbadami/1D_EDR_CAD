function Mesh=Make_mesh(Mesh_cons,Device_param)

Mesh.Total_length=sum(Device_param.Region_);%(1)+Device_param.Region_(2)+Device_param.Region_(3);

Mesh.Number_Mesh_point=single(Mesh.Total_length./Mesh_cons.Spatial_distance);

Delta = 1E-12;

for i=1:Mesh.Number_Mesh_point
    Mesh.Width(i) = (i)*Mesh.Total_length/Mesh.Number_Mesh_point;
    Distance = i*Mesh_cons.Spatial_distance;
    for j = 1:1:Device_param.NoOfDomains
        if j == 1
            Ljm1 = 0;
        else 
            Ljm1 = Ljm1 + Device_param.Region_(j-1);
        endif
            Lj = Ljm1+Device_param.Region_(j);
        if (i*Mesh_cons.Spatial_distance+Delta > Ljm1 && i*Mesh_cons.Spatial_distance <= Lj+Delta )
            Mesh.Material(i)= j;
            break;
       endif
    end
##    if( i*Mesh_cons.Spatial_distance<=Device_param.Region_(1))
##        Mesh.Material(i)=1;
##    elseif( i*Mesh_cons.Spatial_distance>Device_param.Region_(1)&& i*Mesh_cons.Spatial_distance<=(Device_param.Region_(2)+Device_param.Region_(3)))
##        Mesh.Material(i)=2;
##    elseif( i*Mesh_cons.Spatial_distance>Device_param.Region_(2))
##        Mesh.Material(i)=3;
##    end
end

##for i=2:Mesh.Number_Mesh_point-1
##  
##    if (Mesh.Material(i) == 1 && Mesh.Material(i+1) == 2)
##        Mesh.SemiFirst = i+1;
##    else if (Mesh.Material(i) == 3 && Mesh.Material(i-1) == 2)
##        Mesh.SemiLast = i-1;
##    end
##end


end