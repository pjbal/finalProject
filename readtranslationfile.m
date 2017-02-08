function [ translationStruct ] = readtranslationfile( inputFormatName, outputFormatName )
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

    
    %% section 1 
    Define Variable
    
    %create structure to hold parameters read in from file
    translationStruct= struct;


    %define variables used throughout the function
    commentIndicator = '%';  %character used to indicate the start of a  comment in the translation file
    parameterIndicator = '#'; %character used to indicate the start of a parameter
    endKeyIndicators = [':' '{']; %characters used to indicate the end oif the key and start of information
    
    %variable to count lines read from file
    fileLineNumber = 0;
    
    %% Open file and validat
    
    %open translation file which holds instructions on how to transalte
    %data between two formats and their headers
    fileID = fopen([inputFormatName '_' outputFormatName '.trs']);

    %check if file has opened correctly
    if(fileID<0)
        error('matlab:FormatTransaltion:readandsortheader:fileAccess','Unable to open file');
    end
    
    %% Read File
    
    %loop through the entire file untill there are no more lines to read
    while(~feof(fileID))
        %% read a line from teh file and store temporerily for analysis
        tempLineRead = fgetl(fileID);
        fileLineNumber = fileLineNumber + 1;
        
        %check if it is a blanc line or comment, if so jump to start of while
        if (isempty(tempLineRead))
            continue;
        elseif (tempLineRead(1) == commentIndicator)
            continue;
        end
            
        %%
        
        %check if the line starts with a correct character
        if(not(strcmp(tempLineRead(length(parameterIndicator)), parameterIndicator)))
            %give syntax error as start of line not recognised
            error('Matlab:FormatTransaltion:readandsortheader:fileSyntax', 'syntax: Unknown line start, Line: %d', fileLineNumber);                   
        end
        
        %find the end of the key that names the parameter
        keyEnd = findendofkey(tempLineRead, endKeyIndicators);
        
        %chech if end of key was found correctly
        if (keyEnd==-1)
            %syntax error as no end of the key (name of parameter) found
            error('Matlab:FormatTransaltion:readandsortheader:fileSyntax', 'syntax: no end of key found: %d', fileLineNumber);
        end
        
        %store the key that has been found for the parameter
        parameterKey = tempLineRead((length(parameterIndicator)+1):(keyEnd-1));
        
        disp(parameterKey)
       
        
        %%        
        %if the parameter indicator specifies a single line argument
        if (tempLineRead(keyEnd) == endKeyIndicators(1)) 
            %%
            
            clearvars parameterValue;            
            parameterValue  = tempLineRead((keyEnd+2):end);
            lenParameterValue =1;
        
        
          
        else
           %% Read multi value parameter from file
            
              
            
            lenParameterValue = 0;
            clearvars parameterValue;
                       
            %ineligant solution
            %loop till a valid line is read
            while(1)
                %read a line from the file and store temporerily for analysis
                tempLineRead = fgetl(fileID);
                fileLineNumber = fileLineNumber + 1;

                %check if it is a blanc line if so jump to start of while
                if (isempty(tempLineRead))
                    continue;
                %check if it is a comment, if so jump to start of while
                elseif (tempLineRead(1) == commentIndicator)
                    continue;
                end
                
                break;
            end
            
            
            %loop through parameter list until the end of the list is found
            %at '}' indicator / the end of file is found
            while((tempLineRead(1) ~= '}') &&(~feof(fileID)) && not(strcmp(tempLineRead(1),parameterIndicator)))
            
                %increment counter for number of list values found
                lenParameterValue = lenParameterValue + 1;
                parameterValue{lenParameterValue} = tempLineRead;
                
                %read a line from teh file and store temporerily for analysis
                tempLineRead = fgetl(fileID);
                fileLineNumber = fileLineNumber + 1;

                %check if it is a blanc line if so jump to start of while
                if (isempty(tempLineRead))
                    continue;
                %check if it is a comment, if so jump to start of while
                elseif (tempLineRead(1) == commentIndicator)
                    continue;
                end             
                
                
            end        
            
            
            %check that valid end of list indicator was found
            if (tempLineRead(1) ~= '}')
                 error('Matlab:FormatTransaltion:readandsortheader:fileSyntax', 'syntax: no end of instruction list found ''}'' : %d', fileLineNumber);
            end           
            
            
        end
        %%
        
        %store parameter values found
        translationStruct.(parameterKey) = parameterValue;
        
        
    end
        
    %% close connection to *.trs translation file
    fclose(fileID);
end



