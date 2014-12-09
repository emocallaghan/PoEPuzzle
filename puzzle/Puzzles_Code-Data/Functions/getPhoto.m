function [ image ] = getPhoto( )
%how we get an image
% DSLR_Namespace = NET.addAssembly([pwd '\CameraControl.Devices.dll']);
% DeviceManager = CameraControl.Devices.CameraDeviceManager; 
% DeviceManager.ConnectToCamera();
% myCamera = DeviceManager.ConnectedDevices.Item(0);
% myPhotoSession = PhotoSession(myCamera);
% myCamera.CapturePhoto();
%testing = imread('Computer/D3200/Removable storage/DCIM/100D3200/DSC_0012.JPG');
%imshow(testing);
%figure;
fromCamera = imread('testPhotos/test_integration.jpg');
xmin = 1619;
ymin = 538;
width = 5439-xmin;
height = 3333-ymin;
rec = [xmin, ymin,width,height];
cropped = imcrop(fromCamera, rec);
image = cropped;
imshow(image);
end