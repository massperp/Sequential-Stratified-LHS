function stratum = stratum_LHS_allocation(stratum, N_samp, f, numDim)

% Allocation of samples to existing hyperrectangular stratum

% INPUTS
% stratum: hyperrectangular stratum structure where samples will be added   
% N_samp: number of LHS samples to be allocated
% f: hanfle to the test function
% numDim: number of random dimensions (assumes uniform distribution)

% OUTPUTS
% stratum: the input stratum structure updated with new LHS samples

local_stratum_samples = stratum.a'+lhsdesign(N_samp, numDim)*diag(stratum.b-stratum.a);
stratum.samples = local_stratum_samples;
local_stratum_f_samples = f(local_stratum_samples);
stratum.f_samples = local_stratum_f_samples;
stratum.N = size(local_stratum_f_samples,1);
stratum.mean = mean(local_stratum_f_samples);
stratum.sigma = std(local_stratum_f_samples);