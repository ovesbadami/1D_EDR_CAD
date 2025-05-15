function [Sort_Eigen_Energies,Sort_Eigen_Vectors, BandEdge]=SCHRODINGER_EQUATION_SOLVE(Global_cons,Material_cons,Mesh_cons,Device_param,Mesh,Sims_Constant,Silo, CarrierType)

to=-((Global_cons.hbar.^2)./(2.*(Mesh_cons.Spatial_distance.^2)));


for Valley=1:1:Sims_Constant.NoOfValleys
  HAMILTONIAN_MATRIX=zeros(Mesh.Number_Mesh_point);

  % First_row
  i = 1;
  if strcmp(CarrierType,'electron')
      Index = Mesh.Material(i);
      mi = Material_cons.effective_mass_(Valley, Index);
      U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index));
      Index = Mesh.Material(i+1);
      mip1 = Material_cons.effective_mass_(Valley, Index);
  elseif strcmp(CarrierType,'hole')
      Index = Mesh.Material(i);
      mi = Material_cons.hole_effective_mass_(Valley, Index);
      U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index)) - Material_cons.bandgap(Index);
      U = -U;
      Index = Mesh.Material(i+1);
      mip1 = Material_cons.hole_effective_mass_(Valley, Index);
  end
  BandEdge(i) = U/Global_cons.Electron_charge;
  HAMILTONIAN_MATRIX(i,i)   = -2.*to/((mip1+mi)*0.5) + U;
  HAMILTONIAN_MATRIX(i,i+1) = +1.*to/((mip1+mi)*0.5);

  for i=2:(Mesh.Number_Mesh_point-1)

      if strcmp(CarrierType,'electron')
          Index=Mesh.Material(i-1);
          mim1 = Material_cons.effective_mass_(Valley, Index);
          Index=Mesh.Material(i);
          mi = Material_cons.effective_mass_(Valley, Index);
          U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index));
          Index=Mesh.Material(i+1);
          mip1 = Material_cons.effective_mass_(Valley, Index);
      elseif  strcmp(CarrierType,'hole')
          Index=Mesh.Material(i-1);
          mim1 = Material_cons.hole_effective_mass_(Valley, Index);
          Index=Mesh.Material(i);
          mi = Material_cons.hole_effective_mass_(Valley, Index);
          U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index)) - Material_cons.bandgap(Index);
          U = -U;
          Index=Mesh.Material(i+1);
          mip1 = Material_cons.hole_effective_mass_(Valley, Index);
      end

      HAMILTONIAN_MATRIX(i,i-1) = +1.*to/((mi+mim1)*0.5);
      HAMILTONIAN_MATRIX(i,i)   = -(1.*to/((mip1+mi)*0.5)+1.*to/((mi+mim1)*0.5)) + U;
      HAMILTONIAN_MATRIX(i,i+1) = +1.*to/((mip1+mi)*0.5);
      BandEdge(i) = U/Global_cons.Electron_charge;
  end

  % Last_row
  i=(Mesh.Number_Mesh_point);

   if strcmp(CarrierType,'electron')
      Index = Mesh.Material(i);
      mi = Material_cons.effective_mass_(Valley, Index);
      U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index));
      Index = Mesh.Material(i-1);
      mim1 = Material_cons.effective_mass_(Valley, Index);
  elseif strcmp(CarrierType,'hole')
      Index = Mesh.Material(i);
      mi = Material_cons.hole_effective_mass_(Valley, Index);
      U = Global_cons.Electron_charge*(-Silo.V(i) + Material_cons.delta_Ec_(Index)) - Material_cons.bandgap(Index);
      U = -U;
      Index = Mesh.Material(i-1);
      mim1 = Material_cons.hole_effective_mass_(Valley, Index);
   end

  HAMILTONIAN_MATRIX(i,i-1) = +1.*to/((mi+mim1)*0.5);
  HAMILTONIAN_MATRIX(i,i)   = -2.*to/((mi+mim1)*0.5) + U;
  BandEdge(i) = U/Global_cons.Electron_charge;

  
  
  [EV,EE]=eigs(HAMILTONIAN_MATRIX,Sims_Constant.NoOfEigEnePerValley,'SM');
%     [EV,EE]=eig(HAMILTONIAN_MATRIX);
  

  
  Eigen_Vectors=EV;
  Eigen_Energies=diag(EE./(Global_cons.Electron_charge));
 
  [Sort_Eigen_Energies(Valley,:), Indices]=sort(Eigen_Energies);
  Sort_Eigen_Vectors(Valley,:,:)= (Eigen_Vectors (:,Indices))';

%   for i=1:2:Sims_Constant.NoOfEigEnePerValley
%       if (abs(Sort_Eigen_Energies(Valley,i) - Sort_Eigen_Energies(Valley,i+1))<1E-3)
%           EV1 = Sort_Eigen_Vectors(Valley,i,:);
%           EV2 = Sort_Eigen_Vectors(Valley,i+1,:);
%           Sort_Eigen_Vectors(Valley,i,:) = 0.5*(EV1+EV2);
%           Sort_Eigen_Vectors(Valley,i+1,:) = 0.5*(EV1-EV2);
%       end
%   end

  for j=1:Sims_Constant.NoOfEigEnePerValley
      integ=0;
      for i=1:Mesh.Number_Mesh_point
          integ=integ+Sort_Eigen_Vectors(Valley,j,i)*Sort_Eigen_Vectors(Valley,j,i)*Mesh_cons.Spatial_distance;
      end
      Sort_Eigen_Vectors(Valley,j,:)=Sort_Eigen_Vectors(Valley,j,:)./sqrt(integ);
  end

end

end



