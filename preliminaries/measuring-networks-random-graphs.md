---
layout: post
title: Measuring Networks and Random Graphs
header-includes:
   - \usepackage{amsmath}
---

## Measuring Networks via Network Properties
In this section, we study four key network properties to characterize a graph: **degree distribution, path length, clustering coefficient**, and **connected components**. Definitions will be presented for undirected graphs, but can be easily extended to directed graphs.

### Degree Distribution
The **degree distribution** $$P(k)$$ measures the probability that a randomly chosen node has degree $$k$$. The degree distribution of a graph $$G$$ can be summarized by a normalized histogram, where we normalize the histogram by the total number of nodes.

We can compute the degree distribution of a graph by $$P(k) = N_k / N$$. Here, $$N_k$$ is the number of nodes with degree $$k$$ and $$N$$ is the number of nodes. One can think of degree distribution as the probability that a randomly chosen node has degree $$k$$.

To extend these definitions to a directed graph, compute separately both in-degree and out-degre distribution.

### Paths in a Graph
A **path** is a sequence of nodes in which each node is linked to the next one:

$$
P_n = \{i_0, i_1, i_2, \dots, i_n\}
$$

such that $$\{(i_0, i_1), (i_1, i_2), (i_2, i_3), \dots, (i_{n-1}, i_n)\} \in E$$

The **distance (shortest path, geodesic)** between a pair of nodes is defined as the number of edges along the shortest path connecting the nodes. If two nodes are not connected, the distance is usually defined as infinite (or zero). One can also think of distance as the smallest number of nodes needed to traverse to get form one node to another. 

In a directed graph, paths need to follow the direction of the arrows. Thus, distance is not symmetric for directed graphs. For a graph with weighted edges, the distance is the minimum number of edge weight needed to traverse to get from one node to another.

The **average path length** of a graph is the average shortest path between all connected nodes. We compute the average path length as

$$
\hat h = \frac{1}{2 E_{max}} \sum_{i, j \neq i} h_{ij}
$$

where $$E_{max}$$ is the max number of edges or node pairs; that is, $$E_{max} = n (n-1) / 2$$ and $$h_{ij}$$ is the distance from node $$i$$ to node $$j$$. Note that we only compute the average path length over connected pairs of nodes, and thus ignore infinite length paths.

### Clustering Coefficient
The **clustering coefficient** (for undirected graphs) measures what proportion of node $$i$$'s neighbors are connected. For node $$i$$ with degree $$k_i$$, we compute the clustering coefficient as

$$
C_i = \frac{2 e_i}{k_i (k_i - 1)}
$$

where $$e_i$$ is the number of edges between the neighbors of node $$i$$. Note that $$C_i \in [0,1]$$. Also, the clustering coefficient is undefined for nodes with degree 0 or 1.

We can also compute the **average clustering coefficent** as

$$
C = \frac{1}{N} \sum_{i}^N C_i.
$$

The average clustering coefficient allows us to see if edges appear more densely in parts of the network. In social networks, the average clustering coefficient tends to be very high indicating that, as we expect, friends of friends tend to know each other.

### Connectivity

The **connectivity** of a graph measures the size of the largest connected component. The **largest connected component** is the largest set where any two vertices can be joined by a path. 

To find connected components:
1. Start from a random node and perform breadth first search (BFS)
2. Label the nodes that BFS visits
3. If all the nodes are visited, the netowrk is connected
4. Otherwise find an unvisited node and repeat BFS


## The Erdös-Rényi Random Graph Model

The **Erdös-Rényi Random Graph Model** is the simplest model of graphs. This simple model has proven networks properties and is a good baseline to compare real-world graph properties with.

This random graph model comes in two variants:
1. **$$G_{np}$$**: undirected graph on $$n$$ nodes where each edge $$(u,v)$$ appears IID with probability $$p$$
2. **$$G_{nm}$$**: undirected graph with $$n$$ nodes, and $$m$$ edges picked uniformly at random

