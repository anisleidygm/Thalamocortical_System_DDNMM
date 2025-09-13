function param = TC_distributed_connectome_tensor(param)

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

%% Construction of the distributed-delay Connectome Tensor (Section 2.1 General model formulation. Equation 3)

% Inputs 
% param: parameters from "model_param" and probability density

% Outputs
% K (Nm x Nm x Ntau): distributed-delay Connectome tensor

%% Loading Parameters
Nm      = param.jansen_and_rit.neural_mass.Nm;
Ntau    = param.connectivity_tensor.Ntau;
D       = param.connectivity_tensor.D;
C       = param.jansen_and_rit.connectivity_matrix.C;

%% Conforming Sparse Connectome Tensor
K       = repmat(C,1,1,Ntau).*D;
K       = reshape(K,Nm,Nm*Ntau);

%% Saving parameters 
param.connectivity_tensor.K    = K;
end
