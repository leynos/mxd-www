# Website Feature Gap Analysis

This document focuses on prominent planned or implemented functionality in the
design, ADR, and reference documents that is not covered, or not covered
adequately, by the website under `mxd/`.

The key theme is not that the site is too short. It is that the site often
talks at a high level about a capability while omitting the parts of the
reference set that define how that capability actually works, what its
constraints are, or whether it is already implemented.

## 1. Runtime modes and binary selection

The reference set documents two operational binaries, `mxd` and
`mxd-wireframe-server`, plus feature-gated runtime selection and a
wireframe-only build path. `docs/users-guide.md` treats this as core user
facing behaviour.

The site mentions the Wireframe server in the quickstart and installation
pages, but it does not document the runtime model as a first-class concept. It
does not explain:

- that `legacy-networking` remains enabled by default;
- that disabling it changes the produced binaries and active runtime;
- that both binaries share the same CLI and admin subcommands; or
- that runtime selection itself is part of the documented behaviour coverage.

This omission matters because the reference set treats runtime selection as a
real operator and developer decision, not just a build detail.

## 2. Handshake semantics and compatibility negotiation

The reference set gives detailed treatment to the handshake and login
compatibility path:

- 12-byte preamble;
- 8-byte reply with explicit error codes;
- handshake timeout behaviour;
- sub-protocol and sub-version recording;
- XOR heuristics;
- login field 160 as a compatibility signal;
- login reply fields 161 and 162 for Hotline clients; and
- omission of those fields for SynHX.

That detail is spread across `docs/design.md`, `docs/users-guide.md`,
`docs/internal-compatibility-matrix.md`, and ADR-002 and ADR-003.

The site does not document this accurately or completely. The gap is not merely
missing colour. It is missing operationally important protocol behaviour that
the references treat as the compatibility boundary.

## 3. File-sharing subsystem depth

`docs/file-sharing-design.md` and the file-sharing sections of
`docs/design.md` describe a much richer file subsystem than the website
documents. Notable missing material includes:

- object-store-backed file content with database-backed metadata;
- resumable download and upload mechanics;
- `GetFileInfo`, `SetFileInfo`, `DeleteFile`, `MoveFile`, `MakeFileAlias`,
  `DownloadFolder`, and `UploadFolder`;
- alias semantics;
- drop boxes and upload-only visibility rules;
- folder and file comments;
- folder-level and per-file ACLs; and
- flat-object-store versus hierarchical-folder mapping.

The site currently reduces this area to short mentions of hierarchical file
sharing, database choices, and a few roadmap bullets. That leaves out the
largest body of subsystem-specific design work in the reference set.

## 4. Chat, presence, and direct-message model

The reference set gives significant space to chat and presence:

- public lobby semantics;
- private or group chat creation via invites;
- accept and decline flows;
- chat subjects;
- join and leave behaviour;
- chat history persistence;
- chat membership tables;
- direct-message modelling as private chats; and
- presence notifications tied to authenticated sessions.

The site only exposes fragments of this. The home page says chat and private
messaging are implemented, and the roadmap page names public chat and private
messaging as planned, but the site never documents the actual feature model
defined in `docs/chat-schema.md` and `docs/design.md`.

The gap is especially important because the references themselves say parts of
chat are designed and migrated but not yet fully utilised in code.

## 5. News hierarchy and article-thread structure

`docs/news-schema.md` and the news sections of `docs/design.md` describe a
hierarchical system with bundles, categories, threaded articles, linked-list
navigation pointers, permissions, and recursive-CTE-backed traversal.

The site only refers to threaded news in passing and does not explain:

- bundles versus categories;
- article linking fields such as parent, previous, next, and first child;
- read and unread state assumptions;
- news-specific permissions;
- recursive traversal requirements; or
- how the schema maps to Hotline transactions.

This makes the website under-document a large portion of the design material
that explains why the database and verification strategies look the way they
do.

## 6. Compatibility matrix governance and evidence discipline

The internal compatibility matrix is one of the clearest reference documents in
the set. It specifies:

- the actual supported client profiles;
- the difference between `Supported`, `Partial`, and `Planned`;
- the exact supported scope for each profile;
- known deviations;
- required client toggles; and
- evidence sources down to feature-scenario names.

The website does not reuse that level of discipline. It does not surface the
real matrix rows, the required toggles for SynHX XOR mode, or the narrow scope
of currently implemented compatibility work.

In practice, this is a documentation gap in evidence handling, not only a gap
in feature coverage.

## 7. Verification workflow detail

The website gives a good high-level description of the verification stack, but
`docs/verification-strategy.md` contains more actionable material that is not
carried into the site:

- the boundary between domain verification and adapter verification;
- the explicit tool-choice workflow;
- the local commands used to run TLC, Stateright, and Kani;
- the rule that counterexamples become regression tests;
- the split between pull-request verification depth and nightly verification
  depth; and
- the specific invariants called out for privileges, news threading, and drop
  box visibility.

The site therefore documents verification as a posture more than as an
engineering workflow.

## 8. Wireframe library capabilities that shape the mxd integration

`docs/wireframe-users-guide.md` documents a large amount of transport-library
functionality that influences the mxd design:

- custom frame codecs;
- fragmentation helpers and reassembly helpers;
- request metadata versus streaming request bodies;
- middleware layering;
- connection lifecycle;
- push queues and connection actors;
- streaming responses;
- client runtime behaviour; and
- metrics and observability.

The mxd website references Wireframe throughout the architecture story, but it
does not explain the parts of Wireframe that the design documents rely on when
discussing routing, compatibility hooks, streaming, and session handling.

That is a documentation gap because the references do not treat Wireframe as an
incidental library. They treat it as the transport adapter that shapes much of
the system.

## 9. Release-governance specifics

`docs/release-notes-qa-sign-off.md` defines a concrete QA-sign-off statement
and reviewer prompts. The site talks about release-note discipline and matrix
governance, but it does not surface:

- the exact required QA statement;
- the reviewer prompts;
- the rule that matrix evidence must still match current behaviour; or
- the need to record deviations in both release notes and the matrix.

This leaves the site weaker as an operator or reviewer reference than the
reference set.

## 10. Explicit statement of what is only designed versus implemented

A repeated gap across the site is the lack of a clean boundary between
designed, partially implemented, and fully implemented features.

The reference set makes that distinction repeatedly:

- `docs/internal-compatibility-matrix.md` does it for client support.
- `docs/design.md` does it for chat and other subsystems.
- `docs/users-guide.md` does it for runtime and compatibility behaviour.
- the roadmap page itself does it for planned work.

The site needs a stronger convention for this. Right now, readers must infer
implementation status from contradictions between the home page, the protocol
page, the compatibility page, and the roadmap.
