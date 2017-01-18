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
function KEKOData = NSItoFEKO1( fileName )
    
    readFileID = fopen(fileName); %%add error checks
    
    headerLines = NSIReadHeader1(readFileID);
    
    noHeaderLines = size(headerLines);%recod number of header lines for ofset of data read
      
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
    
    KEKOData = NSIReadData(fileName, noRowsData, noHeaderLines(2), noColumns); %read in block of data in the file
    
    fclose(readFileID); %%add error checks
end

