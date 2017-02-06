function [ amplitude, phase ] = Complex2PolarDeg( complexVar )
%
%  Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    06/02/2017 
%   File Name:      Complex2PolarDeg
%   Project Name:   
%   
%   Description: 
%    Function to split a complex variable into it's magnitude and phase.
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:

    %elevation (theta)
    amplitude=abs(complexVar);
    %angTheta2=angle(sphVec(:,2)); %in radians so dosen't work
    phase= atan2d(imag(complexVar), real(complexVar));


end

