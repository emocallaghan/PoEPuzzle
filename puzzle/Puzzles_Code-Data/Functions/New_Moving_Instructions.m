%Making new moving instructions for actual puzzle pieces instead of for
%squares
%well attempting to...

function New_Moving_Instructions(piecelist)
formatSpec = '%6.2f,\n';
fileID = fopen('movelist.txt','w');
    for i = 1:2:length(piecelist)-1
            fprintf(fileID, 'Z1,\n');
            fprintf(fileID, 'X');
            %fprintf(fileID, formatSpec, center2(1,1)/106*300);
            fprintf(fileID,formatSpec, piecelist(i,2));

            fprintf(fileID, 'Y');
            %fprintf(fileID, formatSpec, (width-center2(1,2))/106*400);
            fprintf(fileID,formatSpec, piecelist(i,3));  %width-?


            fprintf(fileID,'Z0,\n');
            fprintf(fileID, 'Z1,\n');

            fprintf(fileID, 'A');
            %fprintf(fileID, formatSpec, piecelist(:,3));
            fprintf(fileID, formatSpec, piecelist(i+1,1));

            fprintf(fileID, 'X');
            %fprintf(fileID, formatSpec, piecelist(:,1)/106*300);
            fprintf(fileID, formatSpec, piecelist(i+1,2));

            fprintf(fileID, 'Y');
            %fprintf(fileID, formatSpec, (width-(piecelist(:,2)-sideLength/2))/106*400);
            fprintf(fileID, formatSpec, piecelist(i+1,3));  %width -?

            fprintf(fileID,'Z0,\n');
            fprintf(fileID, 'Z1,\n');

     end

end