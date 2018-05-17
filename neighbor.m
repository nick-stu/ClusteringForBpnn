function[pts]=neighbor(data,num,p,E)
    center=data(p,:);
    pts=[];
    for i=1:num
        pt=data(i,:);
        distance=pdist2(center,pt);
        if distance<=E
            pts=[pts i];
        end
    end
end