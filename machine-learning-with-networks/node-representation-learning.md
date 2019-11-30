---
layout: post
title: Node Representation Learning
---

In this section, we study several methods to represent a graph in the embedding space. By "embedding" we mean mapping each node in a network into a low-dimensional space, which will give us insight into nodes' similarity and network structure. Given the widespread prevalence of graphs on the web and in the physical world, representation learning on graphs plays a significant role in a wide range of applications, such as link prediction and anomaly detection. However, modern machine learning algorithms are designed for simple sequence or grids (e.g., fixed-size images/grids, or text/sequences), networks often have complex topographical structures and multimodel features. We will explore embedding methods to get around the difficulties.

## Embedding Nodes
The goal of node embedding is to encode nodes so that similarity in the embedding space (e.g., dot product) approximates similarity in the original network, the node embedding algorithms we will explore generally consist of three basic stages:
1. Define an encoder (i.e., a mapping from nodes to embeddings). Below we include a diagram to illustrate the process, encoder $$\rm ENC$$ maps node $$u$$ and $$v$$ to low-dimensional vector $$\mathbf{z_u}$$ and $$\mathbf{z_v}$$:
![node embeddings](../assets/img/node_embeddings.png?style=centerme)

2. Define a node similarity function (i.e., a measure of similarity in the original network), it specifies how the relationships in vector space map to the relationships in the original network.
3. Optimize the parameters of the encoder so that similarity of $$u$$ and $$v$$ in the network approximate the dot product between node embeddings: $$\rm similarity(u,v) \approx \mathbf{z_u}^\intercal \mathbf{z_v}$$.


## "Shallow" Encoding
How to define a encoder to map nodes into a embedding space?

"Shallow" encoding is the simplest encoding approach, it means encoder is just an embedding-lookup and it could be represented as:

$$
\rm ENC(v) = \mathbf{Z}\mathbf{v}\\
\mathbf{Z} \in \mathbb{R} ^{d \times |v|}, \mathbf{v} \in \mathbb{I} ^{|v|}
$$ 
 
 Each column in matrix $$ \mathbf{Z}$$ indicates a node embedding, the total number of rows in $$ \mathbf{Z}$$ equals to the dimension/size of embeddings. $$\mathbf{v}$$ is the indicator vector with all zeros except a one in column indicating node $$v$$. We see that each node is assigned to a unique embedding vector in "shallow" encoding. There are many ways to generate node embeddings (e.g., DeepWalk, node2vec, TransE), key choices of methods depend on how they define node similarity.
 
## Random Walk
Now let's try to define node similarity. Here we introduce **Random Walk**, an efficient and expressive way to define node similarity {% include sidenote.html id='note-randomwalk' note='Random walk has a flexible stochastic definition of node similarity that incorporates both local and higher-order neighborhood information, also it does not need to consider all node pairs when training; only need to consider pairs that co-occur on random walks. '%} and train node embeddings: given a graph and a starting point, we select a neighbor of it at random, and move to this neighbor; then we select a neighbor of this point at random, and move to it, etc. The (random) sequence of points selected this way is a random walk on the graph. So $$\rm similarity(u,v)$$ is defined as the probability that $$u$$ and $$v$$ co-occur on a random walk over a network. We can generate random-walk embeddings following these steps:

1. Estimate probability of visiting node $$v$$ on a random walk starting from node $$u$$ using some random walk strategy $$R$$. The simplest idea is just to run fixed-length, unbiased random walks starting from each node (i.e., DeepWalk from Perozzi et al., 2013).
2. Optimize embeddings to encode these random walk statistics, so the similarity between embeddings (e.g., dot product) encodes Random Walk similarity.
 
### Random walk optimization and Negative Sampling
Since we want to find embedding of nodes to d-dimensions that preserve similarity, we need to learn node embedding such that nearby nodes are close together in the network. Specifically, we can define nearby nodes $$N_R (u)$$ as neighborhood of node $$u$$ obtained by some strategy $$R$$. Let's recall what we learn from random walks, we could run **short fixed-length random walks** starting from each node on the graph using some strategy $$R$$ to collect $$N_R (u)$$, which is the multiset of nodes visited on random walks starting from $$u$$. Note that $$N_R (u)$$can have repeat elements since nodes can be visited multiple times on random walks. Then we might optimize embeddings to maximize the likelihood of random walk co-occurrences, we compute loss function as:

