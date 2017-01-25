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
    
    readFileID = fopen(fileName); %%add error checks
    
    headerLines = NSIReadHeader1(readFileID);
    
    fclose(readFileID); %%add error checks
    
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
    
    dataRead = NSIReadData(fileName, noRowsData, noHeaderLines(2), noColumns); %read in block of data in the file
    
    %------------------------------------------------------------------------------------------------
    %carry out necessary data conversions
    dbFields = [3,5,7];
    magColm = [3, 5, 7];%%%%%%%%%%%%%%%%%%%%%
    angColm = [4, 6, 8];
    thetPhiColm = [1, 2];
    
    
    %convert from polar to planner complex format given a DB    
    
    %convert db columns to degreas
    dataRead = dBColumn2Deg(dataRead, dbFields);
    
    %convert from cartesian vector form to spheical vector form
    [magTheta, angTheta, magPhi, angPhi]= custCart2SphVec( dataRead(:,magColm), dataRead(:,angColm), dataRead(:,thetPhiColm));
        
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %prepare output matrix  
    
    dataWrite = [dataRead(:,thetPhiColm) magTheta angTheta magPhi angPhi]; 
    
   dataWrite = double(dataWrite);
   
   
   file_out = fopen('Test1.ffe', 'w');
   
   for i = 1:noRowsData
    
        
     fprintf(file_out, '%6.2f\t%6.2f\t%+2.6e\t%+2.6e\t%+2.6e\t%+2.6e\t%' char(13) char(10), dataRead(i,thetPhiColm(1)), dataRead(i,thetPhiColm(2)),...
            magTheta(i), angTheta(i), magPhi(i), angPhi(i));
    
   end
   
   fclose(file_out);
   
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Prepare header
    
    
    %------------------------------------------------------------------------------------------------
    
    %------------------------------------------------------------------------------------------------
    %Write to output file 
    dlmwrite('Test.ffe', dataWrite, ' ', 15, 0);
    
    %------------------------------------------------------------------------------------------------
    
    
end

