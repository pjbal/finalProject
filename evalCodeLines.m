function [ dataOut ] = evalCodeLines( codeLines, dataIn, headerIn )
%
%  Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    09/02/2017 
%   File Name:      evalCodeLines
%   Project Name:   
%   
%   Description: 
%    Function to run code lines that carry out translation on data in
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:

    %loop through all instructions passed to the fucntion in 'codeLines'
    for i = 1: length(codeLines)
        disp(codeLines{i})
       
       eval([codeLines{i} ';']);
    end


end

