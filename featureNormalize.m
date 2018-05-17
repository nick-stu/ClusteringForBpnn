function [X_norm] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

% 注意： 这里的X是一个m * n的矩阵， 有 m 个样本， 每个样本包含 n 个特征， 每一行表示一个样本。
% X_norm是最终得到的特征， 首先计算了所有训练样本每个特征的均值， 然后减去均值， 然后除以标准差。 
% ps：这一段不是上面的中文翻译
mu = mean(X);
X_norm = bsxfun(@minus, X, mu);

sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);
% X_norm(X_norm>=3)=0;
% X_norm(X_norm<=-3)=0;
end