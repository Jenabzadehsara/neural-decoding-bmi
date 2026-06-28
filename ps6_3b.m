sr = 40000;
ag = 1000;

n = length(vout);
t = (0:n-1) / sr;
v = vout / ag;

% --- Spike detection (3*std threshold from Part a) ---
threshold    = 3 * std(v);
thresh       = v > threshold;
d_thresh     = diff(thresh);
spk          = zeros(size(t));
spk(1:end-1) = d_thresh > 0;

spike_idx = find(spk == 1);   % indices of all spike onsets

% --- Window parameters ---
pre_ms  = 0.5;                             % 0.5ms before spike
post_ms = 1.0;                             % 1.0ms after spike
pre_samp  = round(pre_ms  * sr / 1000);   % 20 samples before
post_samp = round(post_ms * sr / 1000);   % 40 samples after
win_size  = pre_samp + post_samp + 1;     % 61 samples total per waveform

% Time axis for each waveform in ms
t_wave = linspace(-pre_ms, post_ms, win_size);   % -0.5ms to 1ms

% waveform matrix ---
% Each Row = one spike waveform
n_spikes     = length(spike_idx);
waveforms    = zeros(n_spikes, win_size);  % n_spikes x 61 matrix

valid        = 0;    % count of spikes with full window inside recording
valid_idx    = [];   % track which spikes are valid

for i = 1:n_spikes
    s = spike_idx(i);               % sample index of this spike

    % Skip if window goes outside recording bounds
    if s - pre_samp < 1 || s + post_samp > n
        continue
    end

    valid = valid + 1;
    waveforms(valid, :) = v(s - pre_samp : s + post_samp);
    valid_idx(end+1)    = i;
end

% Trim unused rows
waveforms = waveforms(1:valid, :);
fprintf('Total spikes: %d | Valid waveforms: %d\n', n_spikes, valid);

% --- Plot all waveforms superimposed ---
figure;
plot(t_wave, waveforms', 'Color', [0.2 0.5 0.8 0.1]);  % transparent blue
hold on;
plot(t_wave, mean(waveforms, 1), 'r', 'LineWidth', 2);  % mean waveform in red
xline(0, 'k--', 'LineWidth', 1.2, 'Label', 'Spike onset');
xlabel('Time relative to spike onset (ms)');
ylabel('Voltage (V)');
title(sprintf('Spike Waveforms (n = %d)', valid));
legend('Individual waveforms', 'Mean waveform');
grid on;

