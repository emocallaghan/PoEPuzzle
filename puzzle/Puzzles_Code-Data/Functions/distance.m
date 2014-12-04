function [ dist ] = distance( pointOne, pointTwo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    x1 = pointOne(1);
    y1 = pointOne(2);
    x2 = pointTwo(1);
    y2 = pointTwo(2);
    
    xterm = (x1-x2)^2;
    yterm = (y1-y2)^2;
    
    dist = (xterm + yterm)^.5;

end

