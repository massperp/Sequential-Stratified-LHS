function weightedEst = var_weighted_estimator(meanEst, varEst, numEstimators)

% Compute variance weighted estimator from sequence of mean estimators

% INPUTS
% meanEst: vector of mean estimates
% varEst: vector of variance estimates (of mean estimators)
% numEstimators: number of estimators

% OUTPUTS
% weightedEst: variance weighted estimator (scalar)

D_inv = diag(1./varEst(1:end-1));
b = varEst(end)*ones(numEstimators-1,1);
w = (D_inv - varEst(end)*D_inv*ones(numEstimators-1)*D_inv/(1+varEst(end)*ones(1,numEstimators-1)*D_inv*ones(numEstimators-1,1)))*b;
w = [w; 1-sum(w)];

weightedEst = meanEst*w;