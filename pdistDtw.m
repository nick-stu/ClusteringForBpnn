function [disMat] = pdistDtw(data1,data2)
    if nargin==1 
        disMat=[];
        for i=1:size(data1,1)
           for j=i+1:size(data1,1)
               disMat=[disMat dtw( data1(i,:), data1(j,:) )];
           end
        end
    elseif nargin==2
        disMat=zeros(size(data1,1), size(data2,1));
        for i=1:size(data1,1)
            for j=1:size(data2,1)
                disMat(i,j)=dtw(data1(i,:), data2(j,:));
            end
        end
    end
end