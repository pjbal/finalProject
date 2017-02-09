function appendmatrix2file( fileName, dataWrite, delimiter, precision )
%
%   appendmatrix2file - Function to append matix of data to the end a file
%   
%   appendmatrix2file( outputFileName, dataWrite, delimiter, precision )
%
%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    09/02/2017 
%   File Name:      appendmatrix2file
%   Project Name:   
%   
%   Description: 
%     Function to append matix of data to the end a file
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
%   Revision 0.11 - Main code replaced with call to more efficiant
%                       readDataTransformFile 08/02/2017
% 
%   Additional Comments:
%

    %append data to file
    dlmwrite(fileName, dataWrite, '-append', 'delimiter',delimiter, 'precision', precision);

end

