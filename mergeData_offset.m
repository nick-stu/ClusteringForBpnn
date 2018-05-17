function [data]=mergeData_offset(data1,data2,data3,data4,data5)
rows = size(data1, 1);
singleNum = rows / 9;
data=[];
for i=1:9
        data=[data; data1((i-1)*singleNum+1:i*singleNum,:)];
        data=[data; data2((i-1)*singleNum+1:i*singleNum,:)];
        data=[data; data3((i-1)*singleNum+1:i*singleNum,:)];
        data=[data; data4((i-1)*singleNum+1:i*singleNum,:)];
        data=[data; data5((i-1)*singleNum+1:i*singleNum,:)];
end
