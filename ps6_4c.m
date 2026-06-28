%% Problemset 6
% Problem 4 - Part c

test_trials  = 81:100;              % trials 81 to 100
n_test       = length(test_trials); % 20 trials
all_errors   = zeros(n_test, n_angles);  % store angular error per trial per direction

for ti = 1:n_test
    trial_num = test_trials(ti);

    % Firing rate for this trial (n_angles x n_neurons)
    FR_test = zeros(n_angles, n_neurons);
    for k = 1:n_angles
        spikes = trial(trial_num, k).spikes;
        T      = size(spikes, 2);
        win_e  = min(win_end, T);
        FR_test(k, :) = sum(spikes(:, win_start:win_e), 2)' / win_dur_s;
    end

    % Step 1: 
    r0 = FR_test - M_all;   % (n_angles x n_neurons)

    % Step 2: 
    PV = zeros(n_angles, 2);
    for k = 1:n_angles
        r0_k     = r0(k, :);
        PV(k, 1) = sum(r0_k .* cos(phi_all));   % x component
        PV(k, 2) = sum(r0_k .* sin(phi_all));   % y component
    end

    % Estimated direction 
    est_rad = atan2(PV(:, 2), PV(:, 1));         % 8x1 in radians

    % Angular error: actual = target direction (perfect accuracy assumed)
    actual_rad         = angles_rad(:);           % 8x1 in radians
    all_errors(ti, :)  = abs(my_angdiff(actual_rad, est_rad));  % 8x1 in radians
end

%% Mean directional error across all 160 reaches (20 trials x 8 directions)
mean_error_rad = mean(all_errors(:));
mean_error_deg = mean_error_rad * 180/pi;

fprintf(['Mean directional error over 160 reaches (trials 81-100): ' ...
    '%.2f degrees\n'], mean_error_deg);
