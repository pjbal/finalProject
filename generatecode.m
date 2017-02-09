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
    codeLines = cell(nProcessLines,1);
    
    %counter for the number current process being turned into matlab code
    processLine = 1;
    
    %% main loop
    %loop through all process lines
    while(processLine <= nProcessLines)
        %charcter counter to indicate place in process line
        characterCount = 1;
        
        newCodeLine = '';
        useParametersAsTarget = false;
        
        %check if the assignment target is specified
        if(translationprocess{processLine}(1) == '[')
            
            newCodeLine='[';
            
            endofAssignmentTarget = strfind(translationprocess{processLine}, ']');
            
            %check if there is a closing bracket for the assignment target
            if (isempty(endofAssignmentTarget))
               error('matlab:FormatTransaltion:generatecode:syntax','syntax: No closing bracket for the assignment target, Line: %d\n\t %s', processLine, translationprocess{processLine});
            elseif (endofAssignmentTarget < 3) %if there is no target between the braces []
               error('matlab:FormatTransaltion:generatecode:syntax','syntax: No assignment target indicated between []: %d\n\t %s', processLine, translationprocess{processLine});
            end            
            
            %add start of code line
            newCodeLine = [newCodeLine  'dataOut(:,['];
                
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
                   newCodeLine = [newCodeLine ']), dataOut(:,['];
               elseif (translationprocess{processLine}(characterCount)==']')
                   newCodeLine = [newCodeLine '])] = '];
               elseif (translationprocess{processLine}(characterCount)~=' ')
                   error('matlab:FormatTransaltion:generatecode:syntax','syntax: unknown character- %c, Line: %d\n\t %s', translationprocess{processLine}(characterCount), processLine, translationprocess{processLine});
               end
            end
            
        else
            %set flag to place the input parameters as the target for the
            %expesion
            useParametersAsTarget = true;
            
        end
        
        %loop through process instruction to find start of function name
        while not(isletter(translationprocess{processLine}(characterCount)))         
            %carry on checking from next character
            characterCount = characterCount + 1;
            %check if the end of the string has been reached
            if (characterCount>length(translationprocess{processLine}))
               error('matlab:FormatTransaltion:generatecode:syntax','syntax: No parameter bracket found  ''('', Line: %d\n\t %s', processLine, translationprocess{processLine});
            end
        end 
        
        %record at what character the function name starts
        startFunctionName = characterCount;
      
        %loop through process instruction to find end of function name
        while ((translationprocess{processLine}(characterCount)~='(')&&(translationprocess{processLine}(characterCount)~=' '))   
            %carry on checking from next character
            characterCount = characterCount + 1;
            %check if the end of the string has been reached
            if (characterCount>length(translationprocess{processLine}))
               error('matlab:FormatTransaltion:generatecode:syntax','syntax: No parameter bracket found  ''('', Line: %d\n\t %s', processLine, translationprocess{processLine});
            end
        end

        %store the function name
        functionName = translationprocess{processLine}(startFunctionName : (characterCount-1));
        
        %add function name to code line being formed
        newCodeLine = [newCodeLine functionName];
        
        %find the end of the parameter list
        endParameterList = rangestrfind(translationprocess{processLine}, ')', characterCount, length(translationprocess{processLine}) );
            
        %check if there is a closing bracket for the parameters
        if (isempty(endParameterList))
           error('matlab:FormatTransaltion:generatecode:syntax','syntax: No closing bracket for the assignment target '')'', Line: %d\n\t %s', processLine, translationprocess{processLine});
        elseif (endParameterList < 3) %if there is no target between the braces []
           error('matlab:FormatTransaltion:generatecode:syntax','syntax: No assignment target indicated between ''()'': %d\n\t %s', processLine, translationprocess{processLine});
        end    
        
        codeOutParameterStart = length(newCodeLine);
        
        %add start of code line
        newCodeLine = [newCodeLine  '(dataIn(:,['];

        while((characterCount+1)<endParameterList)

           %carry on checking from next character
           characterCount = characterCount + 1;

           %store the start of the parameter
           targetStart = characterCount;

            %loop till end of parameter
           while((translationprocess{processLine}(characterCount)~=' ')&&(translationprocess{processLine}(characterCount)~=',')&& (translationprocess{processLine}(characterCount)~=')'))
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
               newCodeLine = [newCodeLine ']), dataIn(:,['];
           elseif (translationprocess{processLine}(characterCount)==')')
               newCodeLine = [newCodeLine ']))'];
           elseif (translationprocess{processLine}(characterCount)~=' ')
               error('matlab:FormatTransaltion:generatecode:syntax','syntax: unknown character- %c, Line: %d\n\t %s', translationprocess{processLine}(characterCount), processLine, translationprocess{processLine});
           end
        end
        
        if (useParametersAsTarget)            
           parameters = newCodeLine(codeOutParameterStart+2:end -1);
           newCodeLine =['[' parameters '] = ' newCodeLine];
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
    
    characterPositions = strfind(stringToSearch(lowerBound:upperBound), pattern)+(lowerBound-1);

end
