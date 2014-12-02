function [ newimage ] = edgeDetection( image )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    for i=1:size(image,1)
        for j=1:size(image,2)
            neighborleft = 0;
            neighborright= 0;
            neighbortop = 0;
            neighbordown = 0;
            if(i~=1)
                neighbortop = image(i-1,j);
            end
            if(j~=1)
                neighborleft = image(i,j-1);
            end
            if(i~=size(image,1))
                neighbordown = image(i+1,j);
            end
            if(j~=size(image,2))
                neighborright = image(i, j+1);
            end
            
            if(neighborleft+neighborright+neighbortop+neighbordown>2)
                image(i,j) = 0;
            end
            
        end
    end
    imshow(image);
    newimage = image;

end

