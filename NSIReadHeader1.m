%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    17/01/2017 
  File Name:      NSIReadHeader1
  Project Name:   
  
  Description: 
    Function to read an NSI Header 

  Dependencies: 

  Revision: 
  Revision 0.01 - File Created
  Revision 0.02 - Changed return to Cell instead matrix  
  Additional Comments:   
%}

function linesRead = NSIReadHeader1(ReadID)
    NumHeaderLines = 1; %variable to store the number of lines read from the file
    linesRead{1} ='';
    
    %loop to read through header until start of data indictor is found
    while(~(strcmp (linesRead{NumHeaderLines}, {['*DATASTART' char(13) char(10)]}) || feof(ReadID)))
       
        if (ftell(ReadID) ~= 0) NumHeaderLines = NumHeaderLines + 1; end %increment size of header counter %%%%%%%%chang as ineficent
        linesRead{NumHeaderLines} = fgets(ReadID); %read line of header into cell
        
    end

    fgets(ReadID); %read data colum headers
    
    

end

