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
fromCamera = imread('testPhotos/test_black_lines_1.jpg');
xmin = 1708;
ymin = 474;
width = 3790;
height = 2776;
rec = [xmin, ymin,width,height];
cropped = imcrop(fromCamera, rec);
image = cropped;
end