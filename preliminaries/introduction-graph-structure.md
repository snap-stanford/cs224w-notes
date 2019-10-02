---
layout: post
title: Introduction and Graph Structure
---
We begin by motivating the study of graph representations of data, or networks. Networks form a general language for desribing complex systems of interacting entities. Pictorially, rather than thinking that our dataset consists of a set of isolated data points, we consider interactions and relationships between these points.

It's instructive to make a philosophical distinction between different kinds of networks. One interpretation of networks is as examples of phenomena that appear in real life; we call these networks *natural graphs*. A couple examples include
* The human social network (a collection of 7+ billion individuals)
* Internet communication systems (a collection of electronic devices)

An alternative interpretation of networks is as a data structure useful for solving a specific prediction problem. In this case, we're more interested in relationships between entities so we can efficiently perform learning tasks. We call these networks *information graphs*, and some examples include
* Scene graphs (how objects in a scene relate to one another)
* Similarity networks (in which similar points in a dataset are connected).

Some of the main questions we'll be considering in this course involve how such systems are organized and what their design properties are. It's also possible to represent datasets with rich relational structure as graphs for numerous prediction tasks: in this case, we hope to explicitly model relationships for better predictive performance. Some examples of such predictive tasks include

1. *Node classification*, where we predict the type/color of a given node
2. *Link prediction*, where we predict whether two nodes are linked
3. *Community detection*, where we identify densely linked clusters of nodes
4. *Similarity computation*, where we measure the similarity of two nodes or networks

Altogether, networks are a universal language for describing complex data, and generalize across a variety of different fields. With increased data availability and a variety of computational challenges, learning about networks leaves one poised to make a wide variety of contributions.

# A Review of Graphs

## Basic Concepts

A network/graph{% include sidenote.html id='note-graphnetwork' note='Technically, a network often refers to real systems (the web, a social network, etc.) while a *graph* often refers to the mathematical representation of a network (a web graph, social graph, etc.). In these notes, we will use the terms interchangeably.' %} is defined as a collection of objects where some pairs of objects are connected by links. We define the set of objects (nodes) as $$N$$, the set of interactions (edges/links) as $$E$$, and the graph over $$N$$ and $$E$$ as $$G(N, E)$$.

*Undirected* graphs have symmetrical/reciprocal links (e.g. friendship on Facebook). We define the node degree $$k_i$$ of node $$i$$ in an undirected graph as the number of edges adjacent to node $$i$$. The average degree is then

$$\bar{k} = \langle k \rangle = \frac{1}{\vert N \vert} \sum_{i=1}^{\vert N \vert} k_i = \frac{2 \vert E \vert}{N}$$

*Directed* graphs have directed links (e.g. following on Twitter). We define the in-degree $$k^{in}_i$$ as the number of edges entering node $$i$$. Similarly, we define the out-degree $$k^{out}_i$$ as the number of edges leaving node $$i$$. The average degree is then

$$\bar{k} = \langle k \rangle = \frac{\vert E \vert}{N}$$

**Complete Graphs.** An undirected graph with the maximum number of edges (such that all pairs of nodes are connected) is called the complete graph. The complete graph has $$\vert E\vert = \binom{N}{2} = \frac{N(N-1)}{2}$$ and average degree $$\vert N\vert-1$$.

**Bipartite Graphs.** A bipartite graph is a graph whose nodes can be divided into two disjoint sets $$U$$ and $$V$$ such that every edge connects a node in $$U$$ to a node in $$V$${% include sidenote.html id='note-graphnetwork' note='That is, there are no edges between nodes in $$U$$ and between nodes in $$V$$. We call $$U$$ and $$V$$ independent sets.'%}. We can ''fold'' bipartite graphs by creating edges within independent sets $$U$$ or $$V$$ if they share at least one common neighbor.

{% include marginnote.html id='note-bipartite-folded' note='Here, projection $$U$$ connects nodes in $$U$$ if they share at least one neighbor in $$V$$. The same process is applied to obtain projection $$V$$.' %}

![bipartite-folded](../assets/img/introduction_bipartite_folded.png?style=centerme)

**Other Graph Types**. We briefly note that graphs can also include self-edges (self-loops), weights associated with edges, and multiple edges connecting nodes. These attributes can be encoded in graph representations with ease.

## Representing Graphs

We can represent graph $$G$$ as **adjacency matrix** $$A$$ such that $$A_{ij} = 1$$ if $$i$$ and $$j$$ are linked (and $$A_{ij} = 0$$ otherwise). Note that $$A$$ is asymmetric for directed graphs. For example, a graph with a 3-clique on nodes 1, 2, and 3 and an additional edge from node 3 to 4 can be represented as

$$
A = \begin{bmatrix} 0 & 1 & 0 & 1 \\ 1 & 0 & 0 & 1 \\ 0 & 0 & 0 & 1 \\ 1 & 1 & 1 & 0 \end{bmatrix}
$$

For an undirected graph,

$$k_i = \sum_{j=1}^{\vert N \vert} A_{ij} \qquad \text{and} \qquad k_j = \sum_{i=1}^{\vert N \vert} A_{ij}$$

And likewise, for a directed graph,

$$k_i^{out} = \sum_{j=1}^{\vert N \vert} A_{ij} \qquad \text{and} \qquad k_j^{in} = \sum_{i=1}^{\vert N \vert} A_{ij}$$

However, most real-world networks are sparse ($$ \vert E \vert \ll E_{max}$$, or $$\bar{k} \ll \vert N \vert -1$$). As a consequence, the adjacency matrix is filled with zeros (an undesirable property).

In order to alleviate this issue, we can represent graphs as a set of edges (an **edge list**). This makes edge lookups harder, but preserves memory.

## Graph Connectivity

We call an undirected graph $$G$$ **connected** if there is a path between any pair of nodes in the graph. A **disconnected** graph is made up by two or more connected components. A **bridge edge** is an edge such that its removal disconnects $$G$$; an **articulation node** is a node such that its removal disconnects $$G$$. The adjacency matrix of networks with several components can be written in block-diagonal form (so that nonzero elements are confined to squares, and all other elements are 0). 

We can further extend these concepts to directed graphs by definining a **strongly connected** directed graph as one which has a path from each node to every other node and vice versa (e.g. a path $$A \to B$$ and $$B \to A$$). A **weakly connected** directed graph is connected if we disregard the edge directions. We further define **strongly connected components** (SCCs) as strongly connected subgraphs of $$G$$. Nodes that can reach the SCC are part of its in-component, and nodes that can be reached from the SCC are part of its out-component.

The graph below is connected but not strongly connected. It contains one SCC (the graph $$G' = G[A, B, C]$$ induced on nodes A, B, and C).
![directed-graph](../assets/img/introduction_directed_graph.png?style=centerme)

<br/>

|[Index](../) | [Previous](../) | [Next](./measuring-networks-random-graphs)|