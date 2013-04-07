base <- "/Users/dfeng/dfeng.github.com/"
# set the directory to where your Rmd's reside
rmds <- "_Rmd"
setwd(base)

# manually files
filename <- "2013-04-06-area-determination-of-property-images.Rmd"

# path for folders
figs.path <- "img/"
posts.path <- "_posts/"

require(knitr)
render_jekyll(highlight="pygments")
opts_knit$set(base.url="/")

# restrict to .Rmd without the 'Processed' prefix
# files <- dir(rmds, pattern="^[^P]*.Rmd", full.names=TRUE)

file <- paste0(rmds, "/", filename)

# set filepath
fig.path <- paste0(figs.path, sub(".Rmd$", "", basename(file)), "/")
opts_chunk$set(fig.path=fig.path)

# suppress messages
opts_chunk$set(cache=F, warning=F, message=F, cache.path="_cache/", tidy=F)

out.file <- basename(knit(file))
file.rename(out.file, paste0(posts.path, out.file))
# file.rename(file, paste0(rmds, "Processed-", file))