# ClusteringForBpnn
主要文件如下：

clustering_offset_nearest,聚类函数

offsetAllMain，计算精度的主函数，计算的为五种偏移类型混合在一起，得出的精度，mode设为old时，精度为不聚类的情况；设mode为new时，精度为聚类的情况

getLabelsNew，函数分为两部分，一部分为人工聚类，一部分为现有聚类（根据需要 选择性的注释掉一半）

loadOffsetData，分别装载五个人的一个键五种偏移类型数据，进行聚类，PCA，MDS等画图，或查看密度情况等
