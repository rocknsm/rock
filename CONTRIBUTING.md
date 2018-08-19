# Contributing to RockNSM

We're super glad to have you helping out with the project. Before you submit code, it's important to understand that this entire project is licensed according to the contents of [LICENSE](./LICENSE). This includes any code that you commit. We created this project to do good in the NSM community. I know for a fact that more than one commercial company leverages this work in their products and services. What's important to me is that you or I could do the same thing and make the world of cyber a safer place. I hope that if you do leverage this work for your commerical or corporate ventures, you can contribute back to the community by way of filing issues, creating documentation, or fixing bugs.

## QUESTIONS ?

We're just a handful of developers and engineers and probably need better communication mediums. For now, if you have questions, head over to the docs on http://rocknsm.io/ and see if that helps. If you still need help, visit our [mailing list](https://groups.google.com/forum/#!forum/rocknsm) at Google Groups. If you think you found a bug, please file an issue - better yet, submit a patch!

The GitHub issue tracker is not the best place for questions for various reasons, but both the docs and the mailing list are very helpful places for those things.

## Contributing

Please see the [CODING_GUIDELINES](./CODING_GUIDELINES.md) for information on code style and general best practices when contributing to this project.

If you have a bugfix or new feature that you would like to contribute to RockNSM, please find or open an issue about it first. Talk about what you would like to do. It may be that somebody is already working on it, or that there are particular issues that you should know about before implementing the change. This helps prevent wasted time for both parties.

We enjoy working with contributors to get their code accepted. There are many approaches to fixing a problem and it is important to find the best approach before writing too much code.

The process for contributing to any of the [RockNSM repositories](https://github.com/rocknsm/) is similar. Details for individual projects will be highlighted on the contributing page for each project as needed.

### Fork and clone the repository

We follow the [GitHub forking model](https://help.github.com/articles/fork-a-repo/) for collaborating on RockNSM code. This model assumes that you have a remote called `upstream` pointing to the official ROCK repo, which we'll refer to in later code snippets.

This helps us keep the main project repository organized and provides you with a safe playground until you are ready to submit a pull request.

### Commits and Merging

* Feel free to make as many commits as you want, while working on a branch.
* When submitting a PR for review, please perform an interactive rebase to present a logical history that's easy for the reviewers to follow.
* Please use your commit messages to include helpful information on your changes and an explanation of *why* you made the changes that you did.
* Resolve merge conflicts by rebasing the target branch over your feature branch, and force-pushing (see below for instructions).
* When merging, we'll squash your commits into a single commit.

#### Rebasing and fixing merge conflicts

Rebasing can be tricky, and fixing merge conflicts can be even trickier because it involves force pushing. This is all compounded by the fact that attempting to push a rebased branch remotely will be rejected by git, and you'll be prompted to do a `pull`, which is not at all what you should do (this will really mess up your branch's history).

Here's how you should rebase master onto your branch, and how to fix merge conflicts when they arise.

First, make sure devel is up-to-date.

```
git checkout devel
git fetch upstream
git rebase upstream/devel
```

Then, check out your branch and rebase devel on top of it, which will apply all of the new commits on devel to your branch, and then apply all of your branch's new commits after that.

```
git checkout name-of-your-branch
git rebase devel
```

You want to make sure there are no merge conflicts. If there are merge conflicts, git will pause the rebase and allow you to fix the conflicts before continuing.

You can use `git status` to see which files contain conflicts. They'll be the ones that aren't staged for commit. Open those files, and look for where git has marked the conflicts. Resolve the conflicts so that the changes you want to make to the code have been incorporated in a way that doesn't destroy work that's been done in devel. Refer to devel's commit history on GitHub if you need to gain a better understanding of how code is conflicting and how best to resolve it.

Once you've resolved all of the merge conflicts, use `git add -A` to stage them to be committed, and then use `git rebase --continue` to tell git to continue the rebase.

When the rebase has completed, you will need to force push your branch because the history is now completely different than what's on the remote. **This is potentially dangerous** because it will completely overwrite what you have on the remote, so you need to be sure that you haven't lost any work when resolving merge conflicts. (If there weren't any merge conflicts, then you can force push without having to worry about this.)

```
git push origin name-of-your-branch --force
```

This will overwrite the remote branch with what you have locally. You're done!

**Note that you should not run `git pull`**, for example in response to a push rejection like this:

```
! [rejected] name-of-your-branch -> name-of-your-branch (non-fast-forward)
error: failed to push some refs to 'https://github.com/YourGitHubHandle/rock.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

Assuming you've successfully rebased and you're happy with the code, you should force push instead.

### Submitting your changes

Once your changes and tests are ready to submit for review:

1. Rebase your changes

    Update your local repository with the most recent code main RockNSM repository, and rebase your branch on top of the latest devel branch. We prefer your initial changes to be squashed into a single commit. Later, if we ask you to make changes, add them as separate commits.  This makes them easier to review.  As a final step before merging we will either ask you to squash all commits yourself or we'll do it for you.


2. Submit a pull request

    Push your local changes to your forked copy of the repository and [submit a pull request](https://help.github.com/articles/using-pull-requests) against the devel branch. In the pull request, choose a title which sums up the changes that you have made, and in the body provide more details about what your changes do. Also, mention the number of the issue where discussion has taken place, eg "Closes #123".

Then sit back and wait. Most of the people working on this project have separate full-time responsibilities, so any discussion or review that needs to take place may not happen immediately.

Please adhere to the general guideline that you should never force push to a publicly shared branch. Once you have opened your pull request, you should consider your branch publicly shared. Instead of force pushing
you can just add incremental commits; this is generally easier on your reviewers. If you need to pick up changes from master, you can merge master into your branch. A reviewer might ask you to rebase a long-running pull request in which case force pushing is okay for that
request.

## Bug to report?
You can report bugs or make enhancement requests at the RockNSM GitHub [issue page](https://github.com/rocknsm/rock/issues/) by filling out the issue template that will be presented.

Also please make sure you are testing on the latest released version of RockNSM or the development branch (`devel`).
