---
layout: post
title: "Jekyll and Knitr"
tags: [r, statistics]
tagline: "How to get R code in Github Pages"
---

With [Knitr][2], anything is possible (and ridiculously simple). Creating reproducible R code in your jekyll blog is as simple as

{% highlight r %}
library(knitr)
render_jekyll(highlight="pygments")
knit('file.Rmd')
{% endhighlight %}

In your .Rmd file, instead of displaying code (using the liquid templates + pygments)

{% raw %}
    {% highlight r %}
    library(knitr)
    {% endhighlight %}
{% endraw %}

we now have

    ```{r}
    library(knitr)
    ```

That's it, basically. You will probably want to set up some options (such as defining a path for images). I have created a .R file to automate everything for this blog, which you can find [here](https://github.com/dfeng/dfeng.github.com/blob/master/make.R).

Helpful resources:
 - jfisher's blog [post][1]
 - Yi Hui's [website](http://yihui.name/knitr/hooks)

[1]: http://jfisher-usgs.github.io/r/2012/07/03/knitr-jekyll/
[2]: http://yihui.name/knitr/
