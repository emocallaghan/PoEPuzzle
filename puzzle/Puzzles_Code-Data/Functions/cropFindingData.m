%code on how to find points to crop

x = [1708, 5498, 5498,1708,1708];
y = [474, 474, 3250, 3250, 474];

xmin = 1708;
ymin = 474;
width = 3790;
height = 2776;
rec = [xmin, ymin,width,height];

test1 = imread('test_integration.jpg');

% test1g = rgb2gray(test1);
% test2g = rgb2gray(test2);
% test3g = rgb2gray(test3);
% test4g = rgb2gray(test4);

c1 = corner(test1g, 'QualityLevel', .01);
% c2 = corner(test2g, 'QualityLevel', .001);
% c3 = corner(test3g, 'QualityLevel', .001);
% c4 = corner(test4g, 'QualityLevel', .001);

1588, 500
5439, 538
1619, 3333

figure;
imshow(test1);
hold on;
plot(x,y);
plot([xmin, xmin+width, xmin+width, xmin, xmin],[ymin, ymin, ymin+height,ymin+height, ymin,], 'bo');

%plot(c1(:,1),c1(:,2),'r*');

 figure;
 imshow(test2);
 hold on;
 plot(x,y);
plot([xmin, xmin+width, xmin+width, xmin, xmin],[ymin, ymin, ymin+height,ymin+height, ymin,], 'bo');
% plot(c2(:,1),c2(:,2),'r*');
% plot([1660,5498,5556,1708],[462,474,3250,3303], 'bo');
% 
 figure;
 imshow(test3);
 hold on;
 plot(x,y);
plot([xmin, xmin+width, xmin+width, xmin, xmin],[ymin, ymin, ymin+height,ymin+height, ymin,], 'bo');
% plot(c3(:,1),c3(:,2),'r*');
% plot([1660,5498,5556,1708],[462,474,3250,3303], 'bo');
% 
 figure;
 imshow(test4);
 hold on;
 plot(x,y);
plot([xmin, xmin+width, xmin+width, xmin, xmin],[ymin, ymin, ymin+height,ymin+height, ymin,], 'bo');
% plot(c4(:,1),c4(:,2),'r*');
% plot([1660,5498,5556,1708],[462,474,3250,3303], 'bo');

% 1660,462
% 5498, 474
% 5556, 3250
% 1708, 3303

%1708, 474
%5498, 474
%5498, 3250
%1708, 3250

testcrop1 = imcrop(test1, rec);

figure;
imshow(testcrop1);