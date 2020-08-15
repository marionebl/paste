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
$ clip copy --data="Hello, World!"
$ clip paste
Hello, World!
```

```sh
$ clip copy --data="<h1>Hello, World!</h1>" --type="html"
$ clip paste --type="html"
<h1>Hello, World!</h1>
```