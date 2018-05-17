function [ label ] = GenerateNNLabel( sampleNum )
%   GenerateNNLabel
%   Detailed explanation goes here
    label = zeros(sampleNum, 9);
    for i=1:9
        for j=1:sampleNum / 9
            label((i - 1) * sampleNum / 9 + j, i) = 1;
        end
    end
end

