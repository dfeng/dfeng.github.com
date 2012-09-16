---
layout: post
title: "Goblin Chase Puzzle"
tags: [puzzle]
tagline: "Tricky puzzle about being chased by goblins"
---
{% include JB/setup %}

Below is the puzzle, taken from [here](http://domino.watson.ibm.com/Comm/wwwr_ponder.nsf/challenges/May2001.html):

>We are in a rowing boat on a circular lake, starting at the center. At the edge of the lake is a mean goblin who wants to eat us; and if he catches us, he will do so. The goblin can't swim and won't go into the lake (and doesn't have a boat!) but he can run $k$ times as fast as we can row.
>We, however, can run significantly faster than the goblin can, so if we are able to reach a point at the edge of the lake without the goblin being there, then we will be able to escape.
>Will we be able to escape or are our only options to be marooned forever on the lake or to be eaten by the goblin?
>
>
>The answer depends on the parameter $k$. There is a threshold $T$, such that if $k < T$ then we can escape, and if $K > T$ the goblin will eat us. Find the threshold $T$ to six digits.

Holistic Solution
=========

At first, this problem seems rather intractible. The first naive answer would be to head south of the goblin's initial position. Trivial calculations give us a threshold value of $\pi$. But we can do much better than that.

Let the radius of the circle be 1. Consider the concentric circle with radius $1/k$. While we are inside this circle, our angular speed remains faster than that of the goblin (on the circumference, it is equal). Hence, so long as we are inside this circle, we can always be diametrically opposite the goblin i.e. that the center of the circle lies directly between us and the goblin. Therefore, we simply need to solve the problem where we are $R/K$ away from the centre, diametrically opposite the goblin.

If we now try to head south again, we get a threshold value of $\pi + 1$. But, slightly counterintuitively, we can do better by heading west while the goblin travels clockwise. Why doesn't the goblin just travel anti-clockwise? He'll get there faster than if he travels clockwise. But the goblin is unaware of our intentions. Hence, the moment he goes clockwise, we start heading west. Since we are now in mid-circle territory, the goblin is gaining on us "angularly", so it is optimal for him to continue clockwise.

For this setup, solving the pair of equations
\\\[\sin B = (\pi + B) \cos B, \quad \cos B = 1/k\\\]
gives us $B=1.3518168$ rad and therefore $T = 4.6033388$.