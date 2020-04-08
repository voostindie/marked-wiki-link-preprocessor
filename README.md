# Marked Wiki Link Preprocessor

## What's this?

This is a custom preprocessor for Marked 2 that does these things:

- It adds a link below the title (the level 1 header on the first line) to edit the file.
- It converts every [[Wiki Link]] into one of two things, depending on whether the link could be resolved to an existing file or not:
	- If resolved: a clickable link that opens in Marked 2 itself.
	- If unresolved: an emphasized text followed by a link to create the file.

Make sure to read on to prevent surprises.

## Requirements

- A Mac
- A great love for keeping the things you write in Markdown files on disk.
- [Marked 2](https://www.marked2app.com)
- [iA Writer](https://ia.net/writer) or [TextMate](https://macromates.com)

## How files get resolved

Files that go together are expected to live in a *repository*. A repository is any directory with a `.datrc` file in it. All Markdown files in a repository are expected to have the `.md` extension.

In a repository, file names are expected to be unique by their base name alone, independent on where they live within the repository. The text in the [[Wiki Link]] refers to this base name, without its `.md` extension.

An example is probably in order. Consider this directory structure:

```
"/Users/vincent/Work"
├── ".datrc"
├── "Articles"
│   └── "My First Article.md"
└── "Notes"
    └── "2020-04-08 My First Note.md"
```

The directory `/Users/vincent/Work` is a repository, because it contains a `.datrc` file.

This repository has two Markdown files. One with key *My First Article* and one with key *2020-04-08 My First Note*. No directory, no extension.

If I'd like to point to the article from the text of the note, I do so as follows: `[[My First Article]]`

Why does it work like this? Easy: this way you can move files around on disk, and as long as you don't rename them and keep them under the root of the repository, links keep working.

## About text editors

My editor of choice at this moment is iA Writer. This editor supports URL commands both to edit existing files and to create new files. 

I also like TextMate, but this editor doesn't support the creation of new files through a URL command. The big pros of TextMate however are that it's free and that it doesn't require any configuration, and that's why it's the default.

Other editors are not supported as of this moment, but adding support for more should be very easy.
 
## Contents of the `.datrc` file

The `datrc` file contains, at the moment, only the configuration of the editor. It can be empty, in which case you'll get TextMate. To configure iA Writer instead, put the following in it:

```
editor: iA Writer
iA Writer:
	location: <Library Path>
	token: <Authentication Token>
```

(The idea behind this setup is that you can switch editors easily, while keeping individual editor configurations intact.)

You can find the value for `<Library Path>` by option-clicking on the Location of your choice in iA Writer's Organizer and selecting **Copy Library Path**. For example in the case of iCloud you'll get `/Locations/iCloud/`. (On disk the location is something like `/Users/<USERNAME>/Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents`. Make sure to put a `.datrc` file in there!)

You can find the value for `<Authentication Token>` by going to iA Writer's preferences, enabling the **Enable URL commands** checkbox and clicking the **Manage...** button.

Once you have this configured, you're all set! Apart from setting up Marked 2, that is...

## Configuring Marked 2

To get Marked 2 to use this custom preprocessor, you have to enable it: go to **Preferences**, **Advanced**, select **Preprocessor** and fill in the path to the `marked_wiki_link_preprocessor` in the `exe` directory of your clone of this repository.

This preprocessor ought to run fine on macOS's system Ruby; no additional gems are needed. I'm running macOS Catalina 10.15.4, with Ruby 2.6.3.

When preprocessing a file that's not in a repository, the preprocessor doesn't do anything by the way.

## Resolved link cache

Resolving files on disk takes a little time, especially if you have a big repository. That's why resolved files are cached, in a file called `.marked`, at the root of the repository. (Next to the `.datrc` file).

If you move files around, the cache probably gets corrupted. No sweat! If that happens, just delete the `.marked` file.

Oh, and don't put the `.marked` file under version control. There's no value in that.
