%%%% THALAMOCORTICAL SIMULATION %%%%%%

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


%% General simulation parameters 
param  = struct;
param  = TC_physical_time(param);

%% Alpha rhythm intrinsic parameters
alpha_inhibitory  = 10E-3;
alpha_excitatory = 20E-3;

%% Prepare parameters for model simulation
param   = TC_parameters(param); 
param   = TC_response_param(param,alpha_inhibitory,alpha_excitatory);    %Thalamo-cortical JR-Nm
param   = TC_LL_jacobian_expm(param);    % Jacobian matrix exponential
param   = TC_distributed_delay(param);
param   = TC_distributed_connectome_tensor(param);

%% Burn-in and Run-in
Nm = param.jansen_and_rit.neural_mass.Nm;
Nt     = param.physical_time.Nt;
Ntau   = param.connectivity_tensor.Ntau ;
Y_init = zeros(Nm,Ntau);
X_init = zeros(Nm,Ntau);
Z_init = zeros(Nm,Ntau);
tic 
for j=1:2
    [X,Y,Z] = TC_LL_integration(param,Y_init,X_init,Z_init);
    Y_init  = Y(:,end-Ntau+1:end);
    X_init  = X(:,end-Ntau+1:end);
    Z_init  = Z(:,end-Ntau+1:end);
end
[figures]   = TC_model_plot(Z,param);
toc