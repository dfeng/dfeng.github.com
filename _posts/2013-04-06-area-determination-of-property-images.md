---
layout: post
title: "Area Determination of Property Images"
tags: [r, statistics]
tagline: "Crude Approach to calculating areas"
---

In a [class](http://www.stat.yale.edu/~jay/627.html) I am taking, we were given the following problem:
> Calculate (rougly) the area of land shaded green, and the area of property in the green land (the grey buildings).

Here is a typical image:

!['Sample Image'](/img/2013-04-06-area-determination-of-property-images/sample.png)

My Attempt
==========

Thankfully, reading .PNG files into R is easy


{% highlight r %}
library(png)
library(geometry)

files <- dir("rawimages", full.names=TRUE)
j <- 2
x <- readPNG(files[j])
dim(x)
{% endhighlight %}



{% highlight text %}
## [1] 512 517   3
{% endhighlight %}



{% highlight r %}
x[1:5,1,]
{% endhighlight %}



{% highlight text %}
##        [,1]   [,2]   [,3]
## [1,] 0.9725 0.9804 0.9922
## [2,] 0.9725 0.9804 0.9922
## [3,] 0.9725 0.9804 0.9922
## [4,] 0.9725 0.9804 0.9922
## [5,] 0.9725 0.9804 0.9922
{% endhighlight %}


The output of the `readPNG()` is a three dimensional array (x-coordinate, y-coordinate, RGB values), which is fairly unwieldy. Thankfully, it is easy to coerce matrices in R.


{% highlight r %}
nrows <- dim(x)[1]
ncols <- dim(x)[2]
total <- nrows * ncols

dim(x) <- c(total, 3)
{% endhighlight %}


<div class="alert">
  <strong>Note!</strong> R <em>stores</em> it's matrixes as vectors, by column. Thus, the first 5 elements of the new coerced <code>x</code> is equivalent to the above <code>x[1:5,1,]</code> command (the first 5 elements in column 1).
</div>


{% highlight r %}
head(x)
{% endhighlight %}



{% highlight text %}
##        [,1]   [,2]   [,3]
## [1,] 0.9725 0.9804 0.9922
## [2,] 0.9725 0.9804 0.9922
## [3,] 0.9725 0.9804 0.9922
## [4,] 0.9725 0.9804 0.9922
## [5,] 0.9725 0.9804 0.9922
## [6,] 0.9725 0.9804 0.9922
{% endhighlight %}


To make sure plotting gives the same orientation, we need to flip things around, since graphs start the origin at the bottom left, while the data structure of the PNG will be starting from the top left.


{% highlight r %}

yvals <- rep(nrows:1, ncols)
xvals <- rep(1:ncols, each=nrows)

head(cbind(xvals, yvals))
{% endhighlight %}



{% highlight text %}
##      xvals yvals
## [1,]     1   512
## [2,]     1   511
## [3,]     1   510
## [4,]     1   509
## [5,]     1   508
## [6,]     1   507
{% endhighlight %}


Now, we are ready to do some analysis. At first glance, we want to be able to retrieve the red line (or the green area), and the grey area inside that region. It seemed natural to start with _k_-means clustering, to get a better picture of the different color groups.


{% highlight r %}
km.0 <- kmeans(x, 5, 10)
km.0$centers
{% endhighlight %}



{% highlight text %}
##     [,1]   [,2]   [,3]
## 1 0.8980 0.8980 0.8981
## 2 0.0000 0.1789 0.0000
## 3 0.9985 0.9989 0.9996
## 4 1.0000 0.0000 0.0000
## 5 0.8392 0.8392 0.8392
{% endhighlight %}



{% highlight r %}
these <- km.0$cluster==4
{% endhighlight %}


Recall that the second column is the green channel (so we would expect the green points to have negligable values in the 1st and 3rd, but high in the second). However, the _k_-means clustering doesn't seem to pick them up (weird). We were able to pick up the red and the grey though (red shown below).


{% highlight r %}
plot(xvals, yvals,
    col=apply(x, 1, function(a) rgb(a[1], a[2], a[3])),
    pch=18, cex=0.2)
points(xvals[these], yvals[these], cex=1)
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-6.png) 


