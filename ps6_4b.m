%% Problemset 6
%  Problem 4 - Part b


trial_num = 81;   % 81st reach trial

%% Step 1: 
% FR_81: (n_angles x n_neurons)
FR_81 = zeros(n_angles, n_neurons);

for k = 1:n_angles
    spikes   = trial(trial_num, k).spikes;          % 98 x T
    T        = size(spikes, 2);
    win_e    = min(win_end, T);                    
    FR_81(k, :) = sum(spikes(:, win_start:win_e), 2)' / win_dur_s;
end

% r0 = FR - M  (mean-subtracted firing rate)
r0 = FR_81 - M_all;    

%% Step 2: 
% PV = sum over neurons of r0_i * [cos(phi_i), sin(phi_i)]
% Each neuron votes for its preferred direction, weighted by r0

PV = zeros(n_angles, 2);   % x and y components for each direction

for k = 1:n_angles
    r0_k     = r0(k, :);                       % 1 x n_neurons
    PV(k, 1) = sum(r0_k .* cos(phi_all));      % x component
    PV(k, 2) = sum(r0_k .* sin(phi_all));      % y component
end

%% Step 3: 
est_rad = atan2(PV(:, 2), PV(:, 1));           % radians
est_deg = mod(est_rad * 180/pi, 360);           % degrees, wrapped to [0 360]

fprintf('\n--- Trial 81 Population Vector Estimates ---\n');
fprintf('%-20s %s\n', 'Actual Direction', 'Estimated Direction');
fprintf('%-20s %s\n', '----------------', '-------------------');
for k = 1:n_angles
    fprintf('  %6.0f deg          →     %6.1f deg\n', angles_deg(k), est_deg(k));
end