# MXD Website Agent Guidance

## Scope

This repository contains a prototype design for the MXD website that will later
be incorporated into a larger site.

## Source of Truth

- `mxd/` is the source of truth for the website content, structure, classes,
  imagery, and CSS.
- Treat any deployment output as secondary to `mxd/`.

## Current Priorities

Until the prototype is folded into the full site, focus on getting these parts
correct:

- CSS
- copy
- imagery
- semantic HTML
- semantic class names

## What Not to Optimize Yet

Do not invest effort in build automation, build pipeline work, or large-scale
refactoring for this prototype. That work will be handled later by the CMS
pipeline used by the full site.

## Deployment Context

Deployment to GitHub Pages is temporary. It exists only so the prototype can be
shared before it is incorporated into the larger website.

## Preview Workflow

- The user will start a `caddy file-server` instance on port `2018` when a live
  preview is needed.
- Do not attempt to start Caddy from the agent workflow.
- When using Playwright for previewing, point it at the existing server on port
  `2018`.

## Markdown Formatting

Run `make fmt` after changing Markdown. It rewrites the Markdown Git tracks,
plus untracked Markdown Git does not ignore, with
`mdtablefix --in-place --git --include-untracked --wrap --renumber --breaks
--ellipsis --fences`,
then runs `markdownlint-cli2 --fix "**/*.md"`. `make check-fmt` runs the same
mdtablefix command with `--check` and fails when a file would change. Install
mdtablefix 0.6.0 or later with `cargo binstall --no-confirm mdtablefix@0.6.0`
(or `cargo install --locked mdtablefix@0.6.0`). `.markdownlint-cli2.jsonc`
carries the estate's canonical markdownlint configuration, and CI lints
Markdown with the pinned `DavidAnson/markdownlint-cli2-action` in
`markdownlint.yml`.

## CSS Debugging

The `css-view` command is available for debugging. It produces a JSON dump of
the computed and de-duped CSS cascade for the site.

<!-- typos-config-builder:agents-md:start -->

## Spelling

- `make spelling` runs the pinned `typos-config-builder gate`, which
  regenerates `typos.toml` from the shared en-GB-oxendict dictionary and
  `typos.local.toml`, then checks spelling and the shared phrase corrections.
- `typos.toml` is generated: never edit it by hand. Put narrow
  repository-specific exceptions in `typos.local.toml`, as exact or full-line
  patterns rather than bare accepted words.
- When `make spelling` changes `typos.toml`, commit the regenerated file. If
  the change is unrelated to your work, commit it in a separate base pull
  request and stack your branch on it, so each review diff stays focused.

<!-- typos-config-builder:agents-md:end -->
