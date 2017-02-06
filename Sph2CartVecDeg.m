function [ realComps, imagComp] = Sph2CartVecDeg(magR, angR, magTheta, angTheta, magPhi, angPhi, thetaPhi)
%
%  Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    06/02/2017 
%   File Name:      FEKOtoNSI
%   Project Name:   
%   
%   Description: 
%    Function to convert given columns from spherical vectors to cartesian
%     vectors.
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:
%


    %create complex vector from amplitude and phase
    %R
    sphVec(:, 1) = complexfrompolar(magR, angR);
    %elevation (theta)  
    sphVec(:, 2) = complexfrompolar(magTheta, angTheta);
    %azimuth (phi)
    sphVec(:, 3) = complexfrompolar(magPhi, angPhi);
    

    %carry out conversion from spherical to cartesian
    CartVec(:, 1) = sphVec(:, 1).*sind(thetaPhi(:,1)).*cosd(thetaPhi(:,2)) + sphVec(:, 2).*sind(thetaPhi(:,1)).*sind(thetaPhi(:,2)) + sphVec(:, 3).*cosd(thetaPhi(:,1));
    CartVec(:, 2) = sphVec(:, 1).*cosd(thetaPhi(:,1)).*cosd(thetaPhi(:,2)) + sphVec(:, 2).*cosd(thetaPhi(:,1)).*sind(thetaPhi(:,2)) - sphVec(:, 3).*sind(thetaPhi(:,1));
    CartVec(:, 3) = - sphVec(:, 1).*sind(thetaPhi(:,2)) + sphVec(:, 2).*cosd(thetaPhi(:,2));

    %get real components of complex number
    realComps = real(CartVec);
    
    %get imaginary components of complex number
    imagComp = imag(CartVec);
end

