% Problemset 6
%    2- Part b

% ------------------
% Create a vector of the same length as "t" 
% that is "1" at the time samples 
% corresponding to onset times of
% each air puff, and 0 otherwise. 
% Create a peri-stimulus time histogram (PSTH) 
% of the spiking response to the air puff onsets.
% Your PSTH should go from -100ms to +100ms on 
% the x-axis. Use 200 (or 1ms) time bins. 
% What is the latency between the
% air puff and the neuron's maximal spiking response?
% ----------------------------------

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

inter_spikeint = diff(t(spk > 0)) * 1000; % inter-spike intervals in ms
% Filter inter-spike intervals to include only those < 20 ms
inter_spikeint = inter_spikeint(inter_spikeint < 20);

puff_bin       = double(puffs > 2.0);
puff_diff      = diff(puff_bin);
puff_onset_idx = find(puff_diff == 1) + 1;  % rising edges

fprintf('Number of puff trials: %d\n', length(puff_onset_idx));

% --- PSTH parameters ---
win_ms   = 100;
win_samp = round(win_ms * sr / 1000);   % 4000 samples
bin_ms   = 1;
bin_samp = round(bin_ms * sr / 1000);   % 40 samples per bin
n_bins   = (2 * win_ms) / bin_ms;       % 200 bins

psth_counts = zeros(1, n_bins);
n_trials    = 0;

for i = 1:length(puff_onset_idx)
    onset = puff_onset_idx(i);
    
    if onset - win_samp < 1 || onset + win_samp > length(spk)
        continue
    end
    
    segment = spk(onset - win_samp : onset + win_samp - 1);
    
    for b = 1:n_bins
        bs = (b-1) * bin_samp + 1;
        be = b * bin_samp;
        psth_counts(b) = psth_counts(b) + sum(segment(bs:be));
    end
    
    n_trials = n_trials + 1;
end

% Normalize to spikes/s
psth_fr = psth_counts / (n_trials * (bin_ms / 1000));
t_psth  = linspace(-win_ms, win_ms - bin_ms, n_bins);

% --- Latency to peak ---
[peak_fr, peak_bin] = max(psth_fr);
latency_ms = t_psth(peak_bin);
fprintf('Latency to peak response: %.1f ms\n', latency_ms);
fprintf('Peak firing rate: %.1f spikes/s\n', peak_fr);

% --- Plot ---
figure;
bar(t_psth, psth_fr, 1, 'FaceColor', [0.27 0.51 0.71], 'EdgeColor', 'none');
hold on;
xline(0,          'r--', 'LineWidth', 1.8, 'Label', 'Air puff onset');
xline(latency_ms, 'Color', [1 0.6 0], 'LineStyle', ':', 'LineWidth', 1.5, ...
      'Label', sprintf('Peak latency = %.0f ms', latency_ms));
xlabel('Time relative to air puff onset (ms)');
ylabel('Firing rate (spikes/s)');
title('PSTH: Spiking response to air puff (whisker deflection)');
xlim([-100 100]);
legend('Firing rate', 'Air puff onset', 'Peak latency');