function[avg,stdNum]=classStatus(data1,data2)
% classStatus   返回类或类之间的平均距离和标准差.
% Notice:       求一个类的平均距离时，请勿输入两个相同的data
% Author:       Nick
% Time:         16-Apr-2018
% Last updated date: 16-Apr-2018

%%
if nargin==1 
    total=pdist(data1);
    avg=mean(total(:));
    stdNum=std(total(:));
elseif nargin==2
    num1=size(data1,1);
    num2=size(data2,1);
    total=pdist2(data1,data2);
    avg=sum(total(:))/(num1*num2);
    stdNum=std(total(:));
    %% error
    if isequal(data1,data2)==true
        warndlg('Please do not enter two identical matrices.  from function classStatus'); 
    end
end