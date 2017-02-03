function [ output_args ] = readFileHeader( fileID, CommentIndicator, keyValueSeperator )
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
    selectHeaderInfo = 1;
    headerInfo = {};
    
    
    while(feof(fileID))%loop through file for header lines
        %read in header line
        newLine = fgets(fileID);
        
         %check if it is a blanc line, if so jump to start of while
         if ((newLine == -1)||(tempFileLine(1) == CommentIndicator))
             continue;
         end
         
         %check if the line is a comment
         if (newLine(1) == CommentIndicator);
             continue;
         end
         
         %check if the line starts with a block indicator and act acoringly
         if ((strcmp(headerBlockIndicator, tempFileLine(1:size(headerBlockIndicator)))&&(~isempty(headerBlockIndicator))))
             selectHeaderInfo = 1; %select designated cell for header block arguments
             
         elseif ((strcmp(solutionBlockIndicator, tempFileLine(1:size(solutionBlockIndicator)))&&(~isempty(solutionBlockIndicator))))
             selectHeaderInfo = noSolutionBlock + 1; %select cell for current solution block           
             
         else
             error('QM:FileConversion:HeaderRead', 'Unable to read line of header file');
             %Probably line of data- corect code to hadle no indicator of
             %start of data%%%%%%%%%%%%%%%%%%%
         end
         
         
         
         %find end of key in line at separator between or end of line in
         %which case take whole line as key
         charCounter = 0;
         while(((tempFileLine(charCounter)~=keyValueSeperator) || isempty(keyValueSeperator)) && (tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10)))
             charCounter = charCounter +1;
         end
         
         headerInfo{} = newLine[(size(headerBlockIndicator)+1):charCounter];
            
             
        
    end %end of main loop through header lines


end