Note that both the $$G_{np}$$ and $$G_{nm}$$ graph are not uniquely determined, but rather the result of a random procedure. Generating each graph multiple times results in different graphs.

### Some Network Properties of $$G_{np}$$

The degree distribution of $$G_{np}$$ is binomial. Let $$P(k)$$ denotes the fraction of nodes with degree $$k$$, then

$$
P(k) = \binom{n-1}{k} p^k (1-p)^{n-1-k}
$$

The mean and variance of a binomial distribution respectively are $$\bar k = p(n-1)$$ and $$\sigma^2 = p(1-p)(n-1)$$. Below we include an image of binomial distributions for different paramters. Note that a binomial distribution is a discrete analogue of a Gaussian and has a bell-shape.

![binom-dist](../assets/img/binom_dist_graph.png?style=centerme)

One property of binomial distributions is that by the law of numbers, as the network size increases, the distribution becomes increasingly narrow. Thus, we are increasingly confidence that the degree of a ndoe is in the vicinity of $$k$$. If the graph has an infinite number of nodes, all nodes will have the same degree.

### The Clustering Coefficient of $$G_{np}$$
Recall that the clustering coefficient is computed as $$C_i = 2 \frac{e_i} {k_i (k_i -1)}$$ where $$e_i$$ is the number of edges between $$i$$'s neighbors. Edges in $$G_{np}$$ appear IID with probability $$p$$, so the expected $$e_i$$ for $$G_{np}$$ is

$$\mathbb{E}[e_i] = p \frac{k_i(k_i - 1)}{2}$$

This is because $$\frac{k_i(k_i - 1)}{2}$$ is the number of distinct pairs of neighbors of node $$i$$ of degree $$k_i$$, and each pair is connected with probability $$p$$.

Thus, the expected clustering coefficient is

$$
\mathbb{E}[C_i] = \frac{p \cdot k_i (k_i - 1)}{k_i (k_i - 1)} = p = \frac{\bar k}{n-1} \approx \frac{\bar k}{n}.
$$

where $$\bar k$$ is the average degree. From this, we can see that the clustering coefficient of $$G_{np}$$ is very small. If we generate bigger and bigger graphs with fixed average degree $$\bar k$$, then $$C$$ decreases with graph size $$n$$. $$\mathbb{E}[C_i] \to 0$$ as $$n \to \infty$$.

### The Path Length of $$G_{np}$$
To discuss the path length of $$G_{np}$$, we fist introduce the concept of **expansion.** Graph $$G(V, E)$$ has expansion $$\alpha$$ if $$\forall S \subset V$$, the number of edges leaving $$S \geq \alpha \cdot \min (|S|, | V \setminus S|)$$. Expansion answers the question ''if we pick a random set of nodes, how many edges are going to leave the set?'' Expansion is a measure of robustness: to disconnect $$\ell$$ nodes, one must cut $$\geq \alpha \cdot \ell$$ edges.

Equivalently, we can say a graph $$G(V,E)$$ has an expansion $$\alpha$$ such that

