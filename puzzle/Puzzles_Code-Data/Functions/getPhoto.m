function [ image ] = getPhoto( )
%how we get an image

%Call to the camera to take a new photo

% DSLR_Namespace = NET.addAssembly([pwd '\CameraControl.Devices.dll']);
% DeviceManager = CameraControl.Devices.CameraDeviceManager; 
% DeviceManager.ConnectToCamera();
% myCamera = DeviceManager.ConnectedDevices.Item(0);
% myPhotoSession = PhotoSession(myCamera);
% myCamera.CapturePhoto();
%testing = imread('Computer/D3200/Removable storage/DCIM/100D3200/DSC_0012.JPG');
%imshow(testing);
%figure;

%Crop and return photo
fromCamera = imread('testPhotos/squaresMaddy.JPG');
xmin = 1500;
ymin = 450;
width = 5300-xmin;
height = 3300-ymin;
rec = [xmin, ymin,width,height];
cropped = imcrop(fromCamera, rec);
image = cropped;

%image = imread('testPhotos/All_Separate.JPG');

imshow(image);

end