Research is about identifying open problems/directions or fundamental phenomena — matching one
own interests and insights — that may have impact or potential impact to the world. Now the Web is at
our fingertip. We can gather information faster than ever before.
In this assignment, you will be asked to write a two-page report on one paper in the field of theoretical
computer science, particular, concerning advanced algorithm design and analysis that you find interesting.
You may want to include the following elements in your report:
1. How did you find this paper?
2. Give a brief discussion of the problem and the main result of the paper.
3. Give a brief discussion of why you find this paper interesting and result important.
4. State one major open question posted or inspired by the paper.

## CSCI670 - Advanced Algorithms
### Thinking Project 1
#### Density-Connected Subspace Clustering for High-Dimensional Data

1. How did you find this paper?

I have always been very interested in the problem of clustering: it is a very intuitive problem with a wide range of approaches. Based on our geometric discussion of the k-NN problem, I was inspired to look for papers in clustering that minimized parameterization (or removed it all together) and which allowed for arbitrary shapes of clusters. Density-based clustering has been a popular framework for addressing this problem. I knew about and had used implementations of DB-SCAN before this project. However I realized the algorithm itself is 20 years old, so I expanded my search to find techniques inspired by it. A couple of the authors on the original DBSCAN paper went on to work on SUBCLU, the algorithm presented in this paper.

2. Give a brief discussion of the problem and the main result of the paper.
	The problem addressed in the paper is that real world high-dimensional spatial data is rarely clustered spherically, and is usually especially sparse. Nevertheless, domain experts can discern meaningful clusters in the data. The main result of the paper is to expand previous work done around density-connected clustering into identifying meaningful subspaces to cluster this high-dimensional data on. They derive a means of effectively applying DBSCAN to subspaces of increasing dimensionality. 
	 
3. Give a brief discussion of why you find this paper interesting and result important.

	I find this paper interesting because it illustrates a greedy application of a "blackbox" procedure, much like some of the examples we had in lecture and the homeworks.
	
	4. State one major open question posted or inspired by the paper.
    This paper left a couple questions open that have inspired future work; how do you more reliably handle clusters of different densities, and more importantly how do you better handle distinct clusters that overlap? A couple of the authors went on to work on a generalization of DBSCAN that helped with clusters of different size, but 