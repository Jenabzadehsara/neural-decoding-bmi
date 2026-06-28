% Problemset 6
%    1- Part c

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

d_thresh = diff(thresh);        % 1-sample derivative of thresholded signal

% diff output is 1 sample shorter
t_diff = t(1:end-1);            % trim last sample to match diff output length

% Zoom index for the diff time vector
idx_diff = (t_diff >= 2.65) & (t_diff <= 2.7);

% --- Plot= Derivative of thresholded signal (2.65s to 2.7s)
figure;
plot(t_diff(idx_diff), d_thresh(idx_diff));
xlabel('Time (seconds)');
ylabel('Derivative (a.u.)');
title('1-Sample Derivative of Thresholded Signal (2.65s to 2.7s)');
grid on;

