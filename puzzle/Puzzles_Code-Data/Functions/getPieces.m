function [ puzzlePieces ] = getPieces( image )

imageGray = rgb2gray(image);
imageGrayComp = imcomplement(imageGray);
background = imopen(imageGrayComp, strel('disk',200));
imageNoBack = imageGrayComp-background;
level = graythresh(imageNoBack);
blackWhite = im2bw(imageNoBack, level);
blackWhite = imfill(blackWhite, 'holes');

h = ones(5,5)/25;
filtered = imfilter(blackWhite, h, 'replicate');
edgePhoto = edge(filtered,'Canny');

puzzlePieces = extractEdgesCorners(edgePhoto);
end