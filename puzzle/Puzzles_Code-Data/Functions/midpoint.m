function [x,y ] = midpoint( line )
%MIDPOINT Summary of this function goes here
%   Detailed explanation goes here
    x1 = line(1,1);
    y1 = line(1,2);
    
    x2 = line(2,1);
    y2 = line(2,2);
    
    x = (x1+x2)/2;
    y = (y1+y2)/2;

end

