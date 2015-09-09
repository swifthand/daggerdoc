# DaggerDoc

**When you need to jot down some markdown-based docs *right now* and setting up a wiki is more effort than it's worth.**

A quickly-written Sinatra application that will scan a directory tree for markdown files and run a rack server (or rack daemon via included script file) that will serve those markdown files via the browser. Yeah that means you'll need Ruby.

Let's you version control simple documentation and not worry about endlessly running `markdown importantdoc.md`. I'm sure something like this already existed, but it took about as much time to write as it would have to search for such a solution.

Routes to your rendered documents are under `/docs/` and mirrors the directory tree. A `.md` file extension may be omitted, so `/foo/bar` will pull up `/foo/bar.md`.

### "That's not a knife..."

Yeah, it's barely a dagger. This is really incomplete stuff, and it might cut you. I might release it someday as a gem, an executable, a package... who knows what. For now it let's me write docs in Markdown and have them appear in a browser. That's what it was meant to do and it's already achieved that, so any more effort is a superfluous.

### Usage

Has been written (quickly) to run in **Linux with Ruby 2.2.**
Probably runs on Ruby 2.0 and 2.1.
Probably does not run on OS X or Windows.

If *docs-right-the-hell-now* still somehow interests you:

1. Clone this repository.
2. `bundle install`
3. Change `doc_path` in `config/settings.json` or run with a `DOC_PATH` environment variable.
4. `rackup`

Alternatively:

1. Symlink `script/daggerdoc` to somewhere in your $PATH (e.g. `$HOME/bin`).
2. Use `daggerdoc` command with a directory as an argument (e.g. `daggerdoc .`).
3. As a bonus it will even open a browser window to a list of all `.md` files found.

This alternative use is accomplished by (what I can only imagine are) sins against bash scripting. I welcome feedback about what could be done better, but I won't promise I have the time to *do anything* about it.

As it is, this README file is already starting to feel Yak-shave-y.

### Future Features (?)

I may never get around to any of these:

- More configuration jazziness.
- Some JavaScript to update the page's content on file system events. WebSockets?
- Improve the index page (currently shows folders five layers deep even if they have no markdown files).
- Maybe care about other OSes. Maybe.
- I don't think I'm using ActiveSupport for much. Could probably be removed or used more often. Both are fine.

### Love Letters

The [CommonMark](http://commonmark.org/) project, the [commonmarker](https://github.com/gjtorikian/commonmarker/) gem, [Skeleton CSS](http://getskeleton.com/) and of course [Sinatra](http://www.sinatrarb.com/).
