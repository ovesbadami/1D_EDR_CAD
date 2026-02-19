function [] = PrintTheLeftHandSideMatrixOfPoisson(Material_cons,Mesh_cons,Mesh)
    to=1./(Mesh_cons.Spatial_distance.^2);
    LHS = zeros(Mesh.Number_Mesh_point);
    i=1;
    LHS(i,i)=1;
    for i=2:(Mesh.Number_Mesh_point-1)
        Index=Mesh.Material(i-1);
        Ind=Mesh.Material(i);
        Indx=Mesh.Material(i+1);
        
        LHS(i,i-1) = (1.*to)*((Material_cons.permittivity_(Index)+Material_cons.permittivity_(Ind))*0.5);
        LHS(i,i)   = ((-1.*to)*(Material_cons.permittivity_(Ind)+((Material_cons.permittivity_(Index)+Material_cons.permittivity_(Indx))*0.5)));
        LHS(i,i+1) = (1.*to)*((Material_cons.permittivity_(Ind)+Material_cons.permittivity_(Indx))*0.5);
    end
    i = (Mesh.Number_Mesh_point);
    LHS(i,i)=1;
    
    dlmwrite('LeftHandSidePoissonMatrix', LHS)
    
end
