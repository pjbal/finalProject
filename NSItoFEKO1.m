%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    17/01/2016 
  File Name:      NSItoFEKO1
  Project Name:   
  
  Description: 
    Function to convert between NSI and FEKO 

  Dependencies: 

  Revision: 
  Revision 0.01 - File Created

  Additional Comments:
%}
function dataWrite = NSItoFEKO1( inputFileName, outputFileName)
    %------------------------------------------------------------------------------------------------
    %General information
    originalFormat = 'NSI';
    newFormat = 'FEKO';
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Information about format
    headerBlockIndicator = '##';
    commentIndicator = '**';  
    solutionBlockIndicator = '#';
    fileExtension = '.ffe';
    OutputDelimiter = ' ';
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %read and sort header
    
    readFileID = fopen(inputFileName); %%add error checks
    
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
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %read in data
    
    dataRead = NSIReadData(inputFileName, noRowsData, sizeHeaderLines(2), noColumns); %read in block of data in the file
    
    %------------------------------------------------------------------------------------------------
    
    
    %------------------------------------------------------------------------------------------------
    %carry out necessary data conversions
    magColm = [3, 5, 7];
    angColm = [4, 6, 8];
    thetPhiColm = [1, 2];
    
    %convert db columns to degreas
    dataRead = dBColumn2Deg(dataRead, magColm);%change to avoide passing whole of data!!!!!!!!
    
    
    %convert from polar to rectangualr complex format given a DB
    %convert from polar form to rectangualar form
    %real compomponents
    realComp = dataRead(:,magColm) .* cosd(dataRead(:,angColm));
    
    %imaginary component
    imagComp = dataRead(:,magColm) .* sind(dataRead(:,angColm));
    
    
    
    %convert from cartesian vector form to spheical vector form
    [magTheta, angTheta, magPhi, angPhi]= custCart2SphVec( realComp, imagComp, dataRead(:,thetPhiColm));
        
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %prepare output matrix  
    
    dataWrite = [dataRead(:,thetPhiColm) magTheta angTheta magPhi angPhi]; 
    
   dataWrite = double(dataWrite);
   
   
   
   
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Prepare header
    
    
    HeaderBlockArguments = {'File Type', ''; 'File Format', ''; 'Source ', ''; 'Date', ''}; 
    sizeHeaderBlockArguments = size(HeaderBlockArguments);
        
    solutionBlockArguments = {'Request Name', ''; 'Frequency', ''; 'Origin', '';...
        'u-Vector', ''; 'v-Vector', ''; 'No. of [Phi]Samples', ''; 'No. of [Theta]Samples', '';...
        'Result Type', ''; 'Incident Wave Direction', ''; 'No. of Header Lines', ''};
    sizeSolutionBlockArguments = size(solutionBlockArguments);
    
    HeaderBlockArguments{1,2} = 'Far field';
    HeaderBlockArguments{1,2} = '3';
    
    for i = 1 : noHeaderArgs(1)
        switch char(headerArgs(i,1))
            case ['FREQUENCY (MHz)' char(13) char(10)]
                solutionBlockArguments(2,2) = headerArgs{i,2};
                
            case ['HEADERSTART' char(13) char(10)]
                solutionBlockArguments(7,2) = headerArgs{i,2};
                solutionBlockArguments(6,2) = headerArgs{i,3};
                
        end        
                       
    end
    
        
    sizeNewHeader = [0, 1]; %matrix to hold size of new header
    newHeader = {}; %cells to hold arguements of new header  
    
    
    for k = 1 : sizeHeaderBlockArguments(1)
        if (not(strcmp(HeaderBlockArguments(k,2), '')))
            sizeNewHeader(1) = sizeNewHeader(1) + 1;
            newHeader{sizeNewHeader(1)} = [headerBlockIndicator char(HeaderBlockArguments(k,1)) ': ' char(HeaderBlockArguments(k,2))];
            
        end
    end
    
    %add empty lines to header to break up
     sizeNewHeader(1) = sizeNewHeader(1) + 1;
     newHeader{sizeNewHeader(1),1} = [char(13) char(10)]; %add new line characters to next cell of header
    
     
    sizeCommentHeaderLines = [0,1];
    
    
    commentHeaderLines{1,1} = [commentIndicator 'File transalted from origional format- ' originalFormat ', to- ' newFormat '\r\n'];
    commentHeaderLines{2,1} = [commentIndicator 'Origional Header:\r\n'];
    
    sizeCommentHeaderLines(1) = sizeCommentHeaderLines(1) +2;
    
    for l = 1 : sizeHeaderLines(2)
    
        sizeCommentHeaderLines(1) = sizeCommentHeaderLines(1) + 1;
        commentHeaderLines{sizeCommentHeaderLines(1),1} = [commentIndicator char(headerLines(1,l))];
        
    end
    
    sizeNewHeader(1) = sizeNewHeader(1) + sizeCommentHeaderLines(1);
    
    newHeader = [newHeader; commentHeaderLines];
    
    %add empty lines to header to break up
    sizeNewHeader(1) = sizeNewHeader(1) + 1;
    newHeader{sizeNewHeader(1),1} = [char(13) char(10)];
    
    
    for k = 1 : sizeSolutionBlockArguments(1)
        if (not(strcmp(solutionBlockArguments(k,2), '')))
            sizeNewHeader(1) = sizeNewHeader(1) + 1;
            newHeader{sizeNewHeader(1)} = [solutionBlockIndicator char(solutionBlockArguments(k,1)) ': ' char(solutionBlockArguments(k,2))];
            
        end
    end  
    
    
    
    sizeNewHeader(1) = sizeNewHeader(1) + 1;
    newHeader{sizeNewHeader(1)} = ['#   Theta   Phi Re(Etheta)  Im(Etheta)  Re(Ephi)    Im(Ephi)'];

    
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Write to output file 
    
    %check file name has correct extension  -TO BE altered to furthercheck!!
    sizeOutputFileName= size(outputFileName);
    if (not(strcmp(outputFileName((sizeOutputFileName(2) -3):sizeOutputFileName(2)), fileExtension)))
        outputFileName = [outputFileName fileExtension];
    end
    %%%%%%
        
    ouputFileID = fopen(outputFileName, 'w');
    
    for i = 1 : sizeNewHeader(1)
        fprintf(ouputFileID, '%s\r\n', newHeader{i});
    end
    
    
    dlmwrite(outputFileName, dataWrite, '-append', 'delimiter',OutputDelimiter, 'precision','%+2.6E');%'roffset', sizeNewHeader(1), 'coffset', 0,
    
    %------------------------------------------------------------------------------------------------
    
    
end

