%using the puzzlePieces for producing the new piecelist
%might need other functions on top of this one as well
%I'm unsure of how to proceed on that front



function [piecelist] = newPositions(placements,bezPieces)
%I'm first producing a list of the changes of motion required for each
%piece


    for i = 2:1:length(placements)
        alpha(i-1) = placements(i).g_lock(1)*180/pi;  %change motion alpha
        xMotion(i-1) = (placements(i).g_lock(2))/1000; %change motion x
        yMotion(i-1) = (placements(i).g_lock(3))/1000;  %change motion y
        %now I'm getting the current locations of all the pieces
        pieceloc = bezPieces{1,i};         %separating each piece
        %averaging x and y values for each piece to determine pick up
        %locations. I'm not sure this is the best way, but for now it
        %should work.
        positions = [sum(pieceloc)/length(pieceloc)];
        xpos(i-1) = positions(1)/1000;
        ypos(i-1) = positions(2)/1000;
    end
    for j = 2:2:length(placements)
        x=1;
        piecelist = [alpha(x), xpos(x), ypos(x)];
        c = [alpha(x), xMotion(x)+xpos(x), yMotion(x)+ypos(x)];
        piecelist = [piecelist;c];
        x=x+1;
    end
    
    

end