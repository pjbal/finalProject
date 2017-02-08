function formatDefinitionStruct = readFormDef( formatName )
%   readFormDef - Function to read in format definition from *.fmt files
%   
%   [formatDefinitionStruct] = readFormDef( formatName )
%
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    01/02/2017 
%   File Name:      readFormDef
%   Project Name:   
%   
%   Description: 
%     Function to read in format definition from *.fmt files
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
%   Revision 0.11 - Main code replaced with call to more efficiant
%                       readDataTransformFile 08/02/2017
% 
%   Additional Comments:
%
    %read file and return structure found
    formatDefinitionStruct = readDataTransformFile([formatName '.fmt']);

end

%old Program

%      sizeformatDef =[0,1];
%         
%      fileID = fopen([formatName '.fmt']); %open format descriptor file
%      
%      if (fileID<0)
%          error('QM:FormatTranslation:FileError', 'Unable to find format information')
%      else
%          while(~feof(fileID))
% 
%              %read line from format def file
%              tempFileLine = fgets(fileID);
% 
%              %check if it is a blanc line, if so jump to start of while
%              if (tempFileLine == -1)
%                  continue;
%              end
%              
%              %check if it is an instruction line
%              if ((tempFileLine(1)~='#')||(tempFileLine(2)~='#'))
%                  continue;
%              end
%              
%              charCounter = 1; %counter to select character in string read
% 
%              %find end of key in line
%              while((tempFileLine(charCounter)~=':') && (tempFileLine(charCounter)~='[') && (tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10)))
%                  charCounter = charCounter +1;
%              end
% 
%              %check if it reached the end the line without reaching a ':' or
%              %'{' indicator- if so jump to next line
%              if ((tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10)))
% 
%                      %store argument key string
%                      argKey = tempFileLine(3: (charCounter-1));
% 
%                      if(tempFileLine(charCounter)==':')
% 
% 
%                          argCharStart = charCounter +2;%start of arg value
% 
%                          %find end of key in line
%                          while(((tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10))))
%                              charCounter = charCounter +1;
%                          end
% 
%                          %store argument value
%                          argVal = tempFileLine(argCharStart:(charCounter-1));
% 
%                          %store argument read in to cell to be returned
%                          sizeformatDef(1) = sizeformatDef(1) +1;
%                          formatDef{sizeformatDef(1)} = {argKey argVal};
%                          
%                          
%                      else
%                          
%                         %create cell for storing multi argument value list
%                         sizeMultArg = [1,0];
%                         MultArg = {};
%                         
%                         %store argument key ready to be stored as first
%                         %element in cell
%                         tempFileLine = argKey;
%                          
%                         
%                         
%                                                                      
%                         while(tempFileLine(1)~=']')
%                             
%                             if (tempFileLine(1)~='*')
%                             
%                                  %add new argument value to cell
%                                  sizeMultArg(2) = sizeMultArg(2) + 1;
%                                  MultArg{sizeMultArg(1), sizeMultArg(2)} = {tempFileLine};
%                              
%                             else
%                                 
%                                 charCounter = 2; %counter to select character in string read starting on first char after '*'
% 
%                                  %find end of key in line
%                                  while((tempFileLine(charCounter)~=':') && (tempFileLine(charCounter)~='[') && (tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10)))
%                                      charCounter = charCounter +1;
%                                  end
% 
%                                  %check if it reached the end the line without reaching a ':'
%                                  if ((tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10)))
%                                     
%                                      %store addition key string
%                                      addArgKey = tempFileLine(2: (charCounter-1));
%                                     
%                                      argCharStart = charCounter +2;%start of arg value
% 
%                                      %find end of key in line
%                                      while(((tempFileLine(charCounter)~=char(13)) && (tempFileLine(charCounter)~=char(10))))
%                                          charCounter = charCounter +1;
%                                      end
% 
%                                      %store argument value
%                                      addArgVal = tempFileLine(argCharStart:(charCounter-1));
%                                 
%                                      MultArg{sizeMultArg(1), sizeMultArg(2)} = {MultArg{sizeMultArg(1), sizeMultArg(2)}; {addArgKey addArgVal}};
%                                     
%                                  end
%                                 
%                             end
%                             
%                             %read line from format def file
%                              tempFileLine = fgets(fileID);
% 
%                              %check if it is a blanc line, if so jump to start of while
%                              if (tempFileLine == -1)
%                                  continue;
%                              end
% 
%                              %check if it is an instruction line ??????/ could
%                              %be merged with previouse check
%                              if ((tempFileLine(1)=='%'))
%                                  continue;
%                              end
%                              
%                              
%                             
%                         end
%                         
%                         %store argument read in to cell to be returned
%                         sizeformatDef(1) = sizeformatDef(1) +1;
%                         formatDef{sizeformatDef(1)} = MultArg;
% 
%                      end
%              end
%          end
% 
%          fclose(fileID);
%      end
%     
% 
% end