$$
\mathcal{L} =\sum_{u\in V} \sum_{v\in N_R (u)} -\rm \ log (P(v|\mathbf{z_u}))
$$

where
we parameterize $$P(v|\mathbf{z_u})$$ using softmax:

$$
P(v|\mathbf{z_u}) = \rm \frac{exp(\mathbf{z_u}^\intercal \mathbf{z_v})}{exp(\sum_{n \in V}\mathbf{z_u}^\intercal \mathbf{z_n})}
$$

Put it together:

$$
\mathcal{L} =\sum_{u\in V} \sum_{v\in N_R (u)} - \rm \ log (\rm \frac{exp(\mathbf{z_u}^\intercal \mathbf{z_v})}{exp(\sum_{n \in V}\mathbf{z_u}^\intercal \mathbf{z_n})})
$$

To optimize random walk embeddings, we need to find embeddings $$\mathbf{z_u}$$ that minimize $$\mathcal{L}$$. But doing this naively without any changes is too expensive, 
nested sum over nodes gives $$ \rm O(|V|^2)$$ complexity. Here we introduce **Negative Sampling** {% include sidenote.html id='negative_sampling' note='To read more about negative sampling, refer to *Goldberg et al., word2vec Explained: Deriving Mikolov et al.’s Negative-Sampling Word-Embedding Method (2014)*.'%} to approximate the loss. Technically, Negative sampling is a different objective, but it is a form of Noise Contrastive Estimation (NCE) which approximately maximizes the log probability of softmax. New formulation corresponds to using a logistic regression (sigmoid func.) to distinguish the target node $$v$$ from nodes $$n_i$$ sampled from background distribution $$P$$ such that

$$
\rm \ log (\frac{exp(\mathbf{z_u}^\intercal \mathbf{z_v})}{exp(\sum_{n \in V}\mathbf{z_u}^\intercal \mathbf{z_n})}) \approx log(\sigma (\mathbf{z_u}^\intercal \mathbf{z_v})) - \sum_{i = 1}^k log(\mathbf{z_u}^\intercal \mathbf{z_{n_{i}}})), \ n_i \sim P_v
$$

$$\rm P_v$$ means random distribution over all nodes. Instead of normalizing with respect to all nodes, we just normalize against $$k$$ random “negative samples” $$n_i$$. In this way, we need to sample $$k$$ negative nodes proportional to degree to compute the loss function. Note that higher $$k$$ gives more robust estimates, but it also corresponds to higher bias on negative events. In practice, we choose $$k$$ between 5 to 20.

### Node2vec
So far we have described how to optimize embeddings given random walk statistics, What strategies should we use to run these random walks? As we mentioned before, the simplest idea is to run fixed-length, unbiased random walks starting from each node (i.e., DeepWalk from Perozzi et al., 2013), the issue is that such notion of similarity is too constrained. We observe that flexible notion of network neighborhood $$N_R (u)$$ of node $$u$$ leads to rich node embeddings, the idea of Node2Vec is using flexible, biased random walks that can trade off between local and global views of the network (Grover and Leskovec, 2016). Two classic strategies to define a neighborhood $$N_R (u)$$ of a given node $$u$$ are BFS and DFS:
 
![node2vec](../assets/img/node2vec.png?style=centerme)
 
 BFS can give a local micro-view of neighborhood, while DFS provides a global macro-view of neighborhood. Here we can define return parameter $$p$$ and in-out parameter $$q$$ and use biased $$\rm 2^{nd}$$-order random walks to explore network neighborhoods, where $$p$$ models transition probabilities to return back to the previous node and $$q$$ defines the "ratio" of BFS and DFS. Specifically, given a graph below, walker came from edge ($$s_1$$, $$w$$) and is now at $$w$$, $$1$$, $$1/q$$ and $$1/p$$ show the probabilities of which node will visit next (here $$w$$, $$1$$, $$1/q$$ and $$1/p$$ are unnormalized probabilities):

 ![biased_walk](../assets/img/biased_walk.png?style=centerme)
 
 So now $$N_R (u)$$ are the nodes visited by the biased walk. Let’s put our findings together to state the node2vec algorithm:
 1. Compute random walk probabilities
 2. Simulate $$r$$ random walks of length $$l$$ starting from each node $$u$$
 3. Optimize the node2vec objective using Stochastic Gradient Descent

