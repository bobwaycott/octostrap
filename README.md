## What is Octostrap?

Octostrap is [Octopress](http://octopress.org) blogging at its finest. And by finest, that means [Bootstrap](http://getbootstrap.com).

Basically, this is just getting started, and we've stuck to getting a runnable Bootstrap environment going that allows you to clone, `bundle install`, and `rake preview`.

## Immediate Gratification for the Internet Generation

[So you want to see what it looks like?](http://bobwaycott.github.io/octotest/)

**Still interested? Read on!**

Okay, here's the fun part. You want to get a Bootstrap-based, Octopress-powered static site going in less than 5 minutes and in no more than 5 commands. Let's start with 3.

**[Note: We assume you're starting with an empty repo for your project]**

## The Impatient Guide to Getting Started (3 commands)

**Clone the Octostrap repo:**

```
$ git clone https://github.com/bobwaycott/octostrap.git your_project_dir
```

**Install dependencies**

```
$ cd your_project_dir
$ bundle install
```

**Done! Seriously. That is all.**

**Time for a preview?**

```
$ rake preview
```

Visit `http://localhost:4000/` in your browser. See Bootstrap. Shed tears (of joy).

**Want some help setting up your own Github repo?**

Let's see the **Takeover** example.

## Takeover: The Helpful Guide to Getting Started (4 commands)

**Clone the Octostrap repo:**

```
$ git clone https://github.com/bobwaycott/octostrap.git your_project_dir
```

**Install dependencies**

```
$ cd your_project_dir
$ bundle install
```

One of the additions Octostrap adds to vanilla Octopress is its `takeover` task.

**Takeover.** Here's how that looks:

```
$ rake setup

Enter the read/write url for your repository
(For example, 'git@github.com:your_username/your_repo.git')
           or 'https://github.com/your_username/your_repo.git')

Repository url: git@github.com:your_username/your_repo.git

Renaming remote origin to octostrap
Added remote git@github.com:your_username/your_repo.git as origin
Set origin as default remote

I can go ahead and push this to origin if you'd like
NOTE: You should probably only do this with a bare repository and an internet connection

Shall I push to your repo? (y/n) y

Pushing to your repo …

Counting objects: 298, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (190/190), done.
Writing objects: 100% (298/298), 283.28 KiB | 0 bytes/s, done.
Total 298 (delta 95), reused 298 (delta 95)
To git@github.com:your_username/your_repo.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.

---
## Setup complete! ##
```

**Done! Seriously. That is all.**

**Time for a preview?**

```
$ rake preview
```

Visit `http://localhost:4000/` in your browser. See Bootstrap. Shed tears (of joy).

**Takeover? Got it. But what about Github Pages?**

Alright, let's setup Github Pages deployment while you're at it. Let's see the **Takeover + Github Pages** example.

## Takeover+Github Pages: The Super Helpful Guide to Getting Started (5 commands)

**Clone the Octostrap repo:**

```
$ git clone https://github.com/bobwaycott/octostrap.git your_project_dir
```

**Install dependencies**

```
$ cd your_project_dir
$ bundle install
```

**Takeover**

```
$ rake takeover
```

**Setup Github Pages**

```
$ rake setup_github_pages
```

Just give it your Github repo, same as you did with `takeover`, and let it do its thing.

**Done! Seriously. That is all.**

Don't believe it?

```
$ rake gen_deploy
```

Watch as your Octostrap site is uploaded to Github before your eyes. Wahoo.

(*Disclaimer: Github can take up to 10 minutes to register your new site before you'll see it. But trust us. This works.*)

**Time for a preview?**

```
$ rake preview
```

Visit `localhost:4000/your_repo` in your browser. See Bootstrap. Shed tears (of joy).

When you `setup_github_pages`, your site root is going to switch to be the `your_repo` name from your Github repo instead of the default `http://localhost:4000/` path. This ensures that all assets have properly generated URLs (or else Github Pages won't show you any Bootstrap prettiness).

**Seriously. That is all.**

## Documentation

Check out [Octopress docs](http://octopress.org/docs) for guides and documentation specific to Octopress. Check out [Bootstrap docs](http://getbootstrap.com/getting-started/) for guides and documentation specific to Bootstrap.

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
