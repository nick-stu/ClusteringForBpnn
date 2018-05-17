function [ res ] = normalization( data )
%NORMALIZATION Summary of this function goes here
%   Detailed explanation goes here

maxI = max(data);
minI = min(data);
res = (data - minI) ./ (maxI - minI);

end

