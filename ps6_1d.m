% Problemset 6
%    1- Part d

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

spk = zeros(size(t));   % vector spk that has the same lentgh as t
spk(1:end-1) = d_thresh > 0; 


% --- Plot 4: Derivative of thresholded signal (2.65s to 2.7s)
figure;
plot(t(idx), spk(idx));
xlabel('Time (s)');
ylabel('Spike');
title('Detected spikes from Thresholded Signal (2.65s to 2.7s)');
grid on;

