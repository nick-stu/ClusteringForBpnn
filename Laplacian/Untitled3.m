%  	Usage:
%  	[Y] = LaplacianScore(X, W)
%  
%  	X: Rows of vectors of data points
%  	W: The affinity matrix.
%  	Y: Vector of (1-LaplacianScore) for each feature.
%        The features with larger y are more important.
%  
%      Examples:
 https://www.cnblogs.com/chend926/archive/2012/05/21/2511670.html
        fea = testData;
        options = [];
        options.Metric = 'Cosine';
        options.NeighborMode = 'KNN';
        options.k = 200;
        options.WeightMode = 'Cosine';
        W = constructW(fea,options);
 
        LaplacianScore = LaplacianScore(fea,W);
        [junk, index] = sort(-LaplacianScore);
        
        newfea = fea(:,index);
        %the features in newfea will be sorted based on their importance.
 
%  	Type "LaplacianScore" for a self-demo.
%  
%   See also constructW
%  
%  Reference:
%  
%     Xiaofei He, Deng Cai and Partha Niyogi, "Laplacian Score for Feature Selection".
%     Advances in Neural Information Processing Systems 18 (NIPS 2005),
%     Vancouver, Canada, 2005.   
%  
%     Deng Cai, 2004/08