## TransE
Here we take a look at representation learning on multi-relational graph. 
Multi-relational graphs are graphs with multiple types of edges, they are incredibly useful in applications like knowledge graphs, where nodes are referred to as entities, edges as relations. For example, there may be one node representing "J.K.Rowling" and another representing "Harry Potter", and an edge between them with the type "is author of". In order to create an embedding for this type of graph, we need to capture what the types of edges are, because different edges indicate different relations.

**TransE**(Bordes, Usunier, Garcia-Duran. NeurIPS 2013.) is a particular algorithm designed to learn node embeddings for multi-relational graphs. 
We'll let a multi-relational graph $$G=(E,S,L)$$ consist of the set of $$entities$$ $$E$$ (i.e., nodes), a set of edges $$S$$, and a set of possible relationships $$L$$. In TransE, relationships between entities are represented as triplets：

$$
(h,l,t)
$$

Where $$h \in E$$ is head entity or source-node, $$l \in L$$ is relation and $$t \in E$$ is tail entity or destination-node. Similar to previous methods, entities are embedded in an entity space $$\mathbb{R}^k$$. The main innovation of TransE is that each relationship $$l$$ is also embedded as a vector $$\mathbf{l} \in \mathbb{R}^k$$. 

 ![TransE](../assets/img/TransE.png?style=centerme)

That is, if $$(h,l,s) \in S$$, TransE tries to ensure that:

$$
\mathbf{h}+\mathbf{l} \approx \mathbf{t}
$$

Simultaneously, if the edge $$(h,l,t)$$ does not exist, TransE tries to make sure that:

$$
\mathbf{h}+\mathbf{l} \neq \mathbf{t}
$$

TransE accomplishes this by minimizing the following loss:

$$
\mathcal{L} = \sum_{(h,l,t)\in S}(\sum_{(h',l,t')\in S'_{(h,l,s)}}[\gamma +d(\mathbf{h}+\mathbf{l},\mathbf{t}) - d(\mathbf{h'}+\mathbf{l},\mathbf{t'})]_+)
$$

Here $$(h',l,s')$$ are "corrupted" triplets, chosen from the set $$S'_{(h,l,t)}$$ of corruptions of $$(h,l,t)$$, which are all triplets where either $$h$$ or $$t$$ (but not both) is replaced by a random entity:

$$
S'_{(h,l,t)} = \{ (h',l,t) | h' \in E  \} \cup \{  (h,l,t') | t' \in E  \}
$$

Additionally, $$\rm \gamma >0$$ is a sclar called the $$margin$$, the function $$d(.,.)$$ is the Euclidean distance, and $$[]_+$$ is the positive part function (defined as max$$(0,.)$$). Finally, in order to ensure the quality of our embeddings, TransE restricts all the entity embeddings to have length $$1$$, that is, for every $$e \in E$$:

$$
|| e||_2 = 1
$$

Figure below shows the pseudocode of TransE algorithm:
 ![TransEa](../assets/img/TransE_a.png?style=centerme)

## Graph Embedding
We may also want to embed an entire graph $$G$$ in some applications (e.g., classifying toxic vs. non-toxic molecules, identifying anomalous graphs).

![GraphE](../assets/img/graph_embedding.png?style=centerme)

There are several ideas to accomplish graph embedding:
1. The simple idea (Duvenaud et al., 2016) is to run a standard graph embedding technique on the (sub)graph $$G$$, then just sum (or average) the node embeddings in the (sub)graph $$G$$.
2. Introducing a “virtual node” to represent the (sub)graph and run a standard graph embedding technique:
![VirtualN](../assets/img/virtual_nodes.png?style=centerme)
To read more about using the virtual node for subgraph embedding, refer to *Li et al., Gated Graph Sequence Neural Networks (2016)*

3. We can also use **anonymous walk embeddings**. In order to learn graph embeddings, we could enumerate all possible anonymous walks $$a_i$$ of $$l$$ steps and record their counts and represent the graph as a probability distribution over these walks. To read more about anonymous walk embeddings, refer to *Ivanov et al., Anonymous Walk Embeddings (2018)*.
