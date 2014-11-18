clear all;
I = imread('puzzle_flash.jpg');
I=rgb2gray(I);
imshow(I,[])
figure;
manual_threshold = 150; 
J3 = I > manual_threshold;
imshow(J3,[])

%%
BW = J3;
imshow(BW,[]);
figure;
% 
% CC = bwconncomp(BW);
% L = labelmatrix(CC);
% stats  = regionprops(L);
% area = [stats.Area];
% size_thresh = 10;
% idx = find(area > size_thresh);
% BW2 = ismember(L, idx);
% imshow(BW2)
% BW3 = imfill(BW2,'holes');
% imshow(BW3)
% %%
% 
%      BW_trial = imdilate(BW,strel('square',5));
%      imshow(BW_trial)
%      figure;
%      level = graythresh(I_leveled(BW_trial));
%      pixel = level * 255;
%      BW4 = im2bw(I_leveled,level);
%      BW4(~BW_trial) = 0;
%      BW4 = imfill(BW4,'holes');
%      BW4 = bwareaopen(BW4,30);
%      imshow(BW4,[]) 
    BW5 = bwperim(BW);
    imshow(BW5,[]) 
    I2 = I; I2(BW5) = 255;
    I_RGB = I2;
    I2 = I; I2(BW5) = 0;
    I_RGB(:,:,2) = I2;
    I2 = I; I2(BW5) = 0;
    I_RGB(:,:,3) = I2;
    imshow(I_RGB,[])