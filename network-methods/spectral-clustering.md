---
layout: post
title: Spectral Clustering
---

Here we study the important class of spectral methods for understanding networks on a global level. By "spectral" we mean the spectrum, or eigenvalues, of matrices derived from graphs, which will give us insight into the structure of the graphs themselves. In particular, we will explore spectral clustering algorithms, which take advantage of these tools for clustering nodes in graphs.

The spectral clustering algorithms we will explore generally consist of three basic stages.
1. Preprocessing: construct a matrix representation of a graph, such as the adjacency matrix (but we will explore other options)
2. Decomposition: compute the eigenvectors and eigenvalues of the matrix, and use these to create a low-dimensional representation space
3. Grouping: assign points to clusters based on their representation in this space

# Graph Partitioning
Let's formalize the task we would like to solve. We start out with an undirected graph $$G(V, E)$$. Our goal is to partition $$V$$ into two disjoint groups $$A, B$$ (so $$A \cap B = \emptyset$$ and $$A \cup B = V$$) in a way that maximizes the number of connections internal to the groups and minimizes the number of connections between the two groups.

To further formalize the objective, let's introduce some terminology:
- Cut: how much connection there is between two disjoint sets of nodes. $$cut(A, B) = \sum_{i \in A, j \in B} w_{ij}$$ where $$w_{ij}$$ is the weight of the edge between nodes $$i$$ and $$j$$.
- Minimum cut: $$\arg \min_{A, B} cut(A, B)$$

Since we want to minimize the number of connections between $$A$$ and $$B$$, we might decide to make the minimum cut our objective. However, we find that we end up with very unintuitive clusters this way -- we can often simply set $$A$$ to be a single node with very few outgoing connections, and $$B$$ to be the rest of the network, to get a very small cut. What we need is a measure that also considers internal cluster connectivity.

Enter the **conductance**, which balances between-group and within-group connectivity concerns. We define $$\phi(A, B) = \frac{cut(A, B)}{min(vol(A), vol(B))}$$ where $$vol(A) = \sum_{i \in A} k_i$$, the total (weighted) degree of the nodes in $$A$$. We can roughly think of conductance as analogous to a surface area to volume ratio: the numerator is the area of the shared surface between $$A$$ and $$B$$, and the denominator measures volume while trying to ensure $$A$$ and $$B$$ have similar volumes. Because of this nuanced measure, picking $$A$$ and $$B$$ to minimize the conductance results in more balanced partitions than minimizing the cut. The challenge then becomes to efficiently find a good partition, since minimizing conductance is NP-hard.

# Spectral Graph Partitioning
Enter spectral graph partitioning, a method that will allow us to pin down the conductance using eigenvectors. We'll start by introducing some basic techniques in spectral graph theory.

The goal of spectral graph theory is to analyze the "spectrum" of matrices representing graphs. By spectrum we mean the set $$\Lambda = \{\lambda_1, \ldots, \lambda_n\}$$ of eigenvalues $$\lambda_i$$ of a matrix representing a graph, in order of their magnitudes, along with their corresponding eigenvalues. For example, the largest eigenvector/eigenvalue pair for the adjacency matrix of a d-regular graph is the all-ones vector $$x = (1, 1, \ldots, 1)$$, with eigenvalue $$\lambda = d$$. Exercise: what are some eigenvectors for a disconnected graph with two components, each component d-regular? Note that by the spectral theorem, the adjacency matrix (which is real and symmetric) has a complete spectrum of orthogonal eigenvectors.

What kinds of matrices can we analyze using spectral graph theory?
1. The adjacency matrix: this matrix is a good starting point due to its direct relation to graph structure. It also has the important property of being symmetric, which means that it has a complete spectrum of real-valued, orthogonal eigenvectors.
2. Laplacian matrix $$L$$: it's defined by $$L = D - A$$ where $$D$$ is a diagonal matrix such that $$D_{ii}$$ equals the degree of node $$i$$ and $$A$$ is the adjacency matrix of the graph. The Laplacian takes us farther from the direct structure of a graph, but has some interesting properties which will take us towards deeper structural aspects of our graph. We note that the all-ones vector is an eigenvector of the Laplacian with eigenvalue 0. In addition, since $$L$$ is symmetric, it has a complete spectrum of real-valued, orthogonal eigenvectors. Finally, $$L$$ is positive-semidefinite, which means it has three equivalent properties: its eigenvalues are all non-negative, $$L = N^T N$$ for some matrix $$N$$ and $$x^T Lx \geq 0$$ for every vector $$x$$. This property allows us to use new linear algebra tools to understand $$L$$ and thus our original graph.

In particular, $$\lambda_2$$, the second smallest eigenvalue of $$L$$, is already fascinating and studying it will let us make big strides in understanding graph clustering. By the theory of Rayleigh quotients, we have that $$\lambda_2 = \min_{x: x^T w_1 = 0} \frac{x^T L x}{x^T x}$$ where $$w_1$$ is the eigenvector corresponding to eigenvalue $$\lambda_1$$; in other words, we minimize the objective in the subspace of vectors orthogonal to the first eigenvector in order to find the second eigenvector (remember that $$L$$ is symmetric and thus has an orthogonal basis of eigenvalues). On a high level, Rayleigh quotients frame the eigenvector search as an optimization problem, letting us bring optimization techniques to bear. Note that the objective value does not depend on the magnitude of $$x$$, so we can constrain its magnitude to be 1. Note additionally that we know that the first eigenvector of $$L$$ is the all-ones vector with eigenvalue 0, so saying that $$x$$ is orthogonal to this vector is equivalent to saying that $$\sum_i x_i = 0$$.

