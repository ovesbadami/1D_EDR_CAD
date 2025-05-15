function [Silo] = EigenFunctionPostProcessing(Mesh_cons, Mesh,Sims_Constant,Silo)

dx = Mesh_cons.Spatial_distance;
x = dx*(1:1:Mesh.Number_Mesh_point)*(1E+9);

for Valley=1:1:Sims_Constant.NoOfValleys
    for subband=1:2:Sims_Constant.NoOfEigEnePerValley
        if (abs(Silo.EigenEnergy(Valley, subband)-Silo.EigenEnergy(Valley, subband+1)) < 3E-3);
            
            lengthOfVec = length(Silo.EigenVector(Valley,subband,1:end));
            
            ScalingFactorL = max(abs(Silo.EigenVector(Valley,subband,1:lengthOfVec/2)))/max(abs(Silo.EigenVector(Valley,subband+1,1:lengthOfVec/2)));
            % Step1: Make both the wavefunctions to have positive peak in the range (0, T/2)
            [max_values index] = max(abs(Silo.EigenVector(Valley,subband,1:lengthOfVec/2)));
            if (Silo.EigenVector(Valley,subband,index) < 0);
               EV1PP_1(1:length(Silo.EigenVector(1,subband,:)),1) = -Silo.EigenVector(Valley,subband,:);
            else
               EV1PP_1(1:length(Silo.EigenVector(1,subband,:)),1) =  Silo.EigenVector(Valley,subband,:);
            end
            [max_values index] = max(abs(Silo.EigenVector(Valley,subband+1,1:lengthOfVec/2)));
            if (Silo.EigenVector(Valley,subband+1,index) < 0)
                EV2PP_1(1:length(Silo.EigenVector(1,subband+1,:)),1) = -Silo.EigenVector(Valley,subband+1,:);
            else
                EV2PP_1(1:length(Silo.EigenVector(1,subband+1,:)),1) = Silo.EigenVector(Valley,subband+1,:);
            end
                      
            % Step2: Scale the waveufunctions such that they have the same peak value and strubtract them
            ScalingFactorR = max(abs(Silo.EigenVector(Valley,subband,lengthOfVec/2:lengthOfVec)))/max(abs(Silo.EigenVector(Valley,subband+1,lengthOfVec/2:lengthOfVec)));
            
            % Step1: Make both the wavefunctions to have positive peak in the range (T/2,2)
            [max_values index] = max(abs(Silo.EigenVector(Valley,subband,lengthOfVec/2:lengthOfVec)));
            index = index+lengthOfVec/2-1;
            Silo.EigenVector(Valley,subband,index);
            if (Silo.EigenVector(Valley,subband,index) < 0)
               EV1PP_2(1:length(Silo.EigenVector(1,subband,:)),1) = -Silo.EigenVector(Valley,subband,:);
            else
               EV1PP_2(1:length(Silo.EigenVector(1,subband,:)),1) =  Silo.EigenVector(Valley,subband,:);
            end
            [max_values index] = max(abs(Silo.EigenVector(Valley,subband+1,lengthOfVec/2:lengthOfVec)));
            index = index+lengthOfVec/2-1;
            Silo.EigenVector(Valley,subband+1,index);
            if (Silo.EigenVector(Valley,subband+1,index) < 0)
                EV2PP_2(1:length(Silo.EigenVector(1,subband+1,:)),1) = -Silo.EigenVector(Valley,subband+1,:);
            else
                EV2PP_2(1:length(Silo.EigenVector(1,subband+1,:)),1) = Silo.EigenVector(Valley,subband+1,:);
            end
            
            Silo.EigenVector(1,subband,:) = EV1PP_1-ScalingFactorL*EV2PP_1;
            Silo.EigenVector(1,subband+1,:) = EV1PP_2-ScalingFactorR*EV2PP_2;
            
        end
    end
end


for Valley=1:1:Sims_Constant.NoOfValleys
  for subband=1:Sims_Constant.NoOfEigEnePerValley
      integ=0;
      for i=1:Mesh.Number_Mesh_point
          integ=integ+Silo.EigenVector(Valley,subband,i)*Silo.EigenVector(Valley,subband,i)*Mesh_cons.Spatial_distance;
      end
      Silo.EigenVector(Valley,subband,:)=Silo.EigenVector(Valley,subband,:)./sqrt(integ);
  end
end 
 
end
