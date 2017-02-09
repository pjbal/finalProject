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
    %read and sort header
    
    readFileID = fopen(inputFileName); %%add error checks
    
    %check if file has opened correctly
    if(readFileID<0)
        error('matlab:NSItoFEKO1:readandsortheader','unable to open file');
    end
    
    headerLines = NSIReadHeader1(readFileID);
    
    fclose(readFileID); %%add error checks
    
    sizeHeaderLines = size(headerLines);%recod number of header lines for ofset of data read
      
    headerArgs = SortNSIHead1(headerLines); %removed for testing
    
    noHeaderArgs = size(headerArgs);
    argSelector = 1; %counter to go though arguments
    noRowsData = 0;
    noColumns = 0;
    
    while (((noRowsData==0) || (noColumns==0)) && (argSelector <= noHeaderArgs(1)))
        switch char(headerArgs(argSelector,1))
            case['HEADERSTART' char(13) char(10)]%%find header argument
                noRowsData = str2double(headerArgs{argSelector,2}) * str2double(headerArgs{argSelector,3});
                
            case['COLDEF' char(13) char(10)]%find field of column headers
                noColumns = 0;%start of with minimum of one column
                
                %loop through columns of the cell until reach end of cells or empty cell found indicating no more column names
                while(noColumns+2<=noHeaderArgs)
                    if(isempty(headerArgs(argSelector,noColumns+2)))
                        break;
                    end
                    noColumns = noColumns +1;
                end                 
        end
        
        argSelector=argSelector +1; 
    end
    
    outputPrecision = '%+2.6E';
    OutputDelimiter = ' ';
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %read in data
    
    dataRead = readdata(inputFileName, '', noRowsData, sizeHeaderLines(2), noColumns); %read in block of data in the file
    
    %------------------------------------------------------------------------------------------------
      
    %get the the information on the translation needed
    translationStructure = readtranslationfile(inputFormat, outputFormat);
    
    %generate matlab instructions to be caried out to complete conversion
    translationCode = generatecode(1, translationStructure.Process);
    
    %carry out generated matlab instruction to carry out the actual
    %conversion and returned the output data
    dataWrite = evalCodeLines(translationCode,dataRead,1);
    
    %write output data to a file
    appendmatrix2file(outputFileName, dataWrite, OutputDelimiter, outputPrecision);
    
%%
%     %------------------------------------------------------------------------------------------------
%     %Get format specifics
%     
%     inputFormDet = readFormDef(inputFormat);
%     
%     
%     
%     sizeinputFormDet = size(inputFormDet);
%     
%     %loop through format definition argumants
%     for i = 1:sizeinputFormDet(2)
%         
%        tempFormArg = inputFormDet{1,i}
%        if(strcmp(tempFormArg,'Extenson'))
%            fileExtension = tempFormArg(1,2);
%            
%        elseif (strcmp(tempFormArg, 'includePreHeader'))       
%            includePreHeader = tempFormArg(1,2);
%                
%        elseif (strcmp(tempFormArg, 'HeaderBlockIndicator'))      
%            inputheaderBlockIndicator = tempFormArg(1,2);
%                
%        elseif(strcmp(tempFormArg, 'CommentIndicator'))
%            inputHeaderBlockIndicator = tempFormArg(1,2);
%                
%        elseif(strcmp(tempFormArg, 'solutionBlockIndicator'))            
%            SolutionBlockIndicator = tempFormArg(1,2);
%                
%        elseif (strcmp(tempFormArg, 'fileExtension'))       
%            inputfileExtension = tempFormArg(1,2);
%                
%        elseif(strcmp(tempFormArg, 'Deliminator'))        
%            inputDelimiter = tempFormArg(1,2);
%                
%        elseif (strcmp(tempFormArg, 'HeaderBlockArguments'))      
%            %%%%%to change
%            HeaderBlockArguments = {'File Type', ''; 'File Format', ''; 'Source ', ''; 'Date', ''};
%                
%       elseif (strcmp(tempFormArg, 'solutionBlockArguments'))      
%            %%%%%to change
%            solutionBlockArguments = {'Request Name', ''; 'Frequency', ''; 'Origin', '';...
%     'u-Vector', ''; 'v-Vector', ''; 'No. of [Phi]Samples', ''; 'No. of [Theta]Samples', '';...
%     'Result Type', ''; 'Incident Wave Direction', ''; 'No. of Header Lines', ''};
%     
%        elseif (strcmp(tempFormArg, 'newColumnHeaders'))      
%            %%%%%to change
%            %%newColumnHeaders = {};
%            newColumnHeaders = ['#   Theta   Phi Re(Etheta)  Im(Etheta)  Re(Ephi)    Im(Ephi)'];
%            
%        else
%            %%unrecognised argument
%                
%        end
%        
%     end  
%        
%     %------------------------------------------------------------------------------------------------
%     
%     %------------------------------------------------------------------------------------------------
%     %read and sort header
%     
%     readFileID = fopen(inputFileName); %%add error checks
%     
%     if (readFileID<0)
%        error('QM:FormatTranslation:FileError', 'Unable to open input data file') 
%     end
    
    

end