Unfortunately, there are images that have multiple areas denoted by a red border. Since we only care about those shaded green, it is not enough to use the red points. We overstep this problem by restricting our attention to the neighbours of the green area. To get the green values, we shall hazard an educated guess as to the form of the RGB.


{% highlight r %}
green <- x[,2] > 0.9 &
         x[,1] < 0.1 &
         x[,3] < 0.1
{% endhighlight %}


Let's check to see if we're right


{% highlight r %}
plot(xvals, yvals,
    col=apply(x, 1, function(a) rgb(a[1], a[2], a[3])),
    pch=18, cex=0.2)
points(xvals[green], yvals[green], cex=1)
{% endhighlight %}

![plot of chunk unnamed-chunk-8](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-8.png) 


Nice. Okay, so now we can create a rectangle around this area (with some slack, to ensure the red border lies inside the area) that we are interested in.


{% highlight r %}
slack <- 5
xmin <- min(xvals[green])-slack
xmax <- max(xvals[green])+slack
ymin <- min(yvals[green])-slack
ymax <- max(yvals[green])+slack

x[xvals <= xmin | xvals >= xmax | yvals <= ymin | yvals >= ymax,] <- c(1,1,1)
{% endhighlight %}


The restricted diagram looks like so:


{% highlight r %}
plot(xvals, yvals,
    col=apply(x, 1, function(a) rgb(a[1], a[2], a[3])),
    pch=18, cex=0.2)
{% endhighlight %}

![plot of chunk unnamed-chunk-10](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-10.png) 


Great! Now we can ignore the green points, and focus our attention on the greys and reds. In the above diagram, we come across another potential problem: there are grey areas in the image that aren't inside the red boundary. Our algorithm handles that nicely though.


{% highlight r %}
grey <- x[,1] >0.80 & x[,1] < 0.95 &
        x[,2] >0.80 & x[,2] < 0.95 &
        x[,3] >0.80 & x[,3] < 0.95
greys <- which(grey)

red <- x[,1] > 0.95 &
       x[,2] < 0.05 &
       x[,3] < 0.05
reds <- which(red)
{% endhighlight %}


The Algorithm
=============

The crux of the algorith is the use of the `areapl()` function in the `splancs` library. This function takes a sequence of points that join up to make a polygon, and calculates the area. Importantly, the points must be sequential around the polygon. Hence, the variable `red` is insufficient. The algorithm is as follows: for each row,
 - retrieve the first and last red point
 - retrieve the first and last grey point within the red points


{% highlight r %}
min.red <- c()
max.red <- c()
min.grey <- c()
max.grey <- c()
groups <- split(1:total, yvals)
for(i in 1:nrows) {
  row <- groups[[i]]
  row.reds <- row[row %in% reds]
  if (length(row.reds) < 2) next
  min.red <- c(min.red, row.reds[1])
  max.red <- c(max.red, row.reds[length(row.reds)])
  row.greys <- row[row %in% greys]
  # greys must be within the range of red
  row.greys <- row.greys[row.greys > row.reds[1] & row.greys < row.reds[length(row.reds)]]
  if (length(row.greys) < 2) next
  min.grey <- c(min.grey, row.greys[1])
  max.grey <- c(max.grey, row.greys[length(row.greys)])
}

red.pts <- cbind(c(xvals[min.red], rev(xvals[max.red])),
                 c(yvals[min.red], rev(yvals[max.red])))
grey.pts <- cbind(c(xvals[min.grey], rev(xvals[max.grey])),
                  c(yvals[min.grey], rev(yvals[max.grey])))
{% endhighlight %}


The polygons we retrieve are shown below.


{% highlight r %}
plot(red.pts, col=1, type='b')
points(grey.pts, col=2, type='b')
{% endhighlight %}

![plot of chunk unnamed-chunk-13](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-13.png) 


We can now calculate a rough area.


{% highlight r %}
library(splancs)
c(areapl(red.pts), areapl(grey.pts))
{% endhighlight %}



{% highlight text %}
## [1] 22306 18594
{% endhighlight %}


