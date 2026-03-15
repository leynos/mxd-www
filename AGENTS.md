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

## CSS Debugging

The `css-view` command is available for debugging. It produces a JSON dump of
the computed and de-duped CSS cascade for the site.
