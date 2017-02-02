%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    18/01/2017 
  File Name:      NSIReadData
  Project Name:   
  
  Description: 
    Function to read the header block of an NSI file

  Dependencies: 

  Revision: 
  Revision 0.01 - File Created 
  Revision 0.02 - dlmread implemented 18/01/2017
  Additional Comments:   
%}
function fileData = NSIReadData( fileName, noRows, headerOffset, noColumns )

    fileData = dlmread(fileName, '', [(headerOffset+1) 0 (headerOffset + noRows) (noColumns-1)]);

end

