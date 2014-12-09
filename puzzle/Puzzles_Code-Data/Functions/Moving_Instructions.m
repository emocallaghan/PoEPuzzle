%106 pixels in an inch
%produces a text file of X01234, Y01234, a012.34;
%then a 1 to lower solenoid and a 0 to raise solenoid
% formatSpec = 'X is %4.2f meters or %8.3f mm\n';
% fprintf(formatSpec,A1,A2)
% fileID = fopen('exp.txt','w');
% fprintf(fileID,'%6s %12s\n','x','exp(x)');
% fprintf(fileID,'%6.2f %12.8f\n',A);
% fclose(fileID);
function [movelist] = Moving_Instructions(piecelist,center2)
formatSpec = '%6.2f , \n %6.2f , \n %6.2f ,\n';
fileID = fopen('movelist.txt','w');
    for i = 1:1:length(piecelist(:,1))
        fprintf(fileID,formatSpec, center2(:,1), center2(:,2), angle );
        fprintf(fileID,'Z\n');
        fprintf(fileID,formatSpec,piecelist(:,1),piecelist(:,2), piecelist(:,3));
        fprintf(fileID,'Z');
    end

end


