---
layout: post
title: "Fun Algorithms Problem"
tagline: "Short but nice"
tags: [puzzle, compsci]
---

A while back, I bought the venerable book, [Introduction to Algorithms](http://www.amazon.com/Introduction-Algorithms-Electrical-Engineering-Computer/dp/0262031418). One of the first problems that I did and remembered was the following:

> Describe a $\Theta(n \log n)$ time algorithm that, given a set $S$ of $n$ integers and another integer $x$, determine whether or not there exist two elements in $S$ whose sum is exactly $x$.

# (A) Solution

The trick I employed was to consider the set $S - x/2$, remove duplicates, and then take absolute values. If you think about it, the condition that two elements in $S$ sum to $x$ is equivalent to checking for duplicates in the new set. So, we've reduced the problem to a simpler one - finding duplicates - which we know is of order $\Theta(n \log n)$ (it can't be slower than sorting, which by quicksort is of order $\Theta(n \log n)$).

In python, it's easy to determine the presence of duplicates by simply making use of the `set` function. Alternatively, you can write a quicksort like algorithm, as demonstrated below.

{% highlight python %}
def has_sum(l,y):
    mid = float(y)/2 # mid value of y
    if len([x for x in l if x == mid]) > 1:
        return True # if two mid values, return true
    l2 = set([x-mid for x in l]) # remove duplicates
    l3 = [abs(x) for x in l2] # get absolute
    if True:
        # option 1: check for difference in size if we remove duplicates
        l4 = set(l3)
        return len(l3) != len(l4)
    else:
        # option 2: do a quick sort
        return qsort(l3)

def qsort(l):
    if len(l) == 1 or len(l) == 0:
        return False
    if len(l) == 2 and l[0] == l[1]:
        return True
    piv = l[0]
    l1 = []
    l2 = []
    for x in l[1:]:
        if x == piv:
            return True
        elif x > piv:
            l1.append(x)
        elif x < piv:
            l2.append(x)
    return qsort(l1) or qsort(l2)

if __name__ == "__main__":
    l = [6,7,45,2,100,42,9,17,18,13,22,25,33]
    print has_sum(l,29)
{% endhighlight %}