#!/usr/bin/tclsh

set    tile [llength [glob -types f "*.png"]]
append tile "x1"

exec montage *.png -tile $tile -geometry 172x96+0+0 -background none PNG32:../cat_bottom.png
