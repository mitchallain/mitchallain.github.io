# Mitchell's Blog

A blog on robotic software development (and other fringe interests) built around
the excellent Jekyll theme
[Immaculate](https://github.com/siawyoung/immaculate).

## Develop with Nix

> Bundix makes it easy to package your Bundler-enabled Ruby applications with
> the Nix package manager.

from [Bundix README](https://github.com/nix-community/bundix)

This repo depends on the nokogiri gem which appears to require special treatment
within nix. I was able to

- remove the `Gemfile.lock` and `gemset.nix`
- run `BUNDLE_FORCE_RUBY_PLATFORM=true nix run nixpkgs#bundix -- --lock`
  - this re-creates the lock file and gemset.nix with the ruby platform (this
    seems to have
    [something to do with use of pre-compiled binaries](https://nokogiri.org/tutorials/installing_nokogiri.html#why-would-i-not-want-to-use-a-native-gem)
    as
    [discussed here](https://discourse.nixos.org/t/issues-with-nix-reproducibility-on-macos-trying-to-build-nokogiri-ruby-error-unknown-warning-option/22019/8))

Note the
[nixpkgs entry for Ruby](https://nixos.org/manual/nixpkgs/stable/#sec-language-ruby)
and section on
[Developing with Ruby](https://nixos.org/manual/nixpkgs/stable/#developing-with-ruby)
were particularly helpful here.

## Development

See the [Jekyll docs](https://jekyllrb.com/docs/) and
[Immaculate](https://github.com/siawyoung/immaculate) theme README for more
info.

### Install Ruby and Bundler

First, install ruby using the system package manager.

```
sudo apt install ruby ruby-dev
```

Then, install bundler using gem

```
sudo gem install bundler
```

On Ubuntu, ensure `GEM_HOME` and `BUNDLE_PATH` are set within the user-space,
e.g., `~/.gems`.

### Install Site Repo and Deps

```
git clone git@github.com:mitchallain/mitchallain.github.io.git
cd mitchallain.github.io
bundle install
bundle exec jekyll serve --baseurl ''
```

To serve the site locally with the "livereload" option use

```
bundle exec jekyll serve --livereload
```

### Deploying to GitHub Pages

GitHub Pages has poor compatibility with local compilation, but the strategy I
am currently using is based on this
[StackOverflow post](https://stackoverflow.com/a/35798092).

Remove the contents of the `_site` directory.

```
rm -r _site/*
```

Clone the `gh-pages` branch to the `_site` directory.

```
git clone -b gh-pages `git config remote.origin.url` _site
```

Run jekyll build and push the new site contents to `gh-pages`.

```
jekyll build
cd _site
git add -A
git commit -m "Latest post"
```

# Immaculate

A beautiful, fast, AMP-compliant Jekyll theme based on Tufte CSS.

[Check it out here!](https://immaculate-siawyoung-com.cdn.ampproject.org/c/immaculate.siawyoung.com/)

[Google AMP](https://www.ampproject.org/)

[Tufte CSS](https://github.com/edwardtufte/tufte-css)

Immaculate is really fast, thanks to Google AMP. When served over Google's CDN,
you will see typical `DOMContentLoaded` times of well under 100ms (when using
the leaner stylesheet, see below). The benefits are most obvious for slower
connections. On the _Regular - 2G_ throttling setting in Chrome, the demo page
still manages a `DOMContentLoaded` of under 500ms.

Immaculate includes tag support for some of the more commonly-used Tufte CSS
layout options, including sidenotes, margin notes, and full-width figures. Other
features, such as `newthought` or epigraphs, can be used by typing raw HTML in
your Markdown files. I might add helper tags for these in the future.

**Caveat (need hep!)**: AMP HTML does not allow form elements, including
checkboxes, which are used in Tufte CSS to toggle the display of sidenotes and
margin notes at smaller widths. As such, I've modified Immaculate to disable
this functionality at smaller widths for the time being. It's a big deal, and
I'm looking for help on emulating this functionality without using checkboxes.

## Getting Started

```
git clone git@github.com:siawyoung/immaculate.git
cd immaculate
bundle install
bundle exec jekyll serve --baseurl ''
```

Modify the template files and `_config.yml` to your liking, and publish away!

## Helper Tags

Immaculate comes with a few helper tags. The source code for these tags can be
found in `_plugins/shortcodes.rb`.

### Image

```
{% image <src> <width> <height> <option?> %}
```

The `image` tag allows you to insert AMP-compliant images into the post.

`src` is the `src` attribute of the image tag.

`width` and `height` of the image must be specified, as per AMP specifications.

`option` - an optional argument which supports the following options:

- `fw` - makes the image full width
- `raw` - outputs the raw `amp-img` tag, can be used in conjunction with margin
  notes

##### Example usage

```
{% image https://image.com/image.jpg 1200 600 fw %}
```

### Youtube

```
{% youtube <id> <width> <height> <option?> %}
```

The `youtube` tag allows you to insert AMP-compliant embedded Youtube videos
into the post.

`id` is the Youtube viddeo ID.

`width` and `height` of the video must be specified, as per AMP specifications.

`option` - an optional argument which supports the following options:

- `fw` - makes the video full width
- `raw` - outputs the raw `amp-youtube` tag, can be used in conjunction with
  margin notes

##### Example usage

```
{% youtube aj2h3h1sf 600 400 %}
```

### Sidenote

(See caveat above)

```
{% sidenote <id> <body> %}
```

The `sidenote` tag allows you insert sidenotes into the post.

`id` is a unique identifier for the sidenote, and it can be anything - it will
not show up visually.

`body` is the body of the sidenote. It can also accommodate `span`-level HTML
elements (`<b>`, `<em>`, `<i>`, no block-level elements).

##### Example usage

```
This is a very long{% sidenote meh Yes, <i>very</i> long. %} sentence.
```

### Margin Note

(See caveat above)

```
{% marginnote <id> %}
<body>
{% endmarginnote %}
```

The `marginnote` tag block allows you to insert margin notes into the post.

`id` is a unique identifier for the margin note, and it can be anything - it
will not show up visually.

`body` is the body of the sidenote. It can also accommodate `span`-level HTML
elements (`<b>`, `<em>`, `<i>`, no block-level elements).

You can also use margin notes in conjunction with `image` and `youtube` tags by
specifying the `raw` option.

##### Example usage

```
{% marginnote yt %}
{% youtube aj2h3h1sf 350 200 raw %}
This is a <b>extremely</b> succinct example.
{% endmarginnote %}
```

### Blockquote

```
{% blockquote <footer> %}
<body>
{% endblockquote %}
```

Standard Markdown blockquotes are supported by Immaculate. Additionally, the
`blockquote` tag block allows you to insert Tufte-styled blockquotes with
footers.

##### Example usage

```
{% blockquote Friedrich Nietzsche, Thus Spoke Zarathustra %}

But say, my brothers, what can the child do that even the lion could not do? Why must the preying lion still become a child? The child is innocence and forgetting, a new beginning, a game, a self-propelled wheel, a first movement, a sacred “Yes.” For the game of creation, my brothers, a sacred “Yes” is needed: the spirit now wills his own will, and he who had been lost to the world now conquers the world.

{% endblockquote %}
```

## Even faster performance

By default, Immaculate will utilize Tufte CSS's default font stack, which uses
`et-book`. The custom font files are about 160kb in total, which is somewhat of
a strain. If performance is important, Immaculate also ships with a leaner
version of Tufte CSS, which uses just
[the Palatino stack instead](http://www.cssfontstack.com/Palatino). It has
99.29% Mac and 86.13% Windows distribution.

You just need to change the following line in `_includes/styles.scss`:

```
@import 'tufte';
// change to:
@import 'lean_tufte';
```

Just from pure anecdotal experience, using the leaner stylesheet reduces typical
`DOMContentLoaded` times from 300ms down to 50ms when served through Google's
CDN. Personally, `et-book` just looks a lot better to me, so pick whatever
floats your boat.

## Syntax highlighting

Immaculate supports syntax highlighting, but the stylesheet is commented out by
default to keep the page lean. Simply uncomment the following line in
`_includes/styles.scss`:

```css
// @import 'syntax-highlighting';
```

## FAQ

_How can I use the sans-serif versin of Tufte CSS, which uses Gill Sans?_

You can override the CSS style in `_includes/styles.scss` with the font stack of
your choice:

```
body {
  font-family: "Gill Sans"
}
```

## Credits

Credits to [Amplify](https://github.com/ageitgey/amplify) for most of the
AMP-related code.

## License

MIT
