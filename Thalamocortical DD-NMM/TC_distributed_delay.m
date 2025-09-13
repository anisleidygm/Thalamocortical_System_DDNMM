function param = TC_distributed_delay(param)

% ========================================================================
% Thalamocortical System Simulation with Distributed-Delay Neural Mass Model
% (DD-NMM)
%
% Description:
%   This script/function is part of the implementation of a thalamocortical
%   neural mass model with distributed axonal delays, as described in:
%
%   González-Mitjans, A., Paz-Linares, D., López-Naranjo, C., Areces-González, A.,
%   Li, M., Wang, Y., García-Reyes, R., Bringas-Vega, M.L., Minati, L.,
%   Evans, A.C., Valdés-Sosa, P.A. (2023).
%   Accurate and Efficient Simulation of Very High-Dimensional Neural Mass Models 
%   with Distributed-Delay Connectome Tensors.
%   NeuroImage, 274: 120137. https://doi.org/10.1016/j.neuroimage.2023.120137
%
% Repository:
%   Thalamocortical System Simulation with DD-NMM
%   https://github.com/anisleidygm/Thalamocortical_System_DDNMM
%
% License:
%   This code is released under the MIT License.
%   See the LICENSE file in the repository root for details.
%
% Please cite the paper above AND this repository if you use this code in
% your research.
%
% ========================================================================

%% Build a distributed-delay tensor D via a single-peak Nunez-type function.

% Inputs:
%   param.jansen_and_rit.neural_mass.Nm  : number of cortical columns (nodes)
%   param.jansen_and_rit.connectivity_matrix.C : Nm x Nm connectivity (optional mask)
%   param.physical_time.h                : integration step (s)

% Outputs stored in param.connectivity_tensor:
%   tau (1 x Ntau), Ntau (scalar), D (Nm x Nm x Ntau)

%% --- Load parameters
Nm  = param.jansen_and_rit.neural_mass.Nm;
C   = param.jansen_and_rit.connectivity_matrix.C;   % expected Nm x Nm
h   = param.physical_time.h;

%% --- Distances and Nunez parameters
large_dist = 0.15;       % meters (long-range)
short_dist = 75.38e-3;   % meters (short-range)

n = 4.5;                 % Nunez "peak" parameter
a = 0.6;                 % Nunez "width" parameter

%% --- Delay axis
tau  = h:h:1;            % seconds
Ntau = numel(tau);

%% --- Single-peak kernel (note: this is your chosen form)
% If you intended the classic Nunez form ~ (d/tau)^(n) * exp(-a*d/tau) / tau^2
% you can swap to that below; here we keep your current choice but consistent.
cv = (tau.^n .* exp(-a.*tau) .* tau.^2) * h;   % 1 x Ntau

% Build normalized short/long delay distributions
sr_delay = short_dist ./ cv;     % 1 x Ntau
sr_delay(1) = 0;                 % avoid peak at 0-lag
sr_delay = sr_delay / sum(sr_delay);

lr_delay = large_dist ./ cv;     % 1 x Ntau
lr_delay(1) = 0;
lr_delay = lr_delay / sum(lr_delay);

% Shapes for broadcasting
SR = reshape(sr_delay, 1, 1, Ntau);
LR = reshape(lr_delay, 1, 1, Ntau);

%% --- Initialize D with long-range profile everywhere
D = repmat(LR, Nm, Nm, 1);

%% --- Apply short-range profile to ring neighbors (±1 and ±2)
circ = @(x) 1 + mod(x-1, Nm);  % single-arg circular index in [1..Nm]

for i = 1:Nm
    j1 = circ(i-1);
    j2 = circ(i-2);
    j3 = circ(i+1);
    j4 = circ(i+2);

    % i <- neighbors
    D(i, j1, :) = SR;
    D(i, j2, :) = SR;
    D(i, j3, :) = SR;
    D(i, j4, :) = SR;

    % neighbors <- i  (if you want symmetry)
    D(j1, i, :) = SR;
    D(j2, i, :) = SR;
    D(j3, i, :) = SR;
    D(j4, i, :) = SR;
end

%% --- Optional: zero out where C has no connection (mask)
% Ensure C is logical mask (1 = keep, 0 = remove). Keep diagonal if needed.
M = C ~= 0;
D = D .* repmat(M, 1, 1, Ntau);

%% --- Save
param.connectivity_tensor.tau  = tau;
param.connectivity_tensor.Ntau = Ntau;
param.connectivity_tensor.D    = D;
end
