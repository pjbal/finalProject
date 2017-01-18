%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    17/01/2016 
  File Name:      SortNSIHead
  Project Name:   
  
  Description: 
    Function to sort block of header read from file into individual fields

  Dependencies: 

  Revision: 
  Revision 0.01 - File Created 
  Additional Comments:   
%}


function fields = SortNSIHead( fullHeader )
    headerLines=size(fullHeader);
    fields = {}; %cell to hold various header arguments
    noFields= 0; % counter to store the number of  fields found in the header
    noTerms = 0; %counter to store the number of terms found under each field, also counter field header
    
    
    LineCounter = 1;
    
    while(LineCounter ~= headerLines(2))%loop through all the lines in the cell
       %loop through lines until a line with a asterix is found... 
%indicating a header field
       while((fullHeader{LineCounter}(1) ~= '*'))
           LineCounter = LineCounter + 1;%increment line counter
           
           if (LineCounter == headerLines(2)) break; end %check to see if there is a new line to check
       end
       
       if (LineCounter == headerLines(2)) break; end %check to see if there is a new line to check
       
       noFields= noFields +1; %record new field found
       noTerms = 1; %reset term counter for new field
       fields{noFields, noTerms }= fullHeader{LineCounter}(2:end);%store name of header field as first place array
       LineCounter = LineCounter + 1;%increment line counter
       
       while(fullHeader{LineCounter}(1) ~= 13)%check if the first character of the line is a charage return indicating a blank line
            noTerms = noTerms +1; %count term that has just been stored
           
            fields{noFields, noTerms } = fullHeader(LineCounter);%store found field value
           
            LineCounter = LineCounter + 1;%increment line counter to chech next line            
            
            if (LineCounter == headerLines(2)) break; end %check to see if there is a new line to check
       end
       
    end
    
end

