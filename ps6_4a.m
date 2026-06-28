%% Problemset 6
%  Problem 4 - Part a

% Data dimensions
n_neurons = 98;
n_trials  = 80;
n_angles  = 8;

%  Firing rate window 
win_start = 50;
win_end   = 550;
win_dur_s = (win_end - win_start) / 1000;   % 0.5 seconds

% Firing rate matrix (n_trials x n_angles x n_neurons) 
FR = zeros(n_trials, n_angles, n_neurons);

for k = 1:n_angles
    for ni = 1:n_trials
        spikes = trial(ni, k).spikes;   % 98 x T
        FR(ni, k, :) = sum(spikes(:, win_start:win_end), 2) / win_dur_s;
    end
end
fprintf('FR matrix: %d trials x %d angles x %d neurons\n', n_trials, n_angles, n_neurons);

% Reaching angles 
angles_deg = [30, 70, 110, 150, 190, 230, 310, 350];
angles_rad = angles_deg * pi / 180;

%  Step 2: 
mean_FR = squeeze(mean(FR, 1));   % n_angles x n_neurons

A_all   = zeros(1, n_neurons);
phi_all = zeros(1, n_neurons);
M_all   = zeros(1, n_neurons);
r2_all  = zeros(1, n_neurons);

for i = 1:n_neurons
    r = mean_FR(:, i);   % 8x1
    [~, r2_all(i), A_all(i), phi_all(i), M_all(i)] = ...
        my_fit_cos_tune(angles_rad(:), r(:));   % force column vectors
end

% Step 3: 
neuron = 27;
fprintf('--- Neuron %d ---\n', neuron);
fprintf('  A   = %.2f Hz\n',      A_all(neuron));
fprintf('  Phi = %.2f degrees\n', phi_all(neuron) * 180/pi);
fprintf('  M   = %.2f Hz\n',      M_all(neuron));
fprintf('  R2  = %.4f\n',         r2_all(neuron));

% Step 4: 
theta_fine = (0:360) * pi / 180;
rhat_fine  = A_all(neuron) * cos(theta_fine - phi_all(neuron)) + M_all(neuron);

figure;
plot(theta_fine * 180/pi, rhat_fine, 'r-', 'LineWidth', 2);
hold on;
plot(angles_deg, mean_FR(:, neuron), 'bo', ...
     'MarkerSize', 8, 'MarkerFaceColor', 'b');
xlabel('Reaching Direction (degrees)');
ylabel('Firing Rate (spikes/s)');
title(sprintf('Cosine Tuning Curve — Neuron %d', neuron));
legend('Cosine fit', 'Mean FR (data)');
xticks(angles_deg);
xlim([0 360]);
grid on;

