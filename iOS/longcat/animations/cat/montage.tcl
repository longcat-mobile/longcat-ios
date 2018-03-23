#!/usr/bin/tclsh

set    tile [llength [glob -types f "cat_top_*.png"]]
append tile "x1"

exec montage cat_top_*.png -tile $tile -geometry 168x120+0+0 -background none PNG32:cat_top.png

set    tile [llength [glob -types f "cat_bottom_*.png"]]
append tile "x1"

exec montage cat_bottom_*.png -tile $tile -geometry 168x96+0+0 -background none PNG32:cat_bottom.png
