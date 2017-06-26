#!/bin/sh env awk
BEGIN {
    CONVFMT="%2.1f";
    print "| Sample                   |markdown-it|remarkable |marked     |showdown   |commonmark |markdown-js|micro      |nano       |"
    print "|--------------------------|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|"
}
{
        if (/^bench\/samples\//) {
                sub(/bench\/samples\//, "");
                printf "|%-26s|", "[" $0 "]";
                samples[$0] = "bench/samples/" $0;
        } else if (/^markdown-it/) {
                sub(/,/, "");
                markdownit = $3;
        } else if (/^remarkable/) {
                sub(/,/, "");
                remarkable = $3;
        } else if (/^marked/) {
                sub(/,/, "");
                marked = $3;
        } else if (/^showdown/) {
                sub(/,/, "");
                showdown = $3;
        } else if (/^commonmark/) {
                sub(/,/, "");
                commonmark = $3;
        } else if (/^markdown-js/) {
                sub(/,/, "");
                markdownjs = $3;
        } else if (/^nano-markdown/) {
                sub(/,/, "");
                nano = $3;
                printf "%11s|%11s|%11s|%11s|%11s|%11s|%11s|%11s|\n",
                       (markdownit / showdown),
                       (remarkable / showdown),
                       (marked / showdown),
                       1,
                       (commonmark / showdown),
                       (markdownjs / showdown),
                       0,
                       (nano / showdown);
                markdownit = "";
                remarkable = "";
                marked = "";
                showdown = "";
                commonmark = "";
                markdownjs = "";
                nano = "";
        } else {
                next;
        }
}
END {
    printf "\n";
    for (sample in samples) {
        printf "[%s]: %s\n", sample, samples[sample];
    }
}
