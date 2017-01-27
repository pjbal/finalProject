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
function dataWrite = NSItoFEKO1( fileName )

    %------------------------------------------------------------------------------------------------
    %read and sort header
    
    readFileID = fopen(fileName); %%add error checks
    
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
    
    dataRead = NSIReadData(fileName, noRowsData, sizeHeaderLines(2), noColumns); %read in block of data in the file
    
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
                solutionBlockArguments(2,1) = headerArgs{i,2};
                
            case ['HEADERSTART' char(13) char(10)]
                solutionBlockArguments(7,2) = headerArgs{i,2};
                solutionBlockArguments(6,2) = headerArgs{i,3};
                
        end        
                       
    end
    
    
    headerBlockIndicator = '##';
    
    sizeNewHeader = [0, 1];
    newHeader = [];
    
    for k = 1 : sizeHeaderBlockArguments(1)
        if (not(strcmp(HeaderBlockArguments(k,2), '')))
            sizeNewHeader(1) = sizeNewHeader(1) + 1;
            newHeader{sizeNewHeader(1)} = [headerBlockIndicator char(HeaderBlockArguments(k,1)) ': ' char(HeaderBlockArguments(k,2))];
            
        end
    end
    
    commentIndicator = '*';
    for l = 1 : sizeHeaderLines(1)
        
        commentHeaderLines{l} = [commentIndicator char(headerLines(l))];
        
    end
    
    sizeNewHeader(1) = sizeNewHeader(1) + sizeHeaderLines(1);
    
    newHeader = [newHeader; commentHeaderLines];    
    
    
    solutionBlockIndicator = '#';
    
    for k = 1 : sizeSolutionBlockArguments(1)
        if (not(strcmp(solutionBlockArguments(k,2), '')))
            sizeNewHeader(1) = sizeNewHeader(1) + 1;
            newHeade{sizeNewHeader(1)} = [solutionBlockIndicator char(solutionBlockArguments(k,1)) ': ' char(solutionBlockArguments(k,2))];
            
        end
    end  
    
    
    
    sizeNewHeader(1) = sizeNewHeader(1) + 1;
    newHeader{sizeNewHeader(1)} = ['#   Theta   Phi Re(Etheta)  Im(Etheta)  Re(Ephi)    Im(Ephi)'];

    
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Write to output file 
    dlmwrite('Test.ffe', dataWrite, 'delimiter', ' ', 'roffset', 15, 'coffset', 0, 'precision','%+2.6E');
    
    %------------------------------------------------------------------------------------------------
    
    
end

