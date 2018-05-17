function[result]=md(data)
% 该函数可用于求行向量平均差
M=mean(data);
data=data-M;
data=abs(data);
result=mean(data(:));
end