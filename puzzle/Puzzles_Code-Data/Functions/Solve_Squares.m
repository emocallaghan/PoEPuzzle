function [angle] = Solve_Squares(puzzlePieces)
%solves to put two squares together
    SquareOne = puzzlePieces{1};
    SquareTwo = puzzlePieces{2};
    
    s1CornerOne = [SquareOne(1,1),SquareOne(1,2)];
    s1CornerTwo = [SquareOne(2,1),SquareOne(2,2)];
    s2CornerOne = [SquareTwo(1,1),SquareTwo(1,2)];
    s2CornerTwo = [SquareTwo(2,1),SquareTwo(2,2)];
    
    lineOne = [s1CornerOne(1), s1CornerOne(2); s1CornerTwo(1), s1CornerTwo(2)];
    lineTwo = [s2CornerOne(1), s2CornerOne(2); s2CornerTwo(1), s2CornerTwo(2)];
    hold on;
    plot([s1CornerOne(1),s1CornerTwo(1)],[s1CornerOne(2),s1CornerTwo(2)],'LineWidth',4);
    plot([s2CornerOne(1),s2CornerTwo(1)],[s2CornerOne(2),s2CornerTwo(2)],'LineWidth',4);
    plot(lineOne(:,1), lineOne(:,2), 'LineWidth', 4);
    plot(lineTwo(:,1), lineTwo(:,2), 'LineWidth', 4);
    
    DirVector1=s1CornerOne-s1CornerTwo;
    DirVector2=s2CornerOne-s2CornerTwo;
    angle=acos( dot(DirVector1,DirVector2)/norm(DirVector1)/norm(DirVector2) );
end

