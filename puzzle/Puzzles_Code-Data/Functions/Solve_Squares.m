function [angle, pairIndices, sideLength] = Solve_Squares(puzzlePieces)
%solves to put two squares together

    SquareOne = puzzlePieces{1};
    SquareTwo = puzzlePieces{2};
    
    size1 = size(SquareOne);
    size2 = size(SquareTwo);
    
    corner1 = SquareOne{1};
    corner2 = SquareTwo{1};
    y1min = corner1{2};
    y2max = corner2{2};
    topCorner = 1;
    bottomCorner = 1;
    
    for i=2:size1(2)
        corner = SquareOne{i};
        if(corner{2}<y1min)
            topCorner = i;
            y1min = corner{2};
        end    
    end
    
    for i=2:size2(2)
        corner = SquareTwo{i};
        if(corner{2}>y2max)
            bottomCorner = i;
            y2max = corner{2};
        end
    end

    if(topCorner~=1)
        corner1 = SquareOne{1};
        y1min2 = corner1{2};
        topCorner2 = 1;
    else
        corner1 = SquareOne{2};
        y1min2 = corner1{2};
        topCorner2 = 2;
    end

    if(bottomCorner~=1)
        corner2 = SquareTwo{1};
        y2max2 = corner2{2};
        bottomCorner2 = 1;
    else
        corner2 = SquareTwo{2};
        y2max2 = corner2{2};
        bottomCorner2 = 2;
    end
    
    for i=2:size1(2)
        corner = SquareOne{i};
        if(topCorner~=i)
            if(corner{2}<y1min2)
                topCorner2 = i;
                y1min2 = corner{2};
            end
        end
    end

    for i=2:size2(2)
        corner = SquareTwo{i};
        if(bottomCorner ~= i)
            if(corner{2}>y2max2)
                bottomCorner2 = i;
                y2max2 = corner{2};
            end
        end
    end

    top1 = SquareOne{topCorner};
    top2 = SquareOne{topCorner2};
    bot1 = SquareTwo{bottomCorner};
    bot2 = SquareTwo{bottomCorner2};

    lineOne = [top1{1}, top1{2}; top2{1}, top2{2}];
    lineTwo = [bot1{1}, bot1{2}; bot2{1}, bot2{2}];
    hold on;
    plot(lineOne(:,1), lineOne(:,2), 'b', 'LineWidth', 2);
    plot(lineTwo(:,1), lineTwo(:,2), 'r', 'LineWidth', 2);

    s1CornerOne = [top1{1}, top1{2}];
    s1CornerTwo = [top2{1}, top2{2}];

    s2CornerOne = [bot1{1}, bot1{2}];
    s2CornerTwo = [bot2{1}, bot2{2}];

    DirVector1=s1CornerOne-s1CornerTwo;
    DirVector2=s2CornerOne-s2CornerTwo;

    angleNoDir=acos( dot(DirVector1,DirVector2)/( norm(DirVector1)*norm(DirVector2)) );
    
    xdif = lineTwo(1,1)-lineOne(1,1);
    ydif = lineTwo(1,2)-lineOne(1,2);
    newTopx = lineOne(1,1)+xdif;
    newTopy = lineOne(1,2)+ydif;
    
    dir = -1;
    if(newTopy<lineTwo(1,2))
        dir = 1;
    end
    
    angleRad = dir*angleNoDir;
    angle = angleRad*180/pi;
    [midOnex,midOney] = midpoint(lineOne);
    [midTwox, midTwoy] = midpoint(lineTwo);
    plot(midOnex, midOney, 'b+');
    plot(midTwox, midTwoy, 'r+');
    pairIndices = [midOnex, midOney; midTwox, midTwoy];
    
    sideLength = distance([lineOne(1,1),lineOne(1,2)], [lineOne(2,1),lineOne(2,2)] );
end

