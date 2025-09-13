function[X,Y,Z] = TC_LL_integration(param,Y_init,X_init,Z_init)

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

%% Obtains time series by LL integration of the neural masses of the NMM (Section 2.2	Model for a single neural mass and algebraic integration)
 
% Inputs
% param: parameters from "model_param", "physical_time_constants",
% "model_LL_jacobian_expm" and "model_response_param"

% Outputs
% Y (Nm x Nt): time series
% X (Nm x Nt): its derivative
% Z (Nm x Nt):  algebraic term

%% Parameters
Nm = param.jansen_and_rit.neural_mass.Nm;
% Ncc    = param.neural_mass.Ncc;   
Nt     = param.physical_time.Nt;
Ntau   = param.connectivity_tensor.Ntau;
% tspan  = param.physical_time.tspan;
K      = param.connectivity_tensor.K ;
% C    = param.jansen_and_rit.connectivity_matrix.C ;
v0     = param.jansen_and_rit.sigmoid.v0;
a0     = param.jansen_and_rit.sigmoid.a0;
e0     = param.jansen_and_rit.sigmoid.e0;
A      = param.jacobian_expm.A;
B      = param.jacobian_expm.B;
miu    = param.jansen_and_rit.stochastic_inputs.miu;
sigma  = param.jansen_and_rit.stochastic_inputs.sigma;
%% Initialization 
% dw_obj        = dsp.ColoredNoise(-2,Nt,Nm_pop,'OutputDataType','single');
% dw            = dw_obj();
% dw            = repmat(miu,Ncc,Nt) + repmat(sigma,Ncc,Nt).*dw';
miu     = repmat(miu,1,Nt);
sigma   = repmat(sigma,1,Nt);

% noise_amplitude = 3; % Adjust based on desired variability
% noise = noise_amplitude * randn(1);
dw         = normrnd(miu,sigma);

Y            = zeros(Nm,Nt);
X            = zeros(Nm,Nt);
Z            = zeros(Nm,Nt);
Y(:,1:Ntau) = Y_init;
X(:,1:Ntau) = X_init;
Z(:,1:Ntau) = Z_init;
%% Local Linearization integration of a single unit (Equation 7 and 8)
hfig = waitbar(0,'generating model wait...');
for time =  (Ntau+1):Nt
    waitbar(time/Nt) 
    %% Z-update
    Z(:,time)  = TC_LL_z_outputs(Y(:,time-1:-1:time-Ntau),K);  % Equation 24
    z_dif      = Z(:,time) - Z(:,time-1); 
    %% dw-update
    % noise_amplitude = 3; % Adjust based on desired variability
    % noise = noise_amplitude * randn(1);
    % modulation = 1 + 0.2 * sin(2 * pi * 0.1 * tspan(time)); % Slow 0.1 Hz modulation
    % dw         = normrnd(miu, sigma).*modulation + noise;
    dw_dif   = dw(:,time) - dw(:,time-1);
       %% Y-X-Update
    [Y(:,time), X(:,time)]= TC_LL_iteration(Y(:,time-1),X(:,time-1),Z(:,time),z_dif,dw(:,time),dw_dif,v0,a0,e0,A,B,Nm);
end
   
close(hfig)
end

