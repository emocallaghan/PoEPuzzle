
import sys
print (sys.version)
import serial
import time

serialConnection = serial.Serial()
serialConnection.baudrate = 9600
serialConnection.port = 28
print(serialConnection)


serialConnection.open()

file = open('Gcode.txt','r', 0) # open the file, grab the text
text = file.read()

parsed_text = text.splitlines() # we will send one line at a time, since
# each line should contain one command


for line in parsed_text:
    waiting_for_buffer_to_clear = True
    buffer_size = 999
    while waiting_for_buffer_to_clear: # blocking function to let the machine do
        # its stuff
        SerialInput = serialConnection.readline()
        SerialInput = SerialInput.decode(encoding='UTF-8',errors='strict').strip()
        print ('next line from the file: ' + str(SerialInput))
        print ('first four characters: ' + str(SerialInput[:4]))
        if SerialInput[:4] == 'BUFF': # this line tells us how full the buffer is- which
            # controls how long we 
            buffer_size = int(SerialInput[5:])
            print( "New buffer size found: " + str(buffer_size))
        if (buffer_size < 20):
            waiting_for_buffer_to_clear = False
        time.sleep(1) # cause the real world doesn't need my proccessor to die.
    
    serialConnection.write(line)
    print('writing ' + str(line) + " to the serial port.")
        
print('program finished, sending gantry back to 0,0,0,0')
serialConnection.write('Z1,')
serialConnection.write('X0,')
serialConnection.write('Y0,')
serialConnection.write('A90,')
serialConnection.write('Z0,')
serialConnection.close()

