#!/bin/bash
#
gnuplot << EOF
    reset
    set terminal pdfcairo enhanced color font 'Verdade,12'
    set output "Coverage.pdf"
    set style line 101 lc rgb '#000000' lt 1 lw 2
    set border 3 front ls 101
    set tics nomirror out scale 0.75
    set key fixed right top vertical Right noreverse noenhanced autotitle nobox
    set style histogram clustered gap 1 title textcolor lt -1
    set xtics border in scale 0,0 nomirror #rotate by -60  autojustify
    set yrange [:]
    set xrange [:]
    set xtics auto
    set ytics auto
    set format y '%.0s%cB'
    set key top left
    #set style line 4 lc rgb '#CC0000' lt 2 dashtype '---' lw 4 pt 5 ps 0.4 # --- red
    set style line 1 lc rgb '#990099'  pt 1 ps 0.6  # circle
    set style line 2 lc rgb '#004C99'  pt 2 ps 0.6  # circle
    set style line 3 lc rgb '#CCCC00'  pt 3 ps 0.6  # circle
    set style line 4 lc rgb 'red'  pt 7 ps 0.6  # circle
    set style line 5 lc rgb '#009900'  pt 5 ps 0.6  # circle
    set style line 6 lc rgb '#990000'  pt 6 ps 0.6  # circle
    set style line 7 lc rgb '#009999'  pt 4 ps 0.6  # circle
    set style line 8 lc rgb '#19004C'  pt 8 ps 0.6  # circle
    set style line 9 lc rgb '#CC6600'  pt 9 ps 0.6  # circle
    set style line 10 lc rgb '#322152' pt 10 ps 0.6  # circle
    set style line 11 lc rgb '#425152' pt 11 ps 0.6  # circle
    set grid
    set ylabel "Gain Megabytes (Original - Sorted)"
    set xlabel "Sequencing depth coverage"
    plot 'coverage.txt' u 1:(\$9-\$10) w lp ls 1 title 'All', 'coverage.txt' u 1:(\$9-\$11) w lp ls 2 title 'All preserving order', 'coverage.txt' u 1:(\$2-\$5) w lp ls 4 title 'headers', 'coverage.txt' u 1:(\$3-\$6) w lp ls 5 title 'DNA bases', 'coverage.txt' u 1:(\$4-\$7) w lp ls 6 title 'quality-scores'
    #plot 'coverage.txt' u 1:(\$9-\$10) w lp ls 1 title 'original-MizaR', 'coverage.txt' u 1:(\$9-\$11) w lp ls 2 title 'original-(MizaR+order)'
    #plot 'coverage.txt' u 1:(\$3-\$6) w lp ls 1 title 'original-MizaR bases'
    #plot 'coverage.txt' u 1:3 w lp ls 1 title 'bases original', 'coverage.txt' u 1:6 w lp ls 2 title 'bases mizar'
    #plot 'coverage.txt' u 1:9 w lp ls 1 title 'original', 'coverage.txt' u 1:10 w lp ls 4 title 'mizar', 'coverage.txt' u 1:11 w lp ls 5 title 'mizar + order'
EOF
#
evince Coverage.pdf &
