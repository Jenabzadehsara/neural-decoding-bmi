% Problemset 6
%    1- Part a

sr = 40000; % 40 KHz voltage vector
ag = 1000; % amplifier gain (V/V)

% Time vector starting at t=0
n = length(vout);  % number of samples
t = (0:n-1) / sr; % Create time vector based on sample rate

v = vout/ag; % To get true voltage since the 
              % amplifier's gain = 1000 V/V

% ---------------------------------- PLOT
plot (t,v)
xlabel('Time (seconds)');
ylabel('Voltage (V)');
title('Voltage vs Time');
grid on;






