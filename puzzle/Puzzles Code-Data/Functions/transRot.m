%input to function needs to be the current location of two points that
%should be aligned.  It will also take in the angle of both of them, solve
%for the difference and command piece two to go to that position.


function[xtrans,ytrans,alpha] = transRot(x1pos,x2pos,y1pos,y2pos,alpha,c)
yold = y2pos - y1pos;
xold = x1pos - x2pos;
coeffx = cos(alpha)*c;
coeffy = sin(alpha)*c;

if yold > 0
    %ynew = yold + coeffy;
    %ytrans = y2pos-ynew;
    ytrans = y2pos-yold;
end
if yold < 0
    %ynew = yold-coeffy
    %ytrans = y2pos+ynew
    ytrans = y2pos - yold
end
if xold > 0
    xnew = xold-coeffx;
    xtrans = x2pos + xnew - c;
    xtestpoint = x2pos + xnew + coeffx
end
if xold < 0
    xnew = xold + coeffx;
    xtrans = x2pos + xnew - c;
    xtestpoint = x2pos + xnew - coeffx
end

end