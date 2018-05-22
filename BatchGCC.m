function [ dataOut ] = BatchGCC( data )
    [num,len] = size(data);
    x = randperm(num,1);
    
    dataBase = data(x,:);
    dataOut = [];
    for i = 1:num
        if i == x
            dataOut = [ dataOut;dataBase ];
            continue;
        end
        data_p = data(i,:);
        m_max = 0;
        offset = 0;
        for j = 1:len
            temp = [data_p(j + 1:end) data_p(1:j)];
            m = sum(temp .* dataBase);
            if m > m_max
                m_max = m;
                offset = j;
            end
        end
        data_p = [data_p(offset + 1:end) data_p(1:offset)];        
        dataOut = [dataOut;data_p];
    end
end