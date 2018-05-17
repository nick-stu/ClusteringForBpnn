function[D]=densityBasedonNeighbor(set,center,k)
    if size(set,1)<k
        D=0;
        return;
    end

    dis=pdist2(center,set);
    dis=triu(dis);
    dis=dis(dis~=0);
    dis=sort(dis);
    D=dis(1:k);
    D=sum(D(:));
end