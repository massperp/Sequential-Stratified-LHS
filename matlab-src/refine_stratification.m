function strataNew = refine_stratification(strataOld, splitStrat, splitDim)

% Generate a new stratification strataNew based on an existing stratification strataOld
% where stratum number splitStrat is divivided into two across dimension
% splitDim

% INPUTS
% strataOld: structure for existing stratification
% splitStrat: index of stratum to split
% splitDim: random dimension to split

% OUTPUTS
% strataNew: structure for refined stratification

numStrat = length(strataOld);
% Perform the splitting
split_pt = (strataOld{splitStrat}.a(splitDim) + strataOld{splitStrat}.b(splitDim))/2;

% Initialize stratum 1
stratum_1.a = strataOld{splitStrat}.a;
stratum_1.b = strataOld{splitStrat}.b;
stratum_1.b(splitDim) = split_pt;
stratum_1.p = strataOld{splitStrat}.p/2;

% Initialize stratum 2
stratum_2.a = strataOld{splitStrat}.a;
stratum_2.b = strataOld{splitStrat}.b;
stratum_2.a(splitDim) = split_pt;
stratum_2.p = strataOld{splitStrat}.p/2;


% New stratification
strataNew = strataOld;
strataNew(splitStrat) = [];
strataNew{numStrat} = stratum_1;
strataNew{numStrat+1} = stratum_2;
