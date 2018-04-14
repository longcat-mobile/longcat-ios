#!/usr/bin/tclsh

set    tile [llength [glob -types f "*.png"]]
append tile "x1"

exec montage *.png -tile $tile -geometry 172x120+0+0 -background none PNG32:../cat_top.png
