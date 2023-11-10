function basisFun = multi_dim_basis(pdfGlobal, stratum, numDim, maxPolynOrder)

% Generate one-dimensional generalized Polynomial Chaos basis functions for
% numDim random variables

% INPUTS
% pdfGlobal: cell array with function handles to one-dimensional pdf for
% the full random domain
% stratum: structure for hyperrectangular stratum 
% numDim: number of random dimensions
% maxPolynOrder: maximum order of polynomial basis functions

% OUTPUTS
% cell array with handles to generalized Polynomial Chaos basis functions

basisFun = cell(numDim,1);
for indDim = 1:numDim
    pdf = @(y) pdfGlobal{indDim}(y)/(stratum.b(indDim)-stratum.a(indDim));
    basisFun{indDim} = local_basis_Stieltjes(pdf,stratum.a(indDim),stratum.b(indDim),maxPolynOrder);
end
