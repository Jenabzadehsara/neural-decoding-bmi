% Problemset 6
%    2- Part a

% Create a vector that contains the values of 
% each "inter-spike interval"; 
% that is, the time (in ms) between each
% pair of consecutive spikes. 
% Plot a histogram of the inter-spike interval 
% distribution for 
% interspike-intervals <20ms. Use 100
% time bins in your plot.

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
idx2 = (t<= 0.02); % seconds

d_thresh = diff(thresh);        % 1-sample derivative of thresholded signal

% diff output is 1 sample shorter
t_diff = t(1:end-1);            % trim last sample to match diff output length

% Zoom index for the diff time vector
idx_diff = (t_diff >= 2.65) & (t_diff <= 2.7);

spk = zeros(size(t));   % vector spk that has the same lentgh as t
spk(1:end-1) = d_thresh > 0; 

inter_spikeint = diff(t(spk > 0)) * 1000; % inter-spike intervals in ms
% Filter inter-spike intervals to include only those < 20 ms
inter_spikeint = inter_spikeint(inter_spikeint < 20);


% ------------------------------- plot
figure;
hist(inter_spikeint, 100);
xlabel('Time (s)');
ylabel('Count');
title('Inter-spike intervals (t<20ms)');
grid on;




