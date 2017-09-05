%% User Input Overide For Pump Relay
%  This script will write user inputs to thingspeak to either turn the pump
%  on or off for a certain period of time or turned off until otherwise stated
%  by another input.

%% Clear command window and workspace variables
clc, clear all 

%% Define channel number, write key, and read key

Ch_ID = 324234;                   % thingspeak channel ID
read_key = '';    % read key for channel
write_key = '';   % write key for channel

%% Show current state of pump to user

% read thingspeak for current state value of the pump
pump_state_value = thingSpeakRead(Ch_ID, 'Fields', 3 ,'ReadKey',read_key );
  
if pump_state_value == 0      % value read from thingspeak 
    pump_state = 'OFF';       % if thingspeak returns a 0 tell user pump is off
    
elseif pump_state_value == 1  % value read from thingspeak 
      pump_state = 'ON';      % if thingspeak returns a 1 tell user pump is on 
end                           % end if statement 

fprintf('The pump is currently %s \n', pump_state)  % tell user the state of the pump 

%% Start User input

start_override = 1; % start while loop
pump_minutes = 0;   % initate variable

while start_override == 1
   
    % Prompt user for pump function that would like to preform
     pump_function = input('Enter function value(0 = stop pump, 1 = run pump, 2 = sensor actuated, 3 = exit): ')
    
     if pump_function < 0 | pump_function > 3     % check for valid inputs
         fprintf('Please enter valid value \n')   % If input is invalid, tell user
         continue                                 % start loop over for new, valid, user input
    
     elseif pump_function == 0       % if pump shut off is selected
        
         % Prompt user to either enter a time for sutoff in miutes, or shut off indefinetly
           pump_minutes = input(['Enter time(in minutes) for pump to remain OFF: ']);
               
     elseif pump_function == 1       % if pump on is selected                
        
         % prompt user for the time in minutes they would like the pump to remain on
           pump_minutes = input('Enter time(in minutes) for pump to remain ON: ');
          
     elseif pump_function == 3       % if exit is selected
         break                       % end while loop
         
     end    % end if statemnt
     
     
[last_upload,timestamps] = thingSpeakRead(Ch_ID,'Fields', 1 ,'ReadKey',read_key ); % get timestamp for last upload

while datetime('now') < (timestamps + seconds(15))    % make sure there is no upload timing discrepancy with thingspeak 
    pause(0.5)                                        % add timing buffer
end                                                   % end while loop 

          % write user inputs to the two thingspeak fields denoted
          thingSpeakWrite(Ch_ID, [pump_function, pump_minutes, pump_state_value] ,'WriteKey',write_key )
          pause(15)  % pause for 15 seconds per thingspeak requirements
          
end    % end while loop 
