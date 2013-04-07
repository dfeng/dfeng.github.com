---
layout: post
title: "Area Determination of Property Images"
tags: [r, statistics]
tagline: "Crude Approach to calculating areas"
---

In a [class](http://www.stat.yale.edu/~jay/627.html) I am taking, we were given the following problem:
> Calculate (rougly) the area of land shaded green, and the area of property in the green land (the grey buildings).

!['Sample Image'](/img/2013-04-06-area-determination-of-property-images/sample.png)

My Attempt
==========

Thankfully, reading .PNG files into R is easy


{% highlight r %}
library(png)
library(geometry)
library(splancs)
{% endhighlight %}



{% highlight r %}
files <- dir("rawimages", full.names = TRUE)

j <- 2
x <- readPNG(files[j])

nrows <- dim(x)[1]
ncols <- dim(x)[2]
total <- nrows * ncols

xvals <- rep(1:nrows, ncols)
yvals <- rep(1:ncols, each = nrows)
dim(x) <- c(total, 3)
{% endhighlight %}



{% highlight r %}

green <- x[, 2] > 0.9 & x[, 1] < 0.1 & x[, 3] < 0.1

slack <- 5
xmin <- min(xvals[green]) - slack
xmax <- max(xvals[green]) + slack
ymin <- min(yvals[green]) - slack
ymax <- max(yvals[green]) + slack

x[xvals <= xmin | xvals >= xmax | yvals <= ymin | yvals >= ymax, ] <- c(1, 1, 
    1)

grey <- x[, 1] > 0.8 & x[, 1] < 0.95 & x[, 2] > 0.8 & x[, 2] < 0.95 & x[, 3] > 
    0.8 & x[, 3] < 0.95

greys <- which(grey)

red <- x[, 1] > 0.95 & x[, 2] < 0.05 & x[, 3] < 0.05

reds <- which(red)

min.red <- c()
max.red <- c()
min.grey <- c()
max.grey <- c()
groups <- split(1:total, yvals)
for (i in 1:ncols) {
    row <- groups[[i]]
    row.reds <- row[row %in% reds]
    if (length(row.reds) == 0) 
        next
    min.red <- c(min.red, row.reds[1])
    max.red <- c(max.red, row.reds[length(row.reds)])
    row.greys <- row[row %in% greys]
    # greys must be within the range of red
    row.greys <- row.greys[row.greys > row.reds[1] & row.greys < row.reds[length(row.reds)]]
    if (length(row.greys) == 0) 
        next
    min.grey <- c(min.grey, row.greys[1])
    max.grey <- c(max.grey, row.greys[length(row.greys)])
}

red.pts <- cbind(c(xvals[min.red], rev(xvals[max.red])), c(yvals[min.red], rev(yvals[max.red])))
grey.pts <- cbind(c(xvals[min.grey], rev(xvals[max.grey])), c(yvals[min.grey], 
    rev(yvals[max.grey])))

plot(red.pts, col = 1, type = "b")
points(grey.pts, col = 2, type = "b")
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-3.png) 

{% highlight r %}

c(areapl(red.pts), areapl(grey.pts))
{% endhighlight %}



{% highlight text %}
## [1] 22596 17982
{% endhighlight %}
