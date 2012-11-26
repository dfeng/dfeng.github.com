---
layout: post
title: "Water Battle"
tagline: "Puzzle from the 1987 Canadian Maths Olympiad"
showtitle: true
tags: [puzzle]
---
{% include JB/setup %}

A short, nice puzzle from [here][1], which states that it is from the 1987 Canadian Mathematical Olympiad.

> An odd number of people armed with water guns are standing in a field so that all the pairwise distances are distinct. At a signal, each shoots at his nearest neighbor and hits him. Prove that one person doesn't get wet.

Solution A (Mine)
===========

Consider $S$, the set of pairs of people whose nearest neighbors are each other. Now, since we have an odd number of people, we know that $S^c$ is nonempty. By the uniqueness of pairwise distances, we also know that there is a unique person, $P$, in $S^c$ with the largest distances to their nearest neighbor.

Suppose $P$ gets wet.
Then, $P$ must have been shot by his nearest neighbor, since if anyone else, say $Q$, in $S^c$ were to shoot $P$, then the distance between $P$ and $Q$ must be greater than $P$ and his nearest neighbor, which contradicts $P$ having the largest distances to their nearest neighbor. But $P$ cannot be shot by his nearest neighbor, since that makes $P \in S$. Hence $P$ cannot get wet.

Solution B (Theirs)
==========

This was taken directly from the above [link][1]:

Consider the two people separated by the shortest distance. At the signal, these two will shoot one another. Now:

1. If another player has also shot at one of these two, then we've established that one player was shot twice, and hence that some other player (in the whole group) lacked an antagonist and stayed dry.
1. If no other player shot at these two, then we can remove them from consideration and apply the same reasoning to the remaining group: The two closest neighbors fired on one another; if another player fired on them then we have our proof; if not then remove the pair and continue.

Because we're removing players in pairs, the group under consideration always contains an odd number of players. But it can't drop all the way to a single player, as he would be firing on no one, and we've said that every player fires on someone. Hence at some point we must discover a player who is fired on twice, and thus prove that some other player was not fired on at all.

[1]: http://www.futilitycloset.com/2012/03/26/water-battle/
