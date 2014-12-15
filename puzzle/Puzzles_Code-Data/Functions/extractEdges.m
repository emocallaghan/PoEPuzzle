function [ PuzzlePieces ] = extractEdges( edgePhoto )
%EXTRACTEDGES Summary of this function goes here
%   Detailed explanation goes here

imshow(edgePhoto);
hold on;

Labeled = bwlabel(edgePhoto, 8);

sizeL = size(Labeled);
for i = 1:sizeL(1)
    for j = 1:sizeL(2)
        if (Labeled(i,j)>0)
            plot(j,i,'g');
        end
        if (Labeled(i,j)==2)
            plot(j,i,'b');
        end
    end

end

%determines how many unique labels there are.
labels = [];
for i = 1:sizeL(1)
    for j = 1:sizeL(2)
        currentLabel = Labeled(i,j);
        newLab = true;
        sizeLabels = size(labels);
        %determines if there are any other labels. If not and the current
        %label isn't zero simply adds to new labels.
        if(sizeLabels(2)==0)
            if(currentLabel==0)
                newLab = false;
            end
        else
            %if the currentLabel is zero or if it is already accounted for
            %don't add it.
            for lab = 1:sizeLabels(2)
                if(currentLabel==0 || currentLabel == labels(lab))
                    newLab = false;
                end
            end
        end
        if(newLab)
            labels(end+1) = currentLabel;
        end
    end
end

%creates the same size in pieces as there are different labels. So each
%unique label corresponds to one index of pieces
pieces = {};
sizeLabels = size(labels)
for i=1:sizeLabels(2)
    piece = [];
    pieces{i} = piece;
end

%adds the x,y for any label to the pieces cell array indexed at that label

for i = 1:sizeL(1)
    for j = 1:sizeL(2)
        currentLabel = Labeled(i,j);
        if(currentLabel>0)
            piece = pieces{currentLabel};
            piece(end+1,1) = j;
            piece(end,2) = i;
            pieces{currentLabel} = piece;
        end
    end
end

for i=1:sizeLabels(2)
    sorted = distanceSort(pieces{i});
    pieces{i} = sorted;
end

bezPieces = {};
for i=1:sizeLabels(2)
    piece = pieces{i};
    bezPiece = bezier_(piece);
    bezPieces{i} = bezPiece;
end

PuzzlePieces = bezPieces;

end