$$
\alpha = \min_{S \subset V} \frac{\# \text{ edges leaving $S$}}{\min(|S|, |V \setminus S|)}
$$

An important fact about expansion is that in a graph with $$n$$ nodes with expansion $$\alpha$$, for all pairs of nodes, there is a path of $$O((\log n) / \alpha)$$ connecting them. For a random $$G_{np}$$ graph, $$\log n > np > c$$, so $$\text{diam}(G_{np}) = O(\log n / \log (np))$$. Thus, we can see that random graphs have good expansion so it takes as logarithmic number of steps for BFS to visit all nodes.

![expansion](../assets/img/expansion.png?style=centerme)
    
Thus, the path length of $$G_{np}$$ is $$O(\log n)$$. From this result, we can see that $$G_{np}$$ can grow very large, but nodes will still remain a few hops apart.

![er-path](../assets/img/ER_path.png?style=centerme)

### The Connectivity of $$G_{np}$$
The graphic below shows the evolution of a $$G_{np}$$ random graph. We can see that there is an emergence of a giant component when average degree $$\bar k = 2 E / n$$ or $$p = \bar k / (n-1)$$. If $$k = 1 - \epsilon$$, then all components are of size $$\Omega(\log n)$$. If $$\bar k = 1 + \epsilon$$, there exists 1 component of size $$\Omega(n)$$, and all other components have size $$\Omega(\log n)$$. In other words, if $$\bar k > 1$$, we expect a single large component. Additionally, in this case, each node has at least one edge in expectation.

![er-path](../assets/img/evol_of_rand_graph.png?style=centerme)

### Analyzing the Properties of $$G_{np}$$ 

In grid networks, we achieve triadic closures and high clustering, but long average path length. 

![grid-network](../assets/img/grid_network.png?style=centerme)

In random networks, we achieve short average path length, but low clustering. 

![grid-network](../assets/img/random_network.png?style=centerme)

Given the two above graph structures, it may seem unintuitive that graphs can have short average path length while also having high clustering. However, most real-world networks have such properties as in the below table, where $$h$$ refers to the average shortest path length, $$c$$ refers to the average clustering coefficient, and random graphs were generated with the same average degree as actual networks for comparison. 

| Network|$$h_{actual}$$|$$h_{random}$$|$$c_{actual}$$|$$c_{random}$$| 
|----|--------|------|----|-----|
|Film actors | 3.65 | 2.99 | 0.79 | 0.00027|
|Power Grid | 18.70 | 12.40 |0.080 | 0.005|
|C. elegans | 2.65 |2.25 |0.28 | 0.05|

Networks that meet the above criteria of both high clustering and small average path length (mathematically defined as $$L \propto \log N$$ where $$L$$ is average path length and $$N$$ is the total number of nodes in the network) are referred to as small world networks. 

## The Small World Random Graph Model 

In 1998, Duncan J. Watts and Steven Strogatz came up with a model for constructing a family of networks with both high clustering and short average path length. They termed this model the ''small world model''. To create such a model, we employ the following steps:

1. Start with low-dimensional regular attic (ring) by connecting each node to $$k$$ neighbors on its right and $$k$$ neighbors on its left, with $$k \geq 2$$.

2. Rewire each edge with probability $$p$$ by moving its endpoint to a randomly chosen node.{% include sidenote.html id='note-graphnetwork' note='Several variants of rewiring exist. To learn more, see *M. E. J. Newman. Networks, Second Edition, Oxford University Press, Oxford (2018)*'%}

![Small World Model](../assets/img/small_world.png?style=centerme)

Then, we make the following observations:

- At $$p = 0$$ where no rewiring has occured, this remains a grid network with high clustering, high diameter.
- For $$0 < p < 1$$ some edges have been rewired, but most of the structure remains. This implies both **locality** and **shortcuts**. This allows for both high clustering and low diameter.
- At $$p = 1$$ where all edges have been randomly rewired, this is a Erdős–Rényi (ER) random graph with low clustering, low diameter.

![Clustering and Average Path Length](../assets/img/clustering_path.png?style=centerme)

Small world models are parameterized by the probability of rewiring $$p \in [0,1]$$. By examining how the clustering coefficient and the average path length vary with values of $$p$$, we see that average path length falls off much faster as $$p$$ increases, while the clustering coefficient remains relatively high. Rewiring introduces shortcuts, which allows for average path length to decrease even while the structure remains relatively strong (high clustering).

From a social network perspective, this phenomenon is intuitive. While most our friends are local, but we also have a few long distance friendships in different countries which is enough to collapse the diameter of the human social network, explaining the popular notion of "Six Degrees of Seperation".

Two limitations of the Watts-Strogatz Small World Model are that its degree distribution does not match the power-law distributions of real world networks, and it cannot model network growth as the size of network is assumed. 

## The Kronecker Random Graph Model

Models of graph generation have been studied extensively. Such models allow us to generate graphs for simulations and hypothesis testing when collecting the real graph is difficult, and also forces us to examine the network properties that generative models should obey to be considered realistic. 

In formulating graph generation models, there are two important considerations. First, the ability to generate realistic networks, and second, the mathematical tractability of the models, which allows for the rigorous analysis of network properties. 

The Kronecker Graph Model is a recursive graph generation model that combines both mathematical tractability and realistic static and temporal network properties. The intuition underlying the Kronecker Graph Model is self-similarity, where the whole has the same shape as one or more of its parts.

![self-similarity](../assets/img/community_growth.png?style=centerme)

The Kronecker product, a non-standard matrix operation, is a way to generate self-similar matrices.

### The Kronecker Product

The Kronecker product is denoted by $$\otimes$$. For two arbitarily sized matrices $$\textbf{A} \in \mathbb{R}^{m \times n}$$ and $$\textbf{B} \in \mathbb{R}^{p \times q}$$, $$\textbf{A} \otimes \textbf{B} \in \mathbb{R}^{mp \times nq}$$ such that

$$\textbf{A} \otimes \textbf{B} = 
\begin{bmatrix} 
a_{11}\textbf{B}& \dots &a_{1n}\textbf{B}\\
\vdots &\ddots& \vdots\\
a_{m1}\textbf{B}& \dots & a_{mn}\textbf{B}
\end{bmatrix}
$$

For example, we have that

$$\begin{bmatrix} 1&2\\3&4 \end{bmatrix} \otimes \begin{bmatrix} 0&5\\6&7 \end{bmatrix} 
= \begin{bmatrix} 1  \begin{bmatrix} 0&5\\6&7 \end{bmatrix}  &2  \begin{bmatrix} 0&5\\6&7 \end{bmatrix}  \\3  \begin{bmatrix} 0&5\\6&7 \end{bmatrix}  &4  \begin{bmatrix} 0&5\\6&7 \end{bmatrix}  \end{bmatrix}
= \begin{bmatrix} 
1 \times 0 & 1 \times 5 & 2 \times 0 &  2 \times 5\\
1 \times 6 & 1 \times 7 & 2 \times 6 &  2 \times 7\\
3 \times 0 & 3 \times 5 & 4 \times 0 &  4 \times 5\\
3 \times 6 & 3 \times 7 & 4 \times 6 &  4 \times 7
\end{bmatrix}
= \begin{bmatrix} 
0 & 5 & 0 &  10\\
6 & 7 & 12 &  14\\
0 & 15 & 0 &  20\\
18 & 21 & 24 &  28
\end{bmatrix}$$

To use the Kronecker product in graph generation, we define the Kronecker product of two graphs as the Kronecker product of the adjacency matrices of the two graphs. 

Beginning with the initiator matrix $$K_1$$ (an adjacency matrix of a graph), we iterate the Kronecker product to produce successively larger graphs, $$K_2 = K_1 \otimes K_1, K_3 = K_2 \otimes K_1 \dots$$, such that the Kronecker graph of order $$m$$ is defined by

$$K_1^{[m]}=\dots K_m = \underbrace{K_1 \otimes K_1 \otimes \dots K_1}_{\text{m times}}=  K_{m-1} \otimes K_1$$

![Kronecker](../assets/img/small_kronecker.png?style=centerme)

Intuitively, the Kronecker power construction can be imagined as recursive growth of the communities within the graph, with nodes in the community recursively getting expanded into miniature copies of the community. 

The choice of the Kronecker initiator matrix $$K_1$$ can be varied, which iteratively affects the structure of the larger graph.

![Initiator](../assets/img/initiator.png?style=centerme)

### Stochastic Kronecker Graphs

Up to now, we have only considered $$K_1$$ initiator matrices with binary values $$\{0, 1\}$$. However, such graphs generated from such initiator matrices have "staircase" effects in the degree distributions and other properties: individual values occur very frequently because of the discrete nature of $$K_1$$.

To negate this effect, stochasticity is introduced by relaxing the assumption that the entries in the initiator matrix can only take binary values. Instead entries in $$\Theta_1$$ can take values on the interval $$[0,1]$$, and each represents the probability of that particular edge appearing. Then the matrix (and all the generated larger matrix products) represent the probability distribution over all possible graphs from that matrix.

More concretely, for probaility matrix $$\Theta_1$$, we compute the $$k^{th}$$ Kronecker power $$\Theta_k$$ as the large stochastic adjacency matrix. Each entry $$p_{uv}$$ in $$\Theta_k$$ then represents the probability of edge $$(u,v)$$ appearing. 

{% include marginnote.html id='note-bipartite-folded' note='Note that the probabilities do not have to sum up to 1 as each the probability of each edge appearing is independent from other edges.' %}

![Stochastic](../assets/img/stochastic_graphs.png?style=centerme)

To obtain an instance of a graph, we then sample from the distribution by sampling each edge with probability given by the corresponding entry in the stochastic adjacency matrix. The sampling can be thought of as the outcomes of flipping biased coins where the bias is parameterized from each entry in the matrix. 

However, this means that the time to naively generate an instance is quadratic in the size of the graph, $$O(N^2)$$; with 1 million nodes, we perform 1 million x 1 million coin flips. 

### Fast Generation of Stochastic Kronecker Graphs

A fast heuristic procedure that takes time linear in the number of edges to generate a graph exists. 

The general idea can be described as follows: for each edge, we recurively choose sub-regions of the large stochastic matrix with probability proportional to $$p_{uv} \in \Theta_1$$ until we descend to a single cell of the large stochastic matrix. We place the edge there. For a Kronecker graph of $$k^{th}$$ power, $$\Theta_k$$, the descent will take $$k$$ steps.  

For example, we consider the case where $$\Theta_1$$ is a $$2 \times 2$$ matrix, such that

$$
\Theta = \begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
$$

For graph $$G$$ with $$n = 2^k$$ nodes:
- Create normalized matrix $$L_{uv} = \frac{p_{uv}}{\sum_{u,v} p_{uv}}, p_{uv} \in \Theta_1$$
- For each edge: 
    - For $$i = 1 \dots k$$:
	    - Start with $$x = 0, y  = 0$$
	    - Pick the row, column $$(u,v)$$ with probability $$L_{uv}$$
	    - Descend into quadrant $$(u,v)$$ based on step $$i$$ of $$G$$
	        - Set $$x = x + u \cdot 2^{k-1}$$
	        - Set $$y = y + v \cdot 2^{k-1}$$
	    - Add edge $$(x,y)$$ to $$G$$
    
If $$k=3$$, and on each step $$i$$, we pick quadrants $$b_{(0,1)}, c_{(1,0)}, d_{(1,1)}$$ respectively based on the normalized probabilities from $$L$$, then

$$x = 0 \cdot 2^{3-1} + 1 \cdot 2^{3-2} + 1 \cdot 2^{3-3} = 0 \cdot 2^2 + 1 \cdot 2^1 + 1 \cdot 2^0 = 3$$
$$y = 1 \cdot 2^{3-1} + 0 \cdot 2^{3-2} + 1 \cdot 2^{3-3} = 1 \cdot 2^2 + 0 \cdot 2^1 + 1 \cdot 2^0 = 5$$

Hence, we add edge $$(3,5)$$ to the graph.

In practice, the stochastic Kronecker graph model is able to generate graphs that match the properties of real world networks well. To read more about the Kronecker Graph models, refer to *J Leskovec et al., Kronecker Graphs: An Approach to Modeling Networks (2010)*.{% include sidenote.html id='note-graphnetwork' note='Estimating the initator matrice $$\Theta_1$$ and fitting Kronecker Graphs to real world networks is also discussed in this work.'%}


<br/>

|[Index](../) | [Previous](./introduction-graph-structure) | [Next](../)|