Using these properties and the definition of $$L$$, we can write out a more concrete formula for $$\lambda_2$$: $$\lambda_2 = \min_x \frac{\sum_{(i, j) \in E} (x_i - x_j)^2}{\sum_i x_i^2}$$, subject to the constraint $$\sum_i x_i = 0$$. If we additionally constrain $$x$$ to have unit length, the objective turns into simply $$\min_x \sum_{(i, j) \in E} (x_i - x_j)^2$$.

How does $$\lambda_2$$ relate to our original objective of finding a best partition of our graph? Let's express our partition $$(A, B)$$ as a vector $$y$$ defined by $$y_i = 1$$ if $$i \in A$$ and $$y_i = -1$$ if $$i \in B$$. Instead of using the conductance here, let's first try to minimize the cut while taking care of the problem of balancing partition sizes by enforcing that $$\vert A\vert = \vert B\vert$$ (balance size of partitions), which amounts to constraining $$\sum_i y_i = 0$$. Given this size constraint, let's minimize the cut of the partition, i.e. find $$y$$ that minimizes $$\sum_{(i, j) \in E} (y_i - y_j)^2$$. Note that the entries of $$y$$ must be $$+1$$ or $$-1$$, which has the consequence that the length of $$y$$ is fixed. *This optimization problem looks a lot like the definition of $$\lambda_2$$!* Indeed, by our findings above we have that this objective is minimized by $$\lambda_2$$ of our Laplacian, and the optimal clustering $$y$$ is given by its corresponding eigenvector, known as the **Fiedler vector**.

Now that we have a link between an eigenvalue of $$L$$ and graph partitioning, let's push the connection further and see if we can get rid of the hard $$\vert A\vert = \vert B\vert$$ constraint -- maybe there is a link between the more flexible conductance measure and $$\lambda_2$$. Let's rephrase conductance here in the following way: if a graph $$G$$ is partitioned into $$A$$ and $$B$$ where $$\vert A\vert \leq \vert B\vert$$, then the conductance of the cut is defined as $$\beta = cut(A, B)/\vert A\vert$$. A result called the Cheeger inequality links $$\beta$$ to $$\lambda_2$$: in particular, $$\frac{\beta^2}{2k_{max}} \leq \lambda_2 \leq 2\beta$$ where $$k_{max}$$ is the maximum node degree in the graph. The upper bound on $$\lambda_2$$ is most useful to us for graph partitioning, since we are trying to minimize the conductance; it says that $$\lambda_2$$ gives us a good estimate of the conductance -- we never overestimate it more than by a factor of 2! The corresponding eigenvector $$x$$ is defined by $$x_i = -1/a$$ if $$i \in A$$ and $$x_j = 1/b$$ if $$i \in B$$; the signs of the entries of $$x$$ give us the partition assignments of each node.

# Spectral Partitioning Algorithm
Let's put all our findings together to state the spectral partitioning algorithm.
1. Preprocessing: build the Laplacian matrix $$L$$ of the graph
2. Decomposition: map vertices to their corresponding entries in the second eigenvector
3. Grouping: sort these entries and split the list in two to arrive at a graph partition

Some practical considerations emerge.
- How do we choose a splitting point in step 3? There's flexibility here -- we can use simple approaches like splitting at zero or the median value, or more expensive approaches like minimizing the normalized cut in one dimension.
- How do we partition a graph into more than two clusters? We could divide the graph into two clusters, then further subdivide those clusters, etc (Hagen et al '92)...but that can be inefficient and unstable. Instead, we can cluster using multiple eigenvectors, letting each node be represented by its component in these eigenvectors, then cluster these representations, e.g. through k-means (Shi-Malik '00), which is commonly used in recent papers. This method is also more principled in the sense that it approximates the optimal k-way normalized cut, emphasizes cohesive clusters and maps points to a well-separated embedded space. Furthermore, using an eigenvector basis ensures that less information is lost, since we can choose to keep the (more informative) components corresponding to bigger eigenvalues.
- How do we select the number of clusters? We can try to pick the number of clusters $$k$$ to maximize the **eigengap**, the absolute difference between two consecutive eigenvalues (ordered by descending magnitude).

# Motif-Based Spectral Clustering
What if we want to cluster by higher-level patterns than raw edges? We can instead cluster graph motifs into "modules". We can do everything in an analogous way. Let's start by proposing analogous definitions for cut, volume and conductance:
- $$cut_M(S)$$ is the number of motifs for which some nodes in the motif are in one side of the cut and the rest of the nodes are in the other cut
- $$vol_M(S)$$ is the number of motif endpoints in $$S$$ for the motif $$M$$
- We define $$\phi(S) = cut_M(S) / vol_M(S)$$

How do we find clusters of motifs? Given a motif $$M$$ and graph $$G$$, we'd like to find a set of nodes $$S$$ that minimizes $$\phi_M(S)$$. This problem is NP-hard, so we will again make use of spectral methods, namely **motif spectral clustering**:
1. Preprocessing: create a matrix $$W^{(M)}$$ defined by $$W_{ij}^{(M)}$$ equals the number of times edge $$(i, j)$$ participates in $$M$$.
2. Decomposition: use standard spectral clustering on $$W^{(M)}$$.
3. Grouping: same as standard spectral clustering

Again, we can prove a motif version of the Cheeger inequality to show that the motif conductance found by our algorithm is bounded above by $$4\sqrt{\phi_M^*}$$, where $$\phi_M^*$$ is the optimal conductance.

We can apply this method to cluster the food web (which has motifs dictated by biology) and gene regulatory networks (in which directed, signed triads play an important role).
