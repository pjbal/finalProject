%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    19/01/2016 
  File Name:      pol2cartDeg
  Project Name:   
  
  Description: 
    Function to convert given columns from polar to cartesian
  Dependencies: 

  Revision: 
  Revision 0.01 - File Created 
  Additional Comments:   
%}

function [x, y] = pol2cartDeg( data, rCol, thCol )
    
   x = data(:,rCol).*cosd(data(:,thCol));

   y = data(:,rCol).*sind(data(:,thCol));
   
end

