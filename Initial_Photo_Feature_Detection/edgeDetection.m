function [ edges ] = edgeDetection( imageName)
    image = imread(imageName);
    imshow(image);
    
    edges = [0;0];
end

