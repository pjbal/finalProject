function [ complexVar ] = complexfrompolardeg( amplitude, phase )
%
%  Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    06/02/2017 
%   File Name:      ComplexFromPolar
%   Project Name:   
%   
%   Description: 
%    Function to combine magnitude and phase into a complex variable.
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:
%
    %store as complex number = r*e^(i*phi)
    complexVar = amplitude.*(cosd(phase)+1i*sind(phase));


end

