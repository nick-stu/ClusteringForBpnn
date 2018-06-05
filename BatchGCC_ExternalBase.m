function [ dataOut ] = BatchGCC_ExternalBase( data )
% 该函数读取外置的一个信号作为基准
    [num,len] = size(data);
    if len==73
        load('GCCBase');
    elseif len==78
        load('GCCBase2');
    end
    
    dataOut = [];
    for i = 1:num
        data_p = data(i,:);
        m_max = 0;
        offset = 0;
        for j = 1:len
            temp = [data_p(j + 1:end) data_p(1:j)];
            m = sum(temp .* GCCBase);
            if m > m_max
                m_max = m;
                offset = j;
            end
        end
        data_p = [data_p(offset + 1:end) data_p(1:offset)];        
        dataOut = [dataOut;data_p];
    end
end