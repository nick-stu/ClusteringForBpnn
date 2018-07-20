function [ weight ] = reliefFscore( data, label, k)
[~,weight] = relieff(data,label,k);
low = abs(min(weight));
weight = weight + 2*low;
end