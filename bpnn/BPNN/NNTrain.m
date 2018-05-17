function [ net ] = NNTrain( trainData, trainLabel )
% 训练神经网络
%   trainData: 每行一个样本数据
%   trainLabel: 每行一个样本标签，每行九列
    % 创建神经网络
    net = newff(minmax(trainData'), [140 9], {'logsig', 'logsig'}, 'traingdx');
    % net =  newff(minmax(trainData'), [100 100 9], {'logsig', 'logsig', 'logsig'}, 'traingdx');
    % net =  newff(minmax(trainData'), [100 100 100 9], {'logsig', 'logsig', 'logsig', 'logsig'}, 'traingdx');

    %设置训练参数
    net.trainparam.show = 1;
    net.trainparam.epochs = 1000;
    net.trainparam.goal = 0.001;
    net.trainParam.lr = 0.01;
%     net.performFcn = 'msereg';
    net.performParam.regularization = 0.05;

    %开始训练
    net = train( net, trainData', trainLabel' );
    
end

