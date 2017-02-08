
function headerBlock = FEKOReadHeaderBlockRead1(fileID)

%   Queen Mary University of London- School of Electrical Engineering and
%   Computer Science 
%   Engineer: Patrick Balcombe 
%  
%   Create Date:    11/01/2016 
%   File Name:      HeaderBlockRead1
%   Project Name:   
%   
%   Description: 
%     Function to read in the block header for the file formats:
%         *efe, *.hfe, *.ffe, *.ol. *.os
%     These formats have a common block header structure containing the
%     following header lines dennoted by "##" at the start of each line (as described in the FEKO user manual- May 2014):
%         Key         Required        Description
%         ---------------------------------------------
%         File Type   Yes             Describes the type of the file. The valid options for this, 
%                                     depend on the specific file type- *efe,*.ffe etc
% 
%         File Format  No             Denotes the file syntax version (e.g. “1.0”). If not present
%                                     it defaults to version 1.0 (files pre-dating Suite 6.1). The
%                                     initial new file format version will then be “2.0”.
% 
%         Source       No             Denotes the base filename of the source where this data
%                                     comes from.
% 
%         Date         No             Date of data export in format “YYYY-MM-DD hh:mm:ss”
%                                     (i.e. 24-hour format)
% 
%      The format for a header line is "##Key: Value" and must be at the top
%      of a file.
%      Comments can be anywhere in the file and are indicated by "**" and the
%      rest of the line following them must be ignored.
% 
%   Dependencies: 
% 
%   Revision: 
%   Revision 0.01 - File Created
%   Additional Comments:   


headerSize = 4; %define the maximum size of the header to be read

headerBlock=cell(headerSize,1);






