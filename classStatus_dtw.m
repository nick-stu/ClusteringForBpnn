function[avg,stdNum]=classStatus_dtw(data1,data2)
if nargin==1 
    total=pdistDtw(data1);
    avg=mean(total(:));
    stdNum=std(total(:));
elseif nargin==2
    num1=size(data1,1);
    num2=size(data2,1);
    total=pdistDtw(data1,data2);
    avg=sum(total(:))/(num1*num2);
    stdNum=std(total(:));
    %% error
    if isequal(data1,data2)==true
        warndlg('Please do not enter two identical matrices.  from function classStatus'); 
    end
end