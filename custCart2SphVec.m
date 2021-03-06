

function [magnitude, phase] = custCart2SphVec( coordVec, thetaPhi )
% 
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    19/01/2016 
%   File Name:      custCart2SphVec
%   Project Name:   
%   
%   Description: 
%     Function to convert given columns from cartesian vectors to spherical
%     vectors.
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created 
%   Revision 0.02 - name changed from 'pol2cartDeg' to 'custCart2SphVec' 
%                 - transformation from seperate magnitude and phase colums to a single
%                 complex vector 
%                 - vector passed to matlab function cart2sphvec
%                 - return variables added magTheta, angTheta, magPhi, angPhi
%                 with use of abs() and angle()
%   the output of 
%   Additional Comments:   

    
    
    
%-------------------------------------------------------------------------
% not working as phi inputs to cart2sphvec must be +-90
% 
%     %create complex vector using provided magnitudes and phases for x, y
%     %and z components and transpose to get into correct format of three
%     %rows as
%     coordVec = transpose(complex(magi, angi));
%
%     %carry out conversion from cartesian to spherical
%     for i = 1 : size(thetaPhi)%loop through data elements
%         sphVec = cart2sphvec(coordVec(:, i), thetaPhi(i, 1), thetaPhi(i, 2));
%     end
%
%      %correct to right orientation of three columns by samples in rows    
%      sphVec = transpose(sphVec);
%-------------------------------------------------------------------------
    
 

%     %create complex vector using provided magnitudes and phases for x, y
%     %and z components  
%     coordVec = complex(realComps, imagComp);

    %carry out conversion from cartesian to spherical
    sphVec(:, 1) = coordVec(:, 1).*sind(thetaPhi(:,1)).*cosd(thetaPhi(:,2)) + coordVec(:, 2).*sind(thetaPhi(:,1)).*sind(thetaPhi(:,2)) + coordVec(:, 3).*cosd(thetaPhi(:,1));
    sphVec(:, 2) = coordVec(:, 1).*cosd(thetaPhi(:,1)).*cosd(thetaPhi(:,2)) + coordVec(:, 2).*cosd(thetaPhi(:,1)).*sind(thetaPhi(:,2)) - coordVec(:, 3).*sind(thetaPhi(:,1));
    sphVec(:, 3) = - coordVec(:, 1).*sind(thetaPhi(:,2)) + coordVec(:, 2).*cosd(thetaPhi(:,2));

    
    %calculte the magnitude and angle of vectors for: 
    [magnitude, phase] = Complex2PolarDeg(sphVec);
    
    magnitude = magnitude(:, [2 3]);
    
    phase = phase(:, [2 3]);
    
       
end

