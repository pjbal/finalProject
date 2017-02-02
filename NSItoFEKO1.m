function dataWrite = NSItoFEKO1( inputFileName, inputFormat, outputFileName, outputFormat)
%
%  Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    17/01/2016 
%   File Name:      NSItoFEKO1
%   Project Name:   
%   
%   Description: 
%     Function to convert between NSI and FEKO 
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
% 
%   Additional Comments:
%

  
    %------------------------------------------------------------------------------------------------
    
    %options
    includePreHeader = 0;
    
    %Information about format
    headerBlockIndicator = '##';
    commentIndicator = '**';  
    solutionBlockIndicator = '#';
    fileExtension = '.ffe';
    OutputDelimiter = ' ';
    
    
    HeaderBlockArguments = {'File Type', ''; 'File Format', ''; 'Source ', ''; 'Date', ''};
    
    solutionBlockArguments = {'Request Name', ''; 'Frequency', ''; 'Origin', '';...
        'u-Vector', ''; 'v-Vector', ''; 'No. of [Phi]Samples', ''; 'No. of [Theta]Samples', '';...
        'Result Type', ''; 'Incident Wave Direction', ''; 'No. of Header Lines', ''};
    
    newColumnHeaders = ['#   Theta   Phi Re(Etheta)  Im(Etheta)  Re(Ephi)    Im(Ephi)'];
    
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
   
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Prepare header
    
    %find the number of possible block and solution header arguments
    sizeHeaderBlockArguments = size(HeaderBlockArguments);      
    sizeSolutionBlockArguments = size(solutionBlockArguments);
    
    %add fixed values to relevent header arguemnts
    HeaderBlockArguments{1,2} = 'Far field';
    HeaderBlockArguments{1,2} = '3';
    
    
    for i = 1 : noHeaderArgs(1) %loop to go through origional header to find values need for new header
        switch char(headerArgs(i,1)) %origional header arguments
            
            case ['FREQUENCY (MHz)' char(13) char(10)]
                solutionBlockArguments(2,2) = headerArgs{i,2};
                
            case ['HEADERSTART' char(13) char(10)]
                solutionBlockArguments(7,2) = headerArgs{i,2};
                solutionBlockArguments(6,2) = headerArgs{i,3};
                
        end %end of origional header switch case
                       
    end %end of origional header switch case
    
        
    sizeNewHeader = [0, 1]; %matrix to hold size of new header
    newHeader = {}; %cells to hold arguements of new header  
    
    
    for k = 1 : sizeHeaderBlockArguments(1) %loop through header block arguments
        if (not(strcmp(HeaderBlockArguments(k,2), ''))) %check if arguments have been given a value
            
            %add header argment which have been given a value to the new header
            sizeNewHeader(1) = sizeNewHeader(1) + 1; 
            newHeader{sizeNewHeader(1)} = [headerBlockIndicator char(HeaderBlockArguments(k,1)) ': ' char(HeaderBlockArguments(k,2))];
            
        end
    end
    
    %add empty lines to header to break up
     sizeNewHeader(1) = sizeNewHeader(1) + 1;
     newHeader{sizeNewHeader(1),1} = [char(13) char(10)]; %add new line characters to next cell of header
    
     if (includePrevHeader)%check if the previous header should be included
         %if the header should be included the place it as comments in the
         %cell containing the new header
         
        sizeCommentHeaderLines = [0,1];%define matrix to hold the size of the array holding the comments about origional file

        %add informaton about origional file and transformation in first
        %comment lines
        commentHeaderLines{1,1} = [commentIndicator 'File transalted from origional format- ' inputFormat ', to- ' outputFormat '\r\n'];
        commentHeaderLines{2,1} = [commentIndicator 'Origional Header:\r\n'];

        %increment size of comment array as new lines addded
        sizeCommentHeaderLines(1) = sizeCommentHeaderLines(1) +2;

        for l = 1 : sizeHeaderLines(2) %loop through all lines of the origional header

            sizeCommentHeaderLines(1) = sizeCommentHeaderLines(1) + 1; %increment size as comented header line about to be added
            commentHeaderLines{sizeCommentHeaderLines(1),1} = [commentIndicator char(headerLines(1,l))]; %add origional header line with comment indicator to show that it is a comment

        end %end loop through origional header lines

        sizeNewHeader(1) = sizeNewHeader(1) + sizeCommentHeaderLines(1); %add the numner of comment lines to the total number of header lines

        newHeader = [newHeader; commentHeaderLines]; %add the comment lines to the toatal new header

        %add empty lines to header to break up
        sizeNewHeader(1) = sizeNewHeader(1) + 1;
        newHeader{sizeNewHeader(1),1} = [char(13) char(10)];
    
     end %end of header comment if statment
    
    for k = 1 : sizeSolutionBlockArguments(1)%loop through soluton header arguments
        if (not(strcmp(solutionBlockArguments(k,2), '')))%check if arguments have been given a value
            
            %add header argment which have been given a value to the new header            
            sizeNewHeader(1) = sizeNewHeader(1) + 1;
            newHeader{sizeNewHeader(1)} = [solutionBlockIndicator char(solutionBlockArguments(k,1)) ': ' char(solutionBlockArguments(k,2))];
            
        end
    end  
    
    %add column titles to the header    
    sizeNewHeader(1) = sizeNewHeader(1) + 1;
    newHeader{sizeNewHeader(1)} = newColumnHeaders;

    
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Write to output file 
    
    %check file name has correct extension  -TO BE altered to furthercheck!!
    sizeOutputFileName= size(outputFileName);
    if (not(strcmp(outputFileName((sizeOutputFileName(2) -3):sizeOutputFileName(2)), fileExtension)))
        outputFileName = [outputFileName fileExtension];
    end
    %%%%%%
        
    ouputFileID = fopen(outputFileName, 'w');%open output file
    
    %print header to file
    for i = 1 : sizeNewHeader(1)%loop through all new header lines
        fprintf(ouputFileID, '%s\r\n', newHeader{i});
    end
    
    fclose(outputFileID);%close output file
    
    %write data to output file
    dlmwrite(outputFileName, dataWrite, '-append', 'delimiter',OutputDelimiter, 'precision','%+2.6E');
    %------------------------------------------------------------------------------------------------
    
    
end

