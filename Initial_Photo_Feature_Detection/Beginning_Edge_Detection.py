#remebering how to comment in python

import cv2
import numpy as np
import csv
from matplotlib import pyplot as plt

#img = cv2.imread('../Test_Images/Puzzle_Test1_Images/DSLR/High_Rez/swedenFinland.JPG') # bring in the raw image
#img = cv2.imread('1B.JPG') # bring in the raw image
img = cv2.imread('blurred.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) # convert it to greyscale


# test one, using canny

# optional, needs to be tested. it blurres the image, but doesn't lose line sharpness.
# gray = cv2.bilateralFilter(gray, 11, 17, 17)
edges = cv2.Canny(gray,100,200,apertureSize=3) # highlight all the edges. 
# by using trial and error: 
# second number is threshold for what is considered 
# an edge. small number will increase the number of detected edges, since you 
# don't need as much change in color to be a line.
# first number alters coarsness of the lines. a small number will make the lines thicker,
# where as a large number will make them thin but some may be disconnected.

# update: better understanding of what the numbers do (min and max threshold values)
#vhttp://opencv-python-tutroals.readthedocs.org/en/latest/py_tutorials/py_imgproc/py_canny/py_canny.html

#print(edges)
cv2.imwrite('canny_edge_detection_output.jpg', edges)


ret,thresh = cv2.threshold(gray,150,255,cv2.THRESH_BINARY) # later on requires a greyscale image.
cv2.imwrite('threshold_output.jpg', thresh)

(cnts, _) = cv2.findContours(thresh, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE) # function destroys original image, so copy is used.
# we don't care about the other return. something like hierarchys?? don't know don't care.
# third argument can be one of the following, and determines if every edge point is stored, or if
# we approximate the edge with only valuable edge points.
#CHAIN_APPROX_NONE
#CHAIN_APPROX_SIMPLE
# second argument is how the hierarcys are formed, and isn't too important?? if the hierarchy return isn't used.

cnts = sorted(cnts, key = cv2.contourArea, reverse = True)[1:6] # grab only the largest contours, sorted by size (area contained, not number of points)
print(cnts.__len__())
#print cnts

cv2.drawContours(img,cnts,-1,(0,255,0),4) # only for visualization purposes. the mathematical list of points 
# will be more useful for matching.
# the last argument is the edge width. the first numerical argument is which contours to be drawn. make it -1 to draww all arguments.
# can also plot just one contour by passing in only one contour instead of a list of contours.
# first argument is which image to draw the contours on, second argument is the list of contours
# fourth argument is probably intensity of the line drawn??

cv2.imwrite('contours_output.jpg', img)
size = cnts.__len__();
puzdata = []
for i in range(0, size):
	puzdata.append(cnts[i].T)

print(puzdata)
with open('test.csv', 'wb') as fp:
    a = csv.writer(fp, delimiter=',')
    data = [['Me', 'You'],
            ['293', '219'],
            ['54', '13']]
    a.writerows(cnts)

"""
# test two, using countours.
ret,thresh = cv2.threshold(gray,127,255,0) # later on requires a greyscale image.
contours,hierarchy = cv2.findContours(thresh, 1, 2)
cnt = contours[0]
perimeter = cv2.arcLength(cnt,True)

cv2.imwrite('contours_output.jpg', perimeter)
"""

"""
lines=cv2.HoughLines(edges,1,np.pi/180,200)

for rho, theta in lines[0]:
	a = np.cos(theta)
	b = np.sin(theta)
	x0 = a*rho
	y0 = b*rho
	x1 = int(x0 + 1000*(-b))
	y1 = int(y0 + 1000*(a))
	x2 = int(x0 - 1000*(-b))
	y2 = int(y0 - 1000*(a))

cv2.line(img,(x1,y1),(x2,y2),(0,0,255),2)

cv2.imwrite('houghlines3.jpg',img)
"""