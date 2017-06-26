const fs = require('fs');
const Benchmark = require('benchmark').Benchmark;
const suite = new Benchmark.Suite();

const parsers = {
    'markdown-it': (() => {
        const markdownit = require('markdown-it')('commonmark');
        return (source) => markdownit.render(source);
    })(),
    remarkable: (() => {
        const Remarkable = require('remarkable');
        const md = new Remarkable('commonmark');
        return (source) => md.render(source);
    })(),
    marked: (() => {
        const marked = require('marked');
        return (source) => marked(source);
    })(),
    showdown: (() => {
        const showdown = require('showdown');
        const converter = new showdown.Converter();
        return (source) => converter.makeHtml(source);
    })(),
    commonmark: (() => {
        const commonmark = require('../lib/index.js');
        const reader = new commonmark.Parser();
        const writer = new commonmark.HtmlRenderer();
        return (source) => writer.render(reader.parse(source));
    })(),
    'markdown-js': (() => {
        const markdown = require('markdown').markdown;
        return (source) => markdown.toHTML(source);
    })(),
    // micromarkdown: (() => {
    //     const mmd = require('micromarkdown');
    //     return (source) => mmd.parse(source);
    // })(),
    'nano-markdown': (() => {
        const nmd = require('nano-markdown');
        return (source) => nmd(source);
    })(),
};

const benchfile = process.argv[2];

const contents = fs.readFileSync(benchfile, 'utf8');

for (const key in parsers) {
    suite.add(key, () => {
        parsers[key](contents);
    });
}

suite.on('cycle', (event) => console.log(String(event.target))).run();
