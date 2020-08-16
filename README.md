# clip

Inspect and manipulate the clipboard

## Installation

```
git clone git@github.com:marionebl/paste.git
cd paste
swift build
ln -s $(pwd)/.build/release/clip /usr/local/bin/clip
```

## Usage

```sh
$ clip list
------
html
------
<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"></head><body><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry.</body></html>
------
string
------
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
```

```sh
$ clip copy --data="Hello, World!"
$ clip paste
Hello, World!
```

```sh
$ clip copy --data="<h1>Hello, World!</h1>" --type="html"
$ clip paste --type="html"
<h1>Hello, World!</h1>
```