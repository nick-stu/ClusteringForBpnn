function[]=MDStest(data)
data=MDS(data,3);

figure;
for i=1:60
    if i<=30
        scatter3(data(i,1),data(i,2),data(i,3), 150,'y','filled');hold on;
    else
        scatter3(data(i,1),data(i,2),data(i,3), 150,'m','filled');
    end
end
title('MDS based on offset type');
end