---
layout: post
title: Tmux + Neovim for Robotics Development - Part 1 Dotfiles
---

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Tmux + Neovim for Robotics Development - A Series](#tmux--neovim-for-robotics-development---a-series)
    * [Motivation](#motivation)
* [Version Controlling Dotfiles](#version-controlling-dotfiles)
    * [Option 1: Symlinks and Dotbot - Recommended](#option-1-symlinks-and-dotbot---recommended)
    * [Option 2: Bare Git Repository](#option-2-bare-git-repository)
* [Tips for Maintaining Dotfiles](#tips-for-maintaining-dotfiles)
    * [Naming Dotfiles](#naming-dotfiles)
    * [Meld or Diff Before Replacing](#meld-or-diff-before-replacing)
    * [Conditional Path Extensions](#conditional-path-extensions)
    * [Reference Peers Dotfiles and Share Your Own](#reference-peers-dotfiles-and-share-your-own)

<!-- vim-markdown-toc -->

## Tmux + Neovim for Robotics Development - A Series

This article is the first of a series on robotics software development using
[neovim](https://neovim.io/) and [tmux](https://github.com/tmux/tmux), and a few
other loosely-related CLI tools.

**This is an opinionated series**. Comparisons are based on my subjective
experience, but I will try to breakdown trade-offs where appropriate.
Development environments are highly individualized, even within the same
application domain. That said, I would love to hear your feedback.

### Motivation

For over 6 years now, I have been developing robotic software systems with
[ROS](https://www.ros.org/), a framework which requires frequent interaction
with the Linux command-line interface (CLI) for configuring, launching, and
testing robotic systems. In that time, I have developed a deep appreciation for
certain characteristics of command-line tooling, namely:

- [the Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), in
  particular the preference for "small, sharp tools"
- the stability of command structures and options relative to the ever-changing
  nature of GUIs, desktop environments, and operating systems (e.g., git versus
  your favorite graphical git tool)
- the ability to use the same tooling on an embedded device (without X11
  forwarding)

However, robotics software development remains a relatively small sub-field of
professional software engineering, which often leads us to borrow tooling and
workflows from larger communities, including Linux system administration,
systems programming, big data, and web development.

The goal of this series is to introduce a focused set of CLI tools and workflows
which lend themselves to supporting robotics development, and perhaps encourage
younger robotics developers to invest in their shell development environment,
which will pay dividends throughout their careers.

## Version Controlling Dotfiles

Before you can begin to supercharge your development workflow with tmux and
neovim (or improve your existing workflow with those tools), we have to talk
about **dotfiles**. Dotfiles are a colloquial term for the hidden configuration
files which are located within a user's home directory and subdirectories on
UNIX-based systems (see also
[`XDG_CONFIG_HOME`](https://wiki.archlinux.org/title/XDG_Base_Directory)), named
after the leading dot (`.`) character characteristic of hidden files.

If you have developed software within a Linux environment, you have likely
edited some of these files — you may have even customized your `.bashrc`,
`.bash_profile`, or created a `.bash_aliases` for some of your favorite bash
functions. These files configure the shell and login environment, and are beyond
the scope of this series. However, these are often a Linux user's first
interaction with dotfiles, followed soon after by the configuration of installed
programs and tools like `git` or `ssh`.

**Your dotfiles should be tracked in a git repository and checked into source
control.** This provides a few benefits:

- **Efficiency** - Reduce the time to setup a new installation of Linux, or to
  synchronize changes between multiple machines
- **Sharing** - Easily share configuration files with peers (e.g., via public
  GitHub repository)
- **Change Management** - View the history of modifications to your config files
  (i.e., the main benefit of VCS)

Whether you work with many Linux devices or just one development machine, and
regardless of how frequently you setup a new Linux installation, you should be
tracking changes to dotfiles in version control (e.g., git).

There are many ways to achieve this, but I will highlight two: via **symlinks**
or **a bare repository**. While I will contrast the two in the following
sections, both are good options, with pretty minor trade-offs.

### Option 1: Symlinks and Dotbot - Recommended

Perhaps the most popular method of version-controlling dotfiles, is to migrate
them to a git repository within the `$HOME` folder, e.g., `$HOME/dotfiles/`, and
to symlink those files back to their original directories. While this can be
achieved without any external tooling, there is an excellent tool called
[dotbot](https://github.com/anishathalye/dotbot), which facilitates symlink
creation and can be embedded in your dotfiles as a submodule for a seamless
setup experience. The [dotbot](https://github.com/anishathalye/dotbot) repo
provides plenty of instructions for setting up a new or existing dotfiles
repository to use dotbot.

While the next option is able to achieve the same end using only git, I have
been pleased with using dotbot for many years and therefore am happy to
recommend it.

### Option 2: Bare Git Repository

This technique follows
[a tutorial from Atlassian](https://www.atlassian.com/git/tutorials/dotfiles),
and prevents the use of symlinks with some clever git configuration that
separates the working directory (your `$HOME` folder) from a bare git
repository, (e.g., `$HOME/.cfg`).

## Tips for Maintaining Dotfiles

Regardless of which of the two prior options you choose, here are a few useful
tips for maintaining a dotfiles repository through OS upgrades and across
multiple systems.

### Naming Dotfiles

Some popular dotfiles examples on GitHub will omit the leading dot character
from the source filename, e.g. `.bashrc -> /home/mallain/dotfiles/bashrc`,
however this can cause syntax highlighting to suffer in some editors and
therefore is not recommended.

### Meld or Diff Before Replacing

It is good practice when upgrading to new Linux distributions to use `diff` to
compare the default shell configuration for that distribution with that of your
dotfiles, before replacing the former. As an alternative, `meld` could be used
to merge in any changes interactively.

```
diff ~/.bashrc ~/dotfiles/.bashrc
```

### Conditional Path Extensions

As you begin to share shell configuration, you may experience a common pain
point. Say for instance, you install a new language or framework on machine A
which requires sourcing an environment script in `~/.bashrc` (e.g.,
`. $HOME/.cargo/env`), and you diligently check-in that change to your dotfiles.
A week later, you pull your dotfiles to machine B, and open a new terminal
session only to find an ugly error message.

```
-bash: /home/mallain/.cargo/env: No such file or directory
```

With experience and some bash scripting, you can begin to shape your dotfiles to
be resilient to these types of failures by adding bash conditionals (at the
small expense of shell startup time), e.g.,

```
# cargo env exists and is readable
if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
```

### Reference Peers Dotfiles and Share Your Own

[My dotfiles](https://github.com/mitchallain/dotfiles) are the result of many
years of professional development experience, but I was helped along by other
developers that thought to share their own configuration. Some of those are

- [ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles) - Netflix engineer
  and [YouTuber](https://www.youtube.com/@ThePrimeagen)
- [craftzdog](https://github.com/craftzdog/dotfiles-public) - Web developer and
  [YouTuber](https://www.youtube.com/@devaslife)
