function [ codeLines ] = generatecode( inputHeader, translationprocess )
% readDataTransformFile       Read instruction from translation file
%   [ translationStruct ] = readDataTransformFile( inputData, inputHeader, translationprocess )
%
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    08/02/2017 
%   File Name:      translationprocess
%   Project Name:   
%   
%   Description: 
%    Function to take instructions from a file and turn them into matlab
%    code
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:
%

    %% Create variables
    %find the lines of code that will need to be caried out
    nProcessLines = length(translationprocess);
    
    %creat cell to hold the lines of code
    codeLines = cell(nProcessLines);
    
    %counter for the number current process being turned into matlab code
    processLine = 1;
    
    %% main loop
    %loop through all process lines
    while(processLine <= nProcessLines)
        %charcter counter to indicate place in process line
        characterCount = 1;
        
        newCodeLine='[';
        
        %check if the assignment target is specified
        if(translationprocess{processLine}(1) == '[')
            
            endofAssignmentTarget = strfind(translationprocess{processLine}, ']');
            
            %check if there is a closing bracket for the assignment target
            if (isempty(endofAssignmentTarget))
               error('matlab:FormatTransaltion:translationprocess:syntax','syntax: No closing bracket for the assignment target, Line: %d\n\t %s', processLine, translationprocess{processLine});
            elseif (endofAssignmentTarget < 3) %if there is no target between the braces []
               error('matlab:FormatTransaltion:translationprocess:syntax','syntax: No assignment target indicated between []: %d\n\t %s', processLine, translationprocess{processLine});
            end
            
            %find the commas that seperate the that split the targets, plus
            %add the first target starting at 2
%             startOfTargets = [2 rangestrfind(translationprocess{processLine},',',2, endofAssignmentTarget)];
%              
%             %loop through assignment targets
%             for targetCounter = 1 : length(startOfTargets)
%                 
%                 spaceLocations = [(startOfTargets(targetCounter)+1 ) rangestrfind(translationprocess{processLine},' ',startOfTargets(targetCounter), (startOfTargets(targetCounter+1))) (startOfTargets(targetCounter+1))];
%                 
%                 targetsFound = cell(length(spaceLocations));
%                 
%                 for splitCounter = 1: (length(spaceLocations)-1)
%                     targetsFound(splitCounter) = translationprocess{processLine}(spaceLocations(splitCounter):spaceLocations(splitCounter+1));
%                 end
%                 
%             end

            newCodeLine = [newCodeLine  'data(:,'];
%                
            while(characterCount<endofAssignmentTarget)
                
               %carry on checking from next character
               characterCount = characterCount + 1;
                
               targetStart = characterCount;
               
               
               
               while((translationprocess{processLine}(characterCount)~=' ')&&(translationprocess{processLine}(characterCount)~=',')&& (translationprocess{processLine}(characterCount)~=']'))
                   characterCount = characterCount +1;                   
               end            
               
               
               %store target found
               tempTarget = translationprocess{processLine}(targetStart: characterCount-1);
               if(isempty(tempTarget))
                   continue;
               elseif(all(isstrprop(tempTarget, 'digit')))
                    newCodeLine = [newCodeLine ' ' tempTarget];
               else 
                   error('NOT Implemented as of yet-no non-numerical input, see later version')
               end
               
               if (translationprocess{processLine}(characterCount)==',')
                   newCodeLine = [newCodeLine '), data(:,'];
               elseif (translationprocess{processLine}(characterCount)==']')
                   newCodeLine = [newCodeLine ')] = '];
               elseif (translationprocess{processLine}(characterCount)~=' ')
                   error('matlab:FormatTransaltion:translationprocess:syntax','syntax: unknown character- %c, Line: %d\n\t %s', translationprocess{processLine}(characterCount), processLine, translationprocess{processLine});
               end
            end
            
        else
            error('no assignment targer not supported in this version, see later version')
        end
        
        %store line of code just formulated in cell to be returned
        codeLines{processLine} = newCodeLine;
        
        %select next line to be formulated
        processLine = processLine+1;
        
        
        
    end

end

function characterPositions = rangestrfind(stringToSearch, pattern, lowerBound, upperBound)
    %function to search a string for a pattern between two points provided
    %in the string
    
    characterPositions = strfind(stringToSearch(lowerBound:upperBound), pattern)+(lowerBound-1)

end
