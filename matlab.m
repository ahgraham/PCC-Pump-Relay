%% Clear command window, variables, plot windows and connected devices
clc, clear all
close all
delete(instrfindall); % deletes any existing serial ports

%% Open the serial port to connect to the Arduino
arduino=serial('COM4','BaudRate',9600); % change first argument to correspond to the port the arduino is hooked up to
fopen(arduino);
serial_read = fscanf(arduino, '%g',1) % read current serial output from arduino (0 is open/not connected, 1 is closed/connected)
%   Authenticate the thingspeak read and write keys for easier upload and
%   download
thingSpeakAuthenticate(324234, 'ReadKey', '', 'WriteKey', '')


%% Start of loop to pull user overide and ph data from loop
while 1 == 1
%   make sure it has been 15 seconds since last upload, if not wait
[last_upload,timestamps] = thingSpeakRead(324234,'Fields',[1],'NumPoints', 1, 'OutputFormat','matrix')
    while  datetime('now') < timestamps + seconds(15)
    pause(.5)
    end
%   download user overide from thingspeak and set variables for overide and
%   time
        user_overide_status = thingSpeakRead(324234,'Fields',[1 2 3],'NumPoints', 1, 'OutputFormat','matrix')
%   User overide variables ( 0 for off, 1 for on and 2 for no overide)
        user_overide = user_overide_status(1)
%   user overide time (how long should the sysytem stay in overide in
%   minutes)
        desired_time = user_overide_status(2)
%   If loop for an overide of 1
    if user_overide == 1
%   Turn on the switch
        fprintf(arduino, '%d', 1);
%   Convert the desired on time to a minutes format
        time_length = minutes(desired_time);
%   Set the end time for the overide
        end_time = datetime('now') + time_length;
%   create a time remaining variable to upload to thinkspeak
        time_remaining = minutes(end_time - datetime('now'))
%   Read the status of the arduino on serial port
        serial_read = fscanf(arduino, '%g',1)
%   Convert the user overide back to 2 and update thingspeak with time
%   remaining and status of arduino
        thingSpeakWrite(324234,[2,time_remaining,serial_read],'WriteKey','')
%   Pause for 30 seconds
        pause(30)
%   Enter loop to continue useroveride for remaining time
        while (end_time > datetime('now'))
%   Create the plot of pump status with labels         
[arduino_status,timestamps] = thingSpeakRead(324234,'Fields',[3],'NumPoints', 50, 'OutputFormat','matrix');
figure (1)
plot(timestamps,arduino_status)
ylim([-0.5 2.1])
title('Status of the Pump (1 for On, 0 for off, 2 for no data available)')
xlabel('time')
ylabel('status')
%   update remaining time for overide based on current time
            time_remaining = minutes(end_time - datetime('now'))
%   make sure it has been 15 seconds since last upload, if not wait
[last_upload,timestamps] = thingSpeakRead(324234,'Fields',[1],'NumPoints', 1, 'OutputFormat','matrix')
    while  datetime('now') < timestamps + seconds(15)
    pause(.5)
    end
%   Convert the user overide back to 2 and update thingspeak with time
%   remaining and status of arduino
            thingSpeakWrite(324234,[2,time_remaining,serial_read],'WriteKey','')
%   Pause for 30 seconds
            pause(30)
%   download user overide from thingspeak and set variables for overide
            user_overide_status = thingSpeakRead(324234,'Fields',[1 2 3],'NumPoints', 1, 'OutputFormat','matrix')
            user_overide = user_overide_status(1)
%   if loop to break while loop if user has enetered a new overide before
%   time has expired
            if user_overide ~=2
                break
            end
        end
%   If loop for an overide of 0
    elseif user_overide == 0
%   Turn off the switch       
        fprintf(arduino, '%d', 0);
%   Convert the desired off time to a minutes format
        time_length = minutes(desired_time);
%   Set the end time for the overide
        end_time = datetime('now') + time_length;
%   create a time remaining variable to upload to thinkspeak
        time_remaining = minutes(end_time - datetime('now'))
%   Read the status of the arduino on serial port        
        serial_read = fscanf(arduino, '%g',1)
%   Convert the user overide back to 2 and update thingspeak with time
%   remaining and status of arduino
        thingSpeakWrite(324234,[2,time_remaining,serial_read],'WriteKey','')
%   Pause for 30 seconds
        pause(30)
%   Enter loop to continue useroveride for remaining time
        while (end_time > datetime('now'))
%   Create the plot of pump status with labels              
[arduino_status,timestamps] = thingSpeakRead(324234,'Fields',[3],'NumPoints', 50, 'OutputFormat','matrix');
figure (1)
plot(timestamps,arduino_status)
ylim([-0.5 2.1])
title('Status of the Pump (1 for On, 0 for off, 2 for no data available)')
xlabel('time')
ylabel('status')
%   update remaining time for overide based on current time
time_remaining = minutes(end_time - datetime('now'))
%   make sure it has been 15 seconds since last upload, if not wait
[last_upload,timestamps] = thingSpeakRead(324234,'Fields',[1],'NumPoints', 1, 'OutputFormat','matrix')
    while  datetime('now') < timestamps + seconds(15)
    pause(.5)
    end
%   Convert the user overide back to 2 and update thingspeak with time
%   remaining and status of arduino
            thingSpeakWrite(324234,[2,time_remaining,serial_read],'WriteKey','')
%   Pause for 30 seconds
            pause(30)
%   download user overide from thingspeak and set variables for overide
            user_overide_status = thingSpeakRead(324234,'Fields',[1 2 3],'NumPoints', 1, 'OutputFormat','matrix')
            user_overide = user_overide_status(1)
%   if loop to break while loop if user has enetered a new overide before
%   time has expired
            if user_overide ~=2
                break
            end
        end
%   If loop for no overide and to use ph data from thingspeak       
    elseif user_overide == 2
%   download PH data from thingspeak and set to PH values raw variable
        thingSpeakAuthenticate(318598, 'ReadKey', '', 'WriteKey', '')
        PH_values_raw =  thingSpeakRead(318598,'Fields',[1],'NumPoints', 4, 'OutputFormat','matrix')
%   take the average of the last 4 PH readings
        PH_reading = mean(PH_values_raw)
%   If loop to turn pump on or off based on PH values
%   Pump on if PH below 6 or above 8
        if PH_reading < 6 | PH_reading > 8
            fprintf(arduino, '%d', 1);
%   Read the status of the arduino on serial port   
            serial_read = fscanf(arduino, '%g',1)
            if serial_read == []
                serial_read = 2
            end
%   Convert the user overide back to 2 and update thingspeak with status
            thingSpeakWrite(324234,[2,0,serial_read],'WriteKey','')
%   Pause for 30 seconds
            pause(30)
%   Pump off if PH is between 6 and 8
        else
            fprintf(arduino, '%d', 0);
%   Read the status of the arduino on serial port 
            serial_read = fscanf(arduino, '%g',1)
            if serial_read == []
                serial_read = 2
            end
%   Convert the user overide back to 2 and update thingspeak with status
        thingSpeakWrite(324234,[2,0,serial_read],'WriteKey','')

            pause(30)
        end
%   Create the plot of pump status with labels  
[arduino_status,timestamps] = thingSpeakRead(324234,'Fields',[3],'NumPoints', 50, 'OutputFormat','matrix');
figure (1)
plot(timestamps,arduino_status)
ylim([-0.5 2.1])
title('Status of the Pump (1 for On, 0 for off, 2 for no data available)')
xlabel('time')
ylabel('status')
    end 
end

%%   Close the arduino if the loop breaks for some reason
fclose(arduino)
