---
layout: post
title: Contents
---
<span class="newthought">These notes</span> form a concise introductory course on machine learning with large-scale graphs. They mirror the topics topics covered by Stanford [CS224W](https://cs224w.stanford.edu), and are written by the CS 224W TAs. 
{% include marginnote.html id='mn-construction' note='The notes are still under construction! They will be written up as lectures continue to progress. If you find any typos, please let us know, or submit a pull request with your fixes to our [GitHub repository](https://github.com/snap-stanford/cs224w-notes).'%}

You too may help make these notes better by submitting your improvements to us via [GitHub](https://github.com/snap-stanford/cs224w-notes). Note that submitting substantial improvements will result in *bonus points* being added to your overall grade!

Starting with the Fall 2019 offering of CS 224W, the course covers three broad topic areas for understanding and effectively learning representations from large-scale networks: preliminaries, network methods, and machine learning with networks. Subtopics within each area correspond to individual lecture topics. 

## Preliminaries

1. [Introduction and Graph Structure](preliminaries/introduction-graph-structure): Basic background for graph structure and representation
2. [Measuring Networks and Random Graphs](preliminaries/measuring-networks-random-graphs): Network properties, random graphs, and small-world networks
3. [Motifs and Graphlets](preliminaries/motifs-and-structral-roles_lecture): Motifs, graphlets, orbits, ESU

## Network Methods

1. [Structural Roles in Networks](): RolX, Granovetter, the Louvain algorithm
2. [Spectral Clustering](network-methods/spectral-clustering): Graph partitions and cuts, the Laplacian, and motif clustering
3. [Influence Maximization](): Influential sets, submodularity, hill climbing
4. [Outbreak Detection](): CELF, lazy hill climbing
5. [Link Analysis](): PageRank and SimRank
6. [Network Effects and Cascading Behavior](network-methods/network-effects-and-cascading-behavior): Decision-based diffusion, probabilistic contagion, SEIZ
7. [Network Robustness](): Power laws, preferential attachment
8. [Network Evolution](): Densification, forest fire, temporal networks with PageRank
9. [Knowledge Graphs and Metapaths](): Metapaths, reasoning and completion of KGs


## Machine Learning with Networks

1. [Message Passing and Node Classification](): Label propagation and collective classification
2. [Node Representation Learning](): Shallow, DeepWalk, TransE, node2vec, and t-SNE
3. [Graph Neural Networks](): GCN, SAGE, GAT
4. [Generative Models for Graphs](): Variational Autoencoders, GraphRNN, Molecule GAN
