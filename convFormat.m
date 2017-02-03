function dataWrite = convFormat( inputFileName, inputFormat, outputFileName, outputFormat )
%
%  Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    02/02/2017 
%   File Name:      convFormat
%   Project Name:   
%   
%   Description: 
%     Function to convert between two file formats

%     Arguments:
%         inputFileName- Name of the file to be converted e.g. 'FekoData.ffe'
%         inputFormat- Name of format to be converted from, (use specific name used by this program) e.g. 'FEKO3'
%         outputFileName- Name of the file to write the converted data to 
%         outputFormat- Name of format to be converted to, (use specific name used by this program) e.g. 'NSI3'
% 
%     Supported Formats:
%     FEKO3
%     NSI
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:
%

    %------------------------------------------------------------------------------------------------
    %Get format specifics
    
    inputFormDet = readFormDef(inputFormat);
    
    
    
    sizeinputFormDet = size(inputFormDet);
    
    %loop through format definition argumants
    for i = 1:sizeinputFormDet(2)
        
       tempFormArg = inputFormDet{1,i}
       if(strcmp(tempFormArg,'Extenson'))
           fileExtension = tempFormArg(1,2);
           
       elseif (strcmp(tempFormArg, 'includePreHeader'))       
           includePreHeader = tempFormArg(1,2);
               
       elseif (strcmp(tempFormArg, 'HeaderBlockIndicator'))      
           inputheaderBlockIndicator = tempFormArg(1,2);
               
       elseif(strcmp(tempFormArg, 'CommentIndicator'))
           inputHeaderBlockIndicator = tempFormArg(1,2);
               
       elseif(strcmp(tempFormArg, 'solutionBlockIndicator'))            
           SolutionBlockIndicator = tempFormArg(1,2);
               
       elseif (strcmp(tempFormArg, 'fileExtension'))       
           inputfileExtension = tempFormArg(1,2);
               
       elseif(strcmp(tempFormArg, 'Deliminator'))        
           inputDelimiter = tempFormArg(1,2);
               
       elseif (strcmp(tempFormArg, 'HeaderBlockArguments'))      
           %%%%%to change
           HeaderBlockArguments = {'File Type', ''; 'File Format', ''; 'Source ', ''; 'Date', ''};
               
      elseif (strcmp(tempFormArg, 'solutionBlockArguments'))      
           %%%%%to change
           solutionBlockArguments = {'Request Name', ''; 'Frequency', ''; 'Origin', '';...
    'u-Vector', ''; 'v-Vector', ''; 'No. of [Phi]Samples', ''; 'No. of [Theta]Samples', '';...
    'Result Type', ''; 'Incident Wave Direction', ''; 'No. of Header Lines', ''};
    
       elseif (strcmp(tempFormArg, 'newColumnHeaders'))      
           %%%%%to change
           %%newColumnHeaders = {};
           newColumnHeaders = ['#   Theta   Phi Re(Etheta)  Im(Etheta)  Re(Ephi)    Im(Ephi)'];
           
       else
           %%unrecognised argument
               
       end
       
    end  
       
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %read and sort header
    
    readFileID = fopen(inputFileName); %%add error checks
    
    if (readFileID<0)
       error('QM:FormatTranslation:FileError', 'Unable to open input data file') 
    end
    
    

end