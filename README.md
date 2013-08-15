## What is Octostrap?

Octostrap is [Octopress](http://octopress.org) blogging at its finest. And by finest, that means [Bootstrap](http://getbootstrap.com).

Basically, we're just getting started, and we've stuck to getting a runnable Octopress+Bootstrap environment going in under 5 minutes (and that's if you're internet connection is slow).

## Bootstrap v2 and v3 Supported

Octostrap includes support for Bootstrap versions 2 and the currently in-development version 3 variant. Simply path your CSS and JS imports with `/v2/` and `/v3/` to select your version.

## Immediate Gratification for the Internet Generation

###[Do you want to see what Octostrap looks like?](http://bobwaycott.github.io/octotest/)

**Still interested? Read on!**

Okay, here's the fun part.

**[Note: We assume you're starting with an empty repo for your project]**

## The Impatient Guide to Getting Started

### Assumptions: 

The *Impatient Guide to Getting Started* assumes the following:

- You already have Ruby 1.9.3 installed on your system (whether as default, or via rbenv/rvm)
- You already have `bundler` installed on your system
- You have probably setup Octopress or Jekyll before

Not you? Checkout [*The Complete Guide to Getting Started*](#the-complete-guide-to-getting-started) instead.


### Clone Octostrap

```
$ git clone https://github.com/bobwaycott/octostrap.git your_project_dir
$ cd your_project_dir
```

### Install dependencies

```
$ bundle install
```

### Octostrap Setup

Let's tell Octostrap to setup our new site.

```
$ rake setup
```

**Done! Seriously. That is all.**

### Octostrap Preview

Ready to see verify Octostrap is working?

```
$ rake preview
```

Visit `http://localhost:4000/` in your browser. See Octostrap. Shed tears (of joy).

Let's see [what setup looks like](#full-example-what-does-setup-look-like).

## The Complete Guide to Getting Started

Okay, so you've never installed Octopress or Jekyll before. This guide is for you. We'll cover just about all you need to know--or at least point you in the right direction to resources that will more fully explain what you need to do.

Here are the critical bits you must solve on your end:

- Install Git
- Install Ruby 1.9.3 (Octostrap expects 1.9.3-p194; newer versions should be fine)
- Install Bundler

We expect most users to have a preferred way of getting this done on their systems. We use OSX + [Homebrew](http://brew.sh). If you're on Linux/Unix, trust your distro's package manager to get **git** and **ruby** installed (if they aren't already).

### Clone Octostrap

```
$ git clone git@github.com:bobwaycott/octostrap.git your_project_dir
$ cd your_project_dir
```

Alright, Octostrap cloned and we're in the project directory. 

### Install Dependencies

Make sure Ruby is reporting the right version.

```
$ ruby --version
ruby 1.9.3-p194
```

Not what you see? Then you'll need to fix that. Check out the [rbenv or rvm section](#rbenv-or-rvm) before continuing.

Okay, you should have Ruby 1.9.3 installed by now. Time to install dependencies:

```
$ gem install bundler
$ rbenv rehash # if you're using rbenv, you must do this so you can use the bundle command
$ bundle install
```

When `bundle install` completes without errors, you should have everything you need to start using Octostrap.

### Octostrap Setup

Let's tell Octostrap to setup our new site. If all dependencies were installed, you should not encounter any errors, and you should be able to let the Octostrap Friendly Setter-Upper&trade; walk you through all the steps to get your Octostrap site ready to go.

```
$ rake setup
```

**Done! Seriously. That is all.**

### Octostrap Preview

Ready to see verify Octostrap is working?

```
$ rake preview
```

Visit `http://localhost:4000/` in your browser. See Octostrap. Shed tears (of joy).

Let's see [what setup looks like](#full-example-what-does-setup-look-like).


## rbenv or rvm

Shouldn't matter. You can probably do just fine without either if you don't do anything else with Ruby on your system and don't need different versions. If you are considering using either of those tools to simplify your life, allow us to put in a good word for `rbenv`. We like it.

**Want rbenv?** Make sure you've already installed `git` on your system. Once you know you're ready, [head over to rbenv's installation instructions](https://github.com/sstephenson/rbenv#installation). If you're on OS X, you can even [install easily with Homebrew](https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x). Make sure to come back when you're ready to proceed.

**Want rvm?** Then just [head over to rvm's installation instructions](https://rvm.io/rvm/install). Make sure to come back when you're ready to proceed.


## Full Example: What does setup look like?

```
$ rake setup

## Copying StarterPack into ./source ...
mkdir -p source
cp -r .starterpack/source/. source
cp .starterpack/config.yml.example ./_config.yml
mkdir -p public
## StarterPack copied. You can now `rake preview` and see your Octostrap site when setup is complete.

Octostrap includes Event functionality that can now be included
  Note: This is intended for campaign/political action sites that need to organize protests/events

Would you like to setup Octostrap Events? [y/n] y

Starting Events setup ...
cp -r .starterpack/events/. source/_layouts/
mkdir -p .data
cp -r .starterpack/data/. .data

Events setup complete!

Would you like to proceed with Github repo setup? [y/n] y

Starting Github setup ...
Enter the read/write url for your repository
(For example, 'git@github.com:your_username/your_repo.git')
           or 'https://github.com/your_username/your_repo.git')

Repository url: git@github.com:username/repo_name.git

Altering git config to use git@github.com:username/repo_name.git as origin...

Renaming remote origin to octostrap
Added remote git@github.com:username/repo_name.git as origin
Set origin as default remote

I can go ahead and push this to origin if you'd like
NOTE: You should probably only do this with a bare repository and an internet connection

Shall I push to your repo? (y/n) y

Pushing to your repo ...

Counting objects: 460, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (249/249), done.
Writing objects: 100% (460/460), 309.38 KiB | 0 bytes/s, done.
Total 460 (delta 194), reused 453 (delta 191)
To git@github.com:username/repo_name.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.

---
## Takeover complete! ##

Would you like to proceed with Github Pages setup? [y/n] y

Starting Github Pages setup ...

rm -rf public
mkdir -p public/repo_name
## Site's root directory is now '/repo_name' ##
rm -rf _deploy
mkdir _deploy
cd _deploy
Initialized empty Git repository in /path/to/repo_name/_deploy/.git/
[master (root-commit) 1fdca24] Octostrap init
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
cd -

---
## Success! Now you can deploy to http://username.github.io/repo_name with `rake gen_deploy` ##
```


## Github Pages: Setup being super helpful

Okay, so you ran `rake setup` and told Octostrap to setup Github Pages. Ready to prove that everything worked?

```
$ rake gen_deploy
```

Watch as your Octostrap site is uploaded to Github before your eyes. Wahoo.

**Disclaimer:** *Github can take up to 10 minutes to register your new site before you'll see it. But trust us. This works.*

**[IMPORTANT]**
When you `setup_github_pages`, your site root is going to switch to be the `repo_name` name from your Github repo instead of the default `/` path. This ensures that all assets have properly generated URLs (or else Github Pages won't show you any Bootstrap prettiness). This means that when you `rake preview` an Octostrap site that has Github Pages enabled, you'll visit `http://localhost:4000/repo_name/` instead of the default `http://localhost:4000/` location.

## Additional Documentation

Check out [Octopress docs](http://octopress.org/docs) for guides and documentation specific to Octopress.

Check out [Jekyll docs](http://jekyllrb.com) for guides and documentation specific to Jekyll (which powers all of this).

Check out [Bootstrap docs](http://getbootstrap.com/getting-started/) for guides and documentation specific to Bootstrap.

## Stuff to Do

Here's a quick list of things that are totally untested that tend to work out-of-the-box with vanilla Octopress:

- syntax highlighting for code samples
- plugins working with Bootstrap styles
- Octopress-specific JavaScript
- Bootstrap JavaScript-based components and interactivity
- probably more

## What's Missing

**SASS/LESS.**

Bootstrap CSS and JavaScript is included in the `source/stylesheets/bootstrap` and `source/javascripts/bootstrap` folders, respectively. There's a couple example pages included and example layouts. We haven't even begun to dig into allowing Bootstrap styles to work in SASS/LESS form.

## Contributing

[![Build Status](https://travis-ci.org/bobwaycott/octostrap.png?branch=master)](https://travis-ci.org/bobwaycott/octostrap)

We love to see people contributing to Octostrap, whether it's a bug report, feature suggestion or a pull request. At the moment, there's plenty left to get working just right in Octostrap, some of which is noted in the **Stuff to Do** section.

## License
(The MIT License)

Copyright © 2009-2013 Brandon Mathis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#### If you want to be awesome.
- Proudly display the 'Powered by *Octopress* and *Bootstrap*' credit in the footer of your Octostrap site.
- Be active and healthy.
- Love people.
- Make the world a better place.
