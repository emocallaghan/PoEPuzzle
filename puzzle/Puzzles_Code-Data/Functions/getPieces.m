function [ puzzlePieces ] = getPieces( image )

%Turns the image into a binary image and fills in the holes
imageGray = rgb2gray(image);
imageGrayComp = imcomplement(imageGray);
background = imopen(imageGrayComp, strel('disk',200));
imageNoBack = imageGrayComp-background;
level = graythresh(imageNoBack);
blackWhite = im2bw(imageNoBack, level);
blackWhite = imfill(blackWhite, 'holes');

%filter to pick up edges
h = ones(5,5)/25;
filtered = imfilter(blackWhite, h, 'replicate');

%binary image where the edges are white and everything else is black
edgePhoto = edge(filtered,'Canny');

%extractEdges returns the cell array with the pieces.
puzzlePieces = extractEdgesCorners(edgePhoto);
end