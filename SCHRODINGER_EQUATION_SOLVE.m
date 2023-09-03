function [Sort_Eigen_Energies,Sort_Eigen_Vectors, Ec]=SCHRODINGER_EQUATION_SOLVE(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo)

to=-((Global_cons.hbar.^2)./(2.*(Mesh_cons.Spatial_distance.^2)));


for Valley=1:1:Sims_Constant.NoOfValleys
  HAMILTONIAN_MATRIX=zeros(Mesh.Number_Mesh_point);

  % First_row
  i = 1;
  Index = Mesh.Material(i);
  mi = Material_cons.effective_mass_(Valley, Index);
  Index = Mesh.Material(i+1);
  mip1 = Material_cons.effective_mass_(Valley, Index);
  U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index));
  Ec(i) = U/Global_cons.Electron_charge;
  HAMILTONIAN_MATRIX(i,i)   = -2.*to/((mip1+mi)*0.5) + U;
  HAMILTONIAN_MATRIX(i,i+1) = +1.*to/((mip1+mi)*0.5);

  for i=2:(Mesh.Number_Mesh_point-1)
      Index=Mesh.Material(i-1);
      mim1 = Material_cons.effective_mass_(Valley, Index); 
      Index=Mesh.Material(i);
      mi = Material_cons.effective_mass_(Valley, Index);
      Index=Mesh.Material(i+1);
      mip1 = Material_cons.effective_mass_(Valley, Index);

      Index=Mesh.Material(i-1);
      HAMILTONIAN_MATRIX(i,i-1) = +1.*to/((mi+mim1)*0.5);

      Index=Mesh.Material(i);
      U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index));
      HAMILTONIAN_MATRIX(i,i)   = -(1.*to/((mip1+mi)*0.5)+1.*to/((mi+mim1)*0.5)) + U;
      Ec(i) = U/Global_cons.Electron_charge;
      Index=Mesh.Material(i+1);
      HAMILTONIAN_MATRIX(i,i+1) = +1.*to/((mip1+mi)*0.5);
  end

  % Last_row
  i=(Mesh.Number_Mesh_point);
  Index=Mesh.Material(i);
  mi = Material_cons.effective_mass_(Valley, Index); 
  Index=Mesh.Material(i-1);
  mim1 = Material_cons.effective_mass_(Valley, Index); 
  HAMILTONIAN_MATRIX(i,i-1) = +1.*to/((mi+mim1)*0.5);
  Index=Mesh.Material(i);
  U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index));
  HAMILTONIAN_MATRIX(i,i)   = -2.*to/((mi+mim1)*0.5) + U;
  Ec(i) = U/Global_cons.Electron_charge;
  [EV,EE]=eigs(HAMILTONIAN_MATRIX,Sims_Constant.NoOfEigEnePerValley,'SM');

  for j=1:Sims_Constant.NoOfEigEnePerValley
      integ=0;
      for i=1:Mesh.Number_Mesh_point
          integ=integ+EV(i,j)*EV(i,j)*Mesh_cons.Spatial_distance;
      end
      EV(:,j)=EV(:,j)./sqrt(integ);
  end

  Eigen_Vectors=EV;
  Eigen_Energies=diag(EE./(Global_cons.Electron_charge));

  [Sort_Eigen_Energies(Valley,:), Indices]=sort(Eigen_Energies);
  Sort_Eigen_Vectors(Valley,:,:)= (Eigen_Vectors (:,Indices))';


  end
end