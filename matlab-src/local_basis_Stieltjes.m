function [basisFun] = local_basis_Stieltjes(pdf,a,b,order)

% Generate generalized Polynomial Chaos basis functions for a single
% dimension using Stieltjes procedure

% INPUTS
% pdf: function handle to continuous probability density function on interval [a, b]
% a: lower bound on domain of pdf
% b: upper bound on domain of pdf
% order: maximum order of basis polynomials

% OUTPUTS
% basisFun: cell array with handles to the order+1 basis functions

basisFun = cell(1,order+1);
basisFun{1} = @(xi) xi.^0;

beta(1) = 1;%quad(@(xi) pdf(xi),a,b);
alpha(2) = quad(@(xi) pdf(xi).*xi,a,b);
basisFun{2} = @(xi) xi-alpha(2);
beta(3) = sqrt(quad(@(x) pdf(x).*basisFun{2}(x).^2,a,b));
basisFun{2} = @(xi) basisFun{2}(xi)/beta(3);

for k=3:order+1
    alpha(k) = quad(@(xi) pdf(xi).*xi.*basisFun{k-1}(xi).^2,a,b);
    basisFun{k} = @(xi) (xi-alpha(k)).*basisFun{k-1}(xi)-beta(k)*basisFun{k-2}(xi);
    beta(k+1) = sqrt(quad(@(xi) pdf(xi).*basisFun{k}(xi).^2,a,b));%/ quad(@(xi) pdf(xi).*basisFun{k-2}(xi).^2,a,b) ;
    basisFun{k} = @(xi) basisFun{k}(xi)/beta(k+1);%sqrt(quad(@(x) pdf(x).*basisFun{k}(x).^2,a,b));
end
