%{
  Queen Mary University of London- School of Electrical Engineering and
  Computer Science 
  Engineer: Patrick Balcombe 
 
  Create Date:    19/01/2016 
  File Name:      custCart2SphVec
  Project Name:   
  
  Description: 
    Function to convert given columns from cartesian vectors to spherical
    vectors.
  Dependencies: 

  Revision: 
  Revision 0.01 - File Created 
  Revision 0.02 - name changed from 'pol2cartDeg' to 'custCart2SphVec' 
                - transformation from seperate magnitude and phase colums to a single
                complex vector 
                - vector passed to matlab function cart2sphvec
                - return variables added magTheta, angTheta, magPhi, angPhi
                with use of abs() and angle()
  the output of 
  Additional Comments:   
%}

function [magTheta, angTheta, magPhi, angPhi] = custCart2SphVec( magi, angi, thetaPhi )

    %create complex vector using provided magnitudes and phases for x, y
    %and z components and transpose to get into correct format of three
    %rows as
    coordVec = transpose(complex(magi, angi));
    
    %carry out conversion from cartesian to spherical
    for i = 1 : size(thetaPhi)%loop through data elements
        sphVec = cart2sphvec(coordVec(:, i), thetaPhi(i, 1), thetaPhi(i, 2));
    end
    
    %correct to right orientation of three columns by samples in rows
    sphVec = transpose(sphVec);
     
    %calculte the magnitude and angle of vectors for:
    %elevation (theta)
    magTheta=abs(sphVec(2));
    angTheta=angle(sphVec(2));
    %azimuth (phi)
    magPhi=abs(sphVec(1));
    angPhi=angle(sphVec(1));
       
end

