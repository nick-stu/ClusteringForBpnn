function[dis]=nearestPoint(sample,classData)
    dis=pdist2(sample,classData);
    dis = min(dis(:));
end