We can now create a function with takes a .PNG file path (and a jump parameter, which determines the number of rows to skip), and returns a plot of the original, the polygons, and the area of the polygons:


{% highlight r %}

area <- function(file, jump=1){
  x <- readPNG(file)

  nrows <- dim(x)[1]
  ncols <- dim(x)[2]
  total <- nrows * ncols

  yvals <- rep(nrows:1, ncols)
  xvals <- rep(1:ncols, each=nrows)
  dim(x) <- c(total, 3)

  plot(xvals, yvals,
       col=apply(x, 1, function(a) rgb(a[1], a[2], a[3])),
       pch=18, cex=0.2)

  green <- x[,2] > 0.9 &
           x[,1] < 0.1 &
           x[,3] < 0.1

  slack <- 5
  xmin <- min(xvals[green])-slack
  xmax <- max(xvals[green])+slack
  ymin <- min(yvals[green])-slack
  ymax <- max(yvals[green])+slack

  x[xvals <= xmin | xvals >= xmax | yvals <= ymin | yvals >= ymax,] <- c(1,1,1)

  grey <- x[,1] >0.80 & x[,1] < 0.95 &
          x[,2] >0.80 & x[,2] < 0.95 &
          x[,3] >0.80 & x[,3] < 0.95
  greys <- which(grey)

  red <- x[,1] > 0.95 &
         x[,2] < 0.05 &
         x[,3] < 0.05
  reds <- which(red)

  min.red <- c()
  max.red <- c()
  min.grey <- c()
  max.grey <- c()
  groups <- split(1:total, yvals)
  n <- floor(nrows/jump)
  for (i in 1:n) {
    row <- groups[[i*jump]]
    row.reds <- row[row %in% reds]
    if (length(row.reds) < 2) next
    min.red <- c(min.red, row.reds[1])
    max.red <- c(max.red, row.reds[length(row.reds)])
    row.greys <- row[row %in% greys]
    # greys must be within the range of red
    row.greys <- row.greys[row.greys > row.reds[1] & row.greys < row.reds[length(row.reds)]]
    if (length(row.greys) < 2) next
    min.grey <- c(min.grey, row.greys[1])
    max.grey <- c(max.grey, row.greys[length(row.greys)])
  }

  red.pts <- cbind(c(xvals[min.red], rev(xvals[max.red])),
                   c(yvals[min.red], rev(yvals[max.red])))
  grey.pts <- cbind(c(xvals[min.grey], rev(xvals[max.grey])),
                    c(yvals[min.grey], rev(yvals[max.grey])))

  points(red.pts, col=2, type='b', cex=0.5)
  points(grey.pts, col=1, type='b', cex=0.5)
  return(c(areapl(red.pts), areapl(grey.pts)))
}
{% endhighlight %}



{% highlight r %}
files <- dir("rawimages", full.names=TRUE)
for (i in c(1,3,4)) {
  print(area(files[i]))
}
{% endhighlight %}

![plot of chunk unnamed-chunk-16](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-161.png) 

{% highlight text %}
## [1] 32394  1438
{% endhighlight %}

![plot of chunk unnamed-chunk-16](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-162.png) 

{% highlight text %}
## [1] 20930  4111
{% endhighlight %}

![plot of chunk unnamed-chunk-16](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-163.png) 

{% highlight text %}
## [1] 13334  1140
{% endhighlight %}


A Little Extra
==============

If you take a look at the first image, in the above loop, we see that there is anomaly in the red border. Upon further inspection, it turns out that there are times when there will be no red points on the left border, but two red points on the right border (the algorithm ignores situations when there is only one red in a row).

One possible solution is to increase the jump:


{% highlight r %}
area(files[1], jump=5)
{% endhighlight %}

![plot of chunk unnamed-chunk-17](/img/2013-04-06-area-determination-of-property-images/unnamed-chunk-17.png) 

{% highlight text %}
## [1] 32412  1848
{% endhighlight %}


Alternatively, we can iterate through the `min.red` and `max.red` values, and see if there are any anomalies. But this is equivalent to putting more significant figures on an already crude estimate - we'll leave it here for today.
