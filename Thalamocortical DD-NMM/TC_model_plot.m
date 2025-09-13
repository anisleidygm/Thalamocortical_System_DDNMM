function [figures] = TC_model_plot(Y,param)

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

%% Time Series, Phase State and Power Spectral Density Plots

% Inputs
% param: parameters from "model_physical_time"

% Outputs
% figures:  time series, dynamics and spectra of the model
% peak: alpha peak values obtained from the spectra

%% Loading parameters
tspan  = param.physical_time.tspan;
tspan1 = tspan(2000:end);

Act_pyr  = Y(1,2000:end);
Act_inh  = Y(2,2000:end);
Act_ste  = Y(3,2000:end);
Act_ret  = Y(4,2000:end);
Act_tha  = Y(5,2000:end);

Act_pyr = Act_pyr'-mean(Act_pyr');
Act_inh = Act_inh'-mean(Act_inh');
Act_ste = Act_ste'-mean(Act_ste');

%% Ploting EEG signal
fig1 =  figure;
plot(tspan1,Act_pyr','b','LineWidth',1);
xlabel('time(s)')
ylabel('activation')
title('EEG simulation')

%% Ploting the NMM
fig2 = figure;
plot3(Act_pyr(2500:end),Act_inh(2500:end),Act_ste(2500:end)','b','LineWidth',1.5);

xlabel('Pyramidal cell')
ylabel('Inhibitory cell')
zlabel('Stellate cell')
title('Unit oscillatory Behavior')

%% PSD estimation

% Chronux
params.Fs     = 1000;
params.tapers = [1,2];%[6 11];
params.fpass  = [0 50];
params.pad    = 0;
params.err    = [1 0.05];
[S,f]         = mtspectrumc(Act_pyr,params);
S_mean        = mean(S,2);
fig3 = figure;
plot_vector(S_mean(10:end),f(10:end),[],[],'b',1.5);

figures = [fig1 fig2 fig3];

end
