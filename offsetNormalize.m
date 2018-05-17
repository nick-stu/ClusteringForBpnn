function [X_norm] = offsetNormalize(X)
minMat=min(X);
maxMat=max(X);
deMat=maxMat-minMat;
X_norm = bsxfun(@minus, X, minMat);
X_norm = bsxfun(@rdivide, X_norm, deMat);
end