function [ weight ] = reliefFscore( data, label )
[~,weight] = relieff(data,label,10);
low = abs(min(weight));
weight = weight + 2*low;
weight = weight.*5;
end