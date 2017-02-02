%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    19/01/2016 
  File Name:      dBColumn2Deg
  Project Name:   
  
  Description: 
    Function to convert given columns from db to deg
  Dependencies: 

  Revision: 
  Revision 0.01 - File Created 
  Additional Comments:   
%}

function [data] = dBColumn2Deg( data, dbColumns )
%DBCOLUMN2DEG Summary of this function goes here
%   Detailed explanation goes here

   data(:,dbColumns)= db2mag(data(:,dbColumns));

end

