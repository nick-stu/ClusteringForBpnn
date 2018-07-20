function [TreeNodeArray] = CreateTree(Data,Label)
%
%  特征选择树：
%       输入
%           Data + Label
%       输出
%           树的头结点
%
        TreeNodeArray = [];
        headNode = FeatureTreeNode;
        headNode.Nodedata.data = Data;
        headNode.Nodedata.label = Label;
        type = tabulate(headNode.Nodedata.label);
        type = type(:,2);
        headNode.Nodedata.Rate = (type/sum(type))' * (log(type/sum(type)));
        
        queue = [headNode];
        TreeNodeArray = [headNode];
        while isempty(queue) == 0
            tmp = queue(1);
            queue(1) = [];
            TreeNodeArray(size(TreeNodeArray,2)).child = CreateNode(tmp);
            tmp = TreeNodeArray(size(TreeNodeArray,2)).child;
            TreeNodeArray = [TreeNodeArray,tmp(1),tmp(2)];
            if tmp(1).Rate ~= 0 
                queue = [queue,tmp(1)];
            end
            if tmp(2).Rate ~= 0
                queue = [queue,tmp(2)];
            end
        end
        
        
end