function [ puzzlePieces ] = getPieces( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myfilter = fspecial('gaussian',[3 3], 0.5);
    myfilteredimage = imfilter(image, myfilter, 'replicate');
    I = rgb2gray(myfilteredimage);
    Corners = corner(I, 'QualityLevel', .18, 'SensitivityFactor',0.06);    
    SquareOne = [[Corners(1,1), Corners(1,2)];[Corners(2,1), Corners(2,2)];...
                 [Corners(3,1), Corners(3,2)];[Corners(4,1), Corners(4,2)]];
    
    SquareTwo = [[Corners(5,1), Corners(5,2)];[Corners(7,1), Corners(7,2)];...
                 [Corners(8,1), Corners(8,2)];[Corners(6,1), Corners(6,2)]];
    figure;
    imshow(I);
    hold on;
    plot(Corners(:,1), Corners(:,2),'r*');
    figure;
    imshow(I);
    hold on;
    plot(SquareOne(:,1),SquareOne(:,2), 'b*');
    plot(SquareTwo(:,1),SquareTwo(:,2), 'g*');    
    figure;
    imshow(I);
    %puzzlePieces = Corners;
    puzzlePieces = {SquareOne, SquareTwo};
end

