#remebering how to comment in python

import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('../Test_Images/Puzzle_Test1_Images/DSLR/High_Rez/1B.JPG') # bring in the raw image
#img = cv2.imread('1B.JPG') # bring in the raw image
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) # convert it to greyscale
edges = cv2.Canny(gray,50,50,apertureSize=3) # highlight all the edges. 
# by using trial and error: 
# second number is threshold for what is considered 
# an edge. small number will increase the number of detected edges, since you 
# don't need as much change in color to be a line.
# first number alters coarsness of the lines. a small number will make the lines thicker,
# where as a large number will make them thin but some may be disconnected.

# update: better understanding of what the numbers do (min and max threshold values)
#vhttp://opencv-python-tutroals.readthedocs.org/en/latest/py_tutorials/py_imgproc/py_canny/py_canny.html

print "hello"
cv2.imwrite('canny_edge_detection_output.jpg', edges)

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