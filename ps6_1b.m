% Problemset 6
%    1- Part b

sr = 40000; % 40 KHz voltage vector
ag = 1000; % amplifier gain (V/V)

% Time vector starting at t=0
n = length(vout);  % number of samples
t = (0:n-1) / sr; % Create time vector based on sample rate

v = vout/ag; % To get true voltage since the 
              % amplifier's gain = 1000 V/V

% Threshold
threshold = 0.0002;             % 0.2 mV in Volts
thresh = v>threshold;

% Zoom index for t = 2.65s to 2.7s
idx = (t >= 2.65) & (t <= 2.7);

% --- Plot 1: Full voltage signal
figure;
plot(t, v);
xlabel('Time (seconds)');
ylabel('Voltage (V)');
title('Voltage vs Time');
grid on;

% --- Plot 2: Zoomed voltage (2.65s to 2.7s)
figure;
plot(t(idx), v(idx));
xlabel('Time (seconds)');
ylabel('Voltage (V)');
title('Voltage vs Time (2.65s to 2.7s)');
grid on;

% --- Plot 3: Zoomed threshold signal (2.65s to 2.7s)
figure;
plot(t(idx), thresh(idx));
xlabel('Time (seconds)');
ylabel('Thresholded (0 or 1)');
title('Thresholded Signal (2.65s to 2.7s)');
grid on;