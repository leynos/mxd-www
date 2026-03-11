# Website Usage Inconsistencies

This document records inconsistencies between the user-facing behaviour implied
by the website under `mxd/` and the behaviour specified or documented in the
design, ADR, and reference documents supplied for this task.

## 1. Handshake flow is described differently on the site

The protocol page describes a 6-byte handshake containing only protocol ID and
version, and it says no handshake reply is sent.

The reference set documents a different user-visible flow:

- `docs/users-guide.md` says the Wireframe listener decodes a 12-byte handshake
  preamble;
- `docs/users-guide.md` says it sends an 8-byte reply with distinct error
  codes;
- `docs/design.md` and
  `docs/migration-plan-moving-mxd-protocol-implementation-to-wireframe.md`
  describe the same 12-byte preamble plus reply model.

Impact: anyone using the site as their protocol reference will implement the
wrong session-init exchange.

## 2. The site presents partial client support as if it were broad support

The home page says Hotline clients and SynHX connect without shims or
translation layers. The architecture page uses `Supported` language for
Hotline and SynHX variants. The quickstart tells readers to connect any Hotline
1.8.5-compatible client after launch.

The reference source of truth, `docs/internal-compatibility-matrix.md`, says:

- Hotline 1.8.5 is `Partial`;
- Hotline 1.9 is `Partial`;
- SynHX non-XOR is `Partial`;
- SynHX XOR is `Partial`; and
- user-list and messaging parity remain pending.

Impact: the site encourages operator expectations that are stronger than the
documented compatibility contract.

## 3. The compatibility page uses a different client roster from the reference matrix

The site lists Hotline Client, Frogblast, Pitbull Pro, Nostalgy, Helix Client,
Synapse, and Ambrosia.

The internal compatibility matrix lists Hotline 1.8.5, Hotline 1.9, SynHX
non-XOR, SynHX XOR, and unknown or legacy login versions.

Impact: the site cannot be used as a faithful rendering of the internal
compatibility matrix, even though it claims to be one.

## 4. Compatibility evidence references do not match the reference evidence

The site points readers at test files such as `tests/client_compat.rs`,
`tests/frogblast_suite.rs`, and `tests/synapse_login.rs`.

The reference matrix cites different evidence:

- `tests/features/wireframe_login_compat.feature`;
- `tests/features/wireframe_xor_compat.feature`; and
- specific compatibility-policy functions and scenarios.

Impact: the website teaches readers to look in the wrong place for evidence.

## 5. Designed features presented as implemented

The site's home page says mxd implements chat, threaded news, hierarchical file
sharing, and private messaging. The protocol page presents an implemented
transaction catalogue.

The references draw a sharper boundary:

- `docs/design.md` says the chat schema is designed and migrated but not yet
  fully utilised in code;
- `docs/internal-compatibility-matrix.md` limits currently supported scope
  heavily;
- the roadmap page marks most chat, file, and admin work as planned.

Impact: the site gives an inaccurate picture of what a user can rely on today.

## 6. Runtime selection is treated as a secondary note on the site

The reference set treats runtime choice as part of the documented user
interface:

- `docs/users-guide.md` has separate sections for launching the legacy server
  and the Wireframe server;
- it documents shared admin subcommands;
- it documents wireframe-only builds and runtime selection behaviour.

The site does mention the Wireframe server, but it does not document runtime
selection as a first-class operating mode.

Impact: readers of the site do not get the same operational picture as readers
of the user guide.

## 7. Verification artefact paths differ between the site and the references

The verification page uses examples such as `specs/handshake.tla` and
`verify/session_gate.rs`.

The verification strategy points readers elsewhere:

- TLA+ specs under `crates/mxd-verification/tla/`;
- Stateright models in `crates/mxd-verification/src/session_model`;
- specific Kani harness commands under the root crate.

Impact: a reader trying to follow the site's artefact pointers will not land on
the same source structure documented by the reference set.

## 8. Changelog navigation points outside the reference set

The changelog page tells readers that:

- release notes are maintained in `CHANGELOG.md`;
- the compatibility matrix lives in `docs/compatibility/`; and
- `ADR-004` explains codec rationale.

The provided references do not support those paths or that ADR number. The
release-governance document points to `docs/internal-compatibility-matrix.md`
instead.

Impact: the site's release-navigation surface is inconsistent with the supplied
reference corpus.

## 9. The site's release examples are temporally confusing

The compatibility page uses a changelog example dated `2026-03-15`. The
benchmark date for this task is `2026-03-11`.

Even if that block is intended as an illustrative example rather than a real
release note, it reads like a historical release snippet placed before that
date has occurred.

Impact: readers cannot tell whether they are looking at a real past release, a
planned future release, or a synthetic example.

## 10. Release governance is described more loosely on the site

`docs/release-notes-qa-sign-off.md` defines:

- the exact QA-sign-off statement to include;
- the rule that matrix evidence must still match current behaviour; and
- reviewer prompts for over-claiming.

The site talks about release-note discipline in broader terms but does not
preserve those exact usage rules.

Impact: the site is weaker as a procedural reference for maintainers and
reviewers than the design and QA documents it claims to represent.
