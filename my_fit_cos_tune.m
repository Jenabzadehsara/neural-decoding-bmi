function [rhat r2 A phi M stats] = my_fit_cos_tune(theta,r)
% fit a sine wave using linear regression
%y = a*cos(2*pi*F0*t) + b*sin(2*pi*F0*t) + M;
%  = A*cos(2*pi*F0*t - phi) + M, where A = sqrt(a^2 + b^2), phi = -atan(a/b);

F0 = 1/(2*pi);

X = [ones(size(theta)) cos(2*pi*F0*theta) sin(2*pi*F0*theta)];
beta = X\r; % linear regression
M = beta(1); a = beta(2); b = beta(3);
A = sqrt(a^2 + b^2);
phi = -atan2(-b,a);

rhat = A*cos(2*pi*F0*theta - phi) + M;


SSE = sum((r-rhat).^2);
SST = sum((r-mean(r)).^2);
r2 = 1-SSE/SST;

% get significance
Xsig = [cos(2*pi*F0*theta) sin(2*pi*F0*theta)];
stats = regstats(r,Xsig);
