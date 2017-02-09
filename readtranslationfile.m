function [ translationStruct ] = readtranslationfile( inputFormat, outputFormat )
% readtranslationfile       Read instruction from translation file
%   [ translationStruct ] = readtranslationfile( inputFormatName, outputFormatName )
%
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    06/02/2017 
%   File Name:      readtranslationfile
%   Project Name:   
%   
%   Description: 
%    Function to read instructions from a translation file (*.trs) on how
%    translate between two frormats
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:
%

    translationStruct = readdatatransformfile([inputFormat '_' outputFormat '.trs']);
    
  
    
    
    
end
   



