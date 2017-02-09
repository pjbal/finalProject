function [ output_args ] = readFileHeader( fileID, formatDefStruct )
% 
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    17/01/2017 
%   File Name:      readFileHeader
%   Project Name:   
%   
%   Description: 
%     Function to read in the header of a file using the information from
%     format specifier file to uderstand format
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created 
%   Additional Comments:  

    %cell array to store arguments
    sizeHeaderInfo = [0 0];%store size of each section of header of header info, header block followed by any number of
    noSolutionBlock = 0; %store the number of solution blocks found
    noHeaderSections = 1;
    headerInfo = {};
    
    %create structure to hold the header block arguments
    headerBlockStruct = struct;
    
    %create output cell structre that can grow into more rows if more
    %headers needed
    output_args = cell(1, 2);
    
    output_args{1,1} = struct
    
    
    while(feof(fileID))%loop through file for header lines
        %read in header line
        tempReadLine = fgetl(fileID);
        
        %check if line is blank, skip if so
        if (isempty(tempReadLine))
            continue;
        elseif (newLine == - 1) %check if line is blank, skip if so
            continue
            
            %checif line is a comment, skip if so
        elseif ((isfield(formatDefStruct, 'CommentIndicator'))&& (tempReadLine(1) == formatDefStruct.CommentIndicator))
            continue
        end        
         
         %check if the line starts with a block indicator and act acoringly
         if ((isfield(headerBlockIndicator, 'HeaderBlockIndicator'))&& isempty(formatDefStruct.headerBlockIndicator) &&(strcmp(headerBlockIndicator, tempReadLine(1:size(formatDefStruct.headerBlockIndicator)))))
             selectHeaderInfo = 1; %select designated cell for header block arguments
             sizeOfIndicator = length(formatDefStruct.headerBlockIndicator);
             
         elseif ((strcmp(formatDefStruct.solutionBlockIndicator, tempFileLine(1:length(formatDefStruct.solutionBlockIndicator)))&&(~isempty(formatDefStruct.solutionBlockIndicator))))
             noHeaderSections = noSolutionBlock + 1; %select cell for current solution block           
             sizeOfIndicator = length(formatDefStruct.solutionBlockIndicator);
         else
             error('QM:FileConversion:HeaderRead', 'Unable to read line of header file');
             %Probably line of data- corect code to hadle no indicator of
             %start of data%%%%%%%%%%%%%%%%%%%
         end
         
         
         
         %find end of key in line at separator between or end of line in
         %which case take whole line as key
%          charCounter = sizeOfIndicator;
%          while(((tempFileLine(charCounter)~=keyValueSeperator) || isempty(keyValueSeperator)) && (tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10)))
%              charCounter = charCounter +1;
%          end
         
         if (isfield(formatDefStruct,keyValueSeperator))
             endOfKey = findendofkey(tempReadLine, formatDefStruct.keyValueSeperator);
             
             endOfKey = endOfKey -1;
             
             if (isfield(formatDefStruct,keyValueSameLine)                 
             
                 charCounter = endOfKey + 1
                 
                 while(isspace(tempReadLine(charCounter)))
                    charCounter = charCounter +1;
                 end
                 
                 tempArgKey = tempReadLine(charCounter:end);
         
             end
             
         else
             endOfKey = length(tempReadLine);
         end
         
         tempArgKey = tempReadLine((sizeOfIndicator+1):endOfKey);
         
         headerInfo{noHeaderSections}(tempArgKey) = tempArgValue;
            
             
        
    end %end of main loop through header lines


end

