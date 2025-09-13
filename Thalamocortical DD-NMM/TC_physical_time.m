function [param] = TC_physical_time(param)

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

%% Basic constants for real physical time simulation and integration (2.1	General model formulation)

% Inputs
% param: parameters from "model_param"

% Outputs
% taumax: maximum of the lag distribution
% Tmax: total simulation time
% h: integration step in seconds
% Nseg: number of segmnets for spectral analysis 
% nu_max: maximum frequency for analysis
% nu_min: minimum frequency for analysis

%% Defining physical time values (Table 3)
h       = 0.001; % 0.01E-3; % h(seconds) 
param.physical_time.h       = h; 

Tmax    = 20; % 4; % Tmax(seconds)
param.physical_time.Tmax    = Tmax; 

Nt      = floor(Tmax/h); % Number of time points in the simulation
param.physical_time.Nt      = Nt;

tspan   = (1:1:Nt)*h; % Phisical time linear space 
param.physical_time.tspan   = tspan;

Nseg    = 6; % 10; % integer 
param.physical_time.Nseg    = Nseg;

nu_max  = 50; %i n (Hz) 
param.physical_time.Fmax    = nu_max;

nu_min  = 0.1; % in (Hz) 
param.physical_time.Fmin    = nu_min;
end