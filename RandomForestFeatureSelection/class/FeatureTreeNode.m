classdef FeatureTreeNode
    
    properties
        Demension                   %���ݵڼ�ά����
        Value                           %ȡֵ
        Nodedata                    %��������--�ṹ�塣���нṹ��Ϊ��label ��data[]��
        Method="entropy"        %Ĭ�����۱�׼Ϊ��Ϣ��
        Rate                            %��������ֵ
        child                           %���ĺ��ӽ��
    end
    
    methods
        function [node] = CreateNode (parentNode)

            node(1) = FeatureTreeNode;
            node(2) = FeatureTreeNode;
            Dnum = size(parentNode.Nodedata.data,2);%����ܵ�ά��
            Drates = [];
            Dvalues = [];
            DEntro = [];
            parfor i = 1:Dnum
                Vars = tabulate(parentNode.Nodedata.data(:,i));%�ҵ���iά���е�ȡֵ
                Vars = Vars(:,1);
                Vars = sort(Vars,1);%ȡֵ������
                
                Entro = [];
                SubValues = [];
                for j = 1:(size(Vars,1)-1)
                    tmpValue = (Vars(j+1)  + Vars(j))/2;
                    %������ڵ��ڵ�����
                    index = find(parentNode.Nodedata.data(:,i) >= tmpValue);
                    Ltype = tabulate(parentNode.Nodedata.label(index));
                    Ltype = Ltype(:,2);
                    Entro1 = 0;
                    if parentNode.Method == "entropy"
                        Entro1 = (Ltype/sum(Ltype))' * (log(Ltype/sum(Ltype)));
                    end
                    %����С�ڵ�����
                    index = find(parentNode.Nodedata.data(:,i) < tmpValue);
                    Ltype = tabulate(parentNode.Nodedata.label(index));
                    Ltype = Ltype(:,2);
                    Entro2 = 0;
                    if parentNode.Method == "entropy"
                        Entro2 = (Ltype/sum(Ltype))' * (log(Ltype/sum(Ltype)));
                    end
                    Psize = size(parentNode.Nodedata.label,2);
                    size(index,1);
                    centro = -(Psize-size(index,1))/Psize*Entro1-size(index,1)/Psize*Entro2;
                    Entro(j) = centro;
                    SubValues(j) = tmpValue;
                     
                end
                
                if(norm(SubValues,2) == 0)   
                    Dvalues(i) = inf;
                    DEntro(i) = inf;
                else
                    kk =find(Entro == min(Entro));
                    Dvalues(i) = SubValues(kk(1));
                    DEntro(i) = min(Entro);
                end
            end
            
            
            i = find(DEntro == min(DEntro));
            i = i(1);
            node(1).Demension = i;
            node(2).Demension = i;
            tmpValue = Dvalues(i);
            node(2).Value = tmpValue;
            node(1).Value = tmpValue;
            %������ڵ��ڵ�����
            index = find(parentNode.Nodedata.data(:,i) >= tmpValue);
            Ltype = tabulate(parentNode.Nodedata.label(index));
            Ltype = Ltype(:,2);
            Entro1 = 0;
            if parentNode.Method == "entropy"
                Entro1 = (Ltype/sum(Ltype))' * log(Ltype/sum(Ltype));
            end
            node(1).Rate = Entro1;
            node(1).Nodedata.label = parentNode.Nodedata.label(index);
            node(1).Nodedata.data = parentNode.Nodedata.data(index,:);
            %����С�ڵ�����
            index = find(parentNode.Nodedata.data(:,i) < tmpValue);
            Ltype = tabulate(parentNode.Nodedata.label(index));
            Ltype = Ltype(:,2);
            Entro2 = 0;
            if parentNode.Method == "entropy"
                Entro2 = (Ltype/sum(Ltype))' * log(Ltype/sum(Ltype));
            end
            node(2).Rate = Entro2;
            node(2).Nodedata.label = parentNode.Nodedata.label(index);
            node(2).Nodedata.data = parentNode.Nodedata.data(index,:);
      %     type = min(parentNode.Nodedata.label):max(parentNode.Nodedata.label);
            
            
        end
    end
end
