function [charCounter] = findendofkey(characterArray, keyTerminators)
%
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    08/02/2017 
%   File Name:      findendofkey
%   Project Name:   
%   
%   Description: 
%     Function to find the end of key in a string. first instence and of
%     keyTerminators apears in a string.
%
%      returns -1 if no end of key found
%
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created 
%   Additional Comments:

    %counter to select character in string
    charCounter = 1;
    
    lenCharacterArray =  length(characterArray);
    
    while(charCounter <= lenCharacterArray)
         for i = keyTerminators
             %if character i from keyTerminators is character in
             %characterArray selected then reurn this position
             if(characterArray(charCounter)==i)
                return;
             end
             
         end
         %select next character to be checked
         charCounter = charCounter +1;
    end
     
     %return -1 if no end of key has been found
     charCounter = -1;
     
end

