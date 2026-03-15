# Website Claims Benchmark

This document benchmarks the claims made by the static site under `mxd/`
against the design, architecture decision record (ADR), and reference documents
listed for this task.

## Benchmark legend

- `Confirmed`: the claim is supported by the reference set.
- `Partially supported`: the reference set supports part of the claim, but the
  site states it too broadly or omits an important constraint.
- `Contradicted`: the reference set says something materially different.
- `Unverifiable from reference set`: the claim is not backed by the provided
  references.

## Executive summary

The site is strongest when it describes the architectural shape of the system:
hexagonal boundaries, dual database support, configuration precedence, and the
verification stack are all grounded in `docs/design.md`,
`docs/users-guide.md`, `docs/developers-guide.md`, and
`docs/verification-strategy.md`.

The site is weakest when it describes current protocol completeness,
client-compatibility status, and release history. The most serious problems are
these:

1. The home page presents chat, threaded news, hierarchical file sharing, and
   private messaging as if they are fully implemented today. The reference set
   treats much of that surface as designed, partially routed, or still planned.
2. The protocol page documents the handshake as a 6-byte preamble with no
   reply. The reference set documents a 12-byte preamble and an 8-byte reply.
3. The compatibility page invents client profiles, support levels, and test
   modules that do not appear in `docs/internal-compatibility-matrix.md`.
4. The changelog page cites releases, supporting artefacts, and an `ADR-004`
   that are not present in the reference set.

## `mxd/index.html`

1. Claim: mxd implements Hotline server protocol v1.8.5 including login, chat,
   threaded news, hierarchical file sharing, and private messaging.

   Benchmark: `Partially supported`.

   The reference set clearly designs all of those subsystems, but it does not
   support presenting them as fully implemented. `docs/design.md` treats chat,
   direct messages, file sharing, and news as substantial subsystems with large
   amounts of planned or design-stage functionality. `docs/internal-
   compatibility-matrix.md` only marks login and selected compatibility hooks
   as implemented for Hotline 1.8.5, Hotline 1.9, and SynHX. The roadmap page
   on the site itself also marks most chat, file, and admin work as planned.

2. Claim: vintage Hotline clients and modern alternatives like SynHX connect
   without shims or translation layers.

   Benchmark: `Partially supported`.

   The references do support compatibility work for Hotline 1.8.5, Hotline 1.9,
   and SynHX, especially around login reply augmentation and XOR handling.
   However, `docs/internal-compatibility-matrix.md` marks Hotline 1.8.5,
   Hotline 1.9, and SynHX as `Partial`, not fully supported, and explicitly
   says user-list and messaging parity remain pending.

3. Claim: the architecture is hexagonal, the system supports SQLite and
   PostgreSQL, and correctness work uses TLA+, Stateright, and Kani.

   Benchmark: `Confirmed`.

   These claims are well supported by `docs/design.md`,
   `docs/adopting-hexagonal-architecture-in-the-mxd-wireframe-migration.md`,
   `docs/users-guide.md`, and `docs/verification-strategy.md`.

## `mxd/architecture/index.html`

1. Claim: the domain core is isolated from transport and persistence, with
   Wireframe as transport adapter and Diesel as storage adapter.

   Benchmark: `Confirmed`.

   This matches the hexagonal design described in `docs/design.md` and the
   migration guidance in
   `docs/adopting-hexagonal-architecture-in-the-mxd-wireframe-migration.md`.

2. Claim: `WireframeRouter` is the sole public routing entrypoint, and a
   `CompatibilityLayer` applies request and reply hooks on every routed
   transaction.

   Benchmark: `Confirmed`.

   This is exactly the accepted direction in
   `docs/adr-002-compatibility-guardrails-and-augmentation.md` and is restated
   in `docs/users-guide.md`.

3. Claim: `AuthStrategy` and `LoginReplyAugmenter` split login authentication
   and reply decoration.

   Benchmark: `Confirmed`.

   This is the core of `docs/adr-003-login-authentication-and-reply-
   augmentation.md` and is also described in `docs/users-guide.md`.

4. Claim: default Hotline, SynHX, and Hotline 1.8.5 and 1.9 are all
   `Supported`.

   Benchmark: `Contradicted`.

   `docs/internal-compatibility-matrix.md` marks Hotline 1.8.5, Hotline 1.9,
   SynHX non-XOR, and SynHX XOR as `Partial`. Only the conservative
   unknown-client behaviour is `Supported`.

## `mxd/protocol/index.html`

1. Claim: the session handshake is a 6-byte preamble containing only protocol
   ID and version, and no handshake reply is sent.

   Benchmark: `Contradicted`.

   `docs/users-guide.md`, `docs/design.md`,
   `docs/migration-plan-moving-mxd-protocol-implementation-to-wireframe.md`,
   and `docs/adopting-hexagonal-architecture-in-the-mxd-wireframe-migration.md`
   all describe a 12-byte handshake preamble. They also describe an 8-byte
   handshake reply with error codes for success, invalid protocol,
   unsupported version, and timeout.

2. Claim: the transaction catalogue shown on the page reflects the full set of
   transactions implemented by mxd.

   Benchmark: `Partially supported`.

   The references support login and selected file and news routing work, but
   they do not support the page's presentation of a settled implemented
   catalogue. `docs/users-guide.md` only claims routed coverage for login,
   authenticated-session continuity, file listing, and news routing flows.
   `docs/design.md` and the roadmap sections describe many file, chat, and
   messaging transactions as future or partially delivered work.

3. Claim: the complete transaction catalogue is generated from
   `docs/protocol.md`.

   Benchmark: `Unverifiable from reference set`.

   None of the provided reference documents is `docs/protocol.md`, and that
   path is not part of the benchmark set used for this task.

## `mxd/compatibility/index.html`

1. Claim: the compatibility matrix is the source of truth for current support
   claims, and unsupported behaviour is not claimed.

   Benchmark: `Contradicted`.

   The site says this, but the page itself violates the rule. The client list,
   statuses, and evidence on the page do not match
   `docs/internal-compatibility-matrix.md`.

2. Claim: supported or planned client profiles include Hotline Client 1.9.x,
   Frogblast, Pitbull Pro, Nostalgy, Helix Client, Synapse, and Ambrosia.

   Benchmark: `Contradicted`.

   The internal matrix only lists Hotline 1.8.5, Hotline 1.9, SynHX
   non-XOR, SynHX XOR, and unknown or legacy login versions. The site's other
   client names do not appear in the provided reference set.

3. Claim: `Supported` means automated tests verify handshake, login, file
   operations, chat, and news with no known regressions.

   Benchmark: `Contradicted`.

   The internal matrix defines `Supported`, `Partial`, and `Planned`
   conservatively, and its actual rows say that messaging parity and broader
   field-level parity remain pending for the named clients.

4. Claim: one can run compatibility coverage with
   `cargo test --test client_compat`.

   Benchmark: `Unverifiable from reference set`.

   The evidence in `docs/internal-compatibility-matrix.md` points to specific
   feature scenarios such as `tests/features/wireframe_login_compat.feature`
   and `tests/features/wireframe_xor_compat.feature`. The site's single-suite
   instruction does not match the evidence listed by the reference matrix.

5. Claim: the release-note example on the page accurately reflects the release
   governance model.

   Benchmark: `Partially supported`.

   The governance idea aligns with `docs/release-notes-qa-sign-off.md`, but the
   example is not grounded in the reference set and uses a future date,
   `2026-03-15`, relative to the benchmark date of `2026-03-11`.

## `mxd/changelog/index.html`

1. Claim: the listed releases (`0.4.0`, `0.3.2`, `0.3.0`, `0.2.1`) are the
   current documented release history for the project.

   Benchmark: `Unverifiable from reference set`.

   The provided references include a QA sign-off checklist, but they do not
   include release notes, tags, or a canonical changelog document that would
   substantiate this history.

2. Claim: `ADR-004` explains codec error handling rationale.

   Benchmark: `Contradicted`.

   The supplied ADR set contains only ADR-001, ADR-002, and ADR-003.

3. Claim: release notes are generated from Git tags and maintained in
   `CHANGELOG.md`, and the compatibility matrix lives in `docs/compatibility/`.

   Benchmark: `Contradicted`.

   Those paths are not part of the reference set used here, and they are not
   backed by the provided release-governance document, which points instead to
   `docs/internal-compatibility-matrix.md`.

4. Claim: specific release items such as TLA+ liveness proofs, Hotline Client
   1.2.3 compatibility quirks, and codec API changes are documented release
   facts.

   Benchmark: `Unverifiable from reference set`.

   Some individual capabilities are discussed in the design and verification
   docs, but the packaged release assertions and dates are not grounded by any
   of the provided release references.

## `mxd/quickstart/index.html`

1. Claim: cloning, building, creating a user, and starting the daemon follow
   the commands shown on the page.

   Benchmark: `Confirmed`.

   The commands match the direction of `docs/users-guide.md` and
   `docs/developers-guide.md`.

2. Claim: the Wireframe server uses the same configuration surface and admin
   subcommands as `mxd`.

   Benchmark: `Confirmed`.

   This is stated clearly in `docs/users-guide.md`.

3. Claim: after starting `mxd`, users can connect any Hotline
   1.8.5-compatible client.

   Benchmark: `Partially supported`.

   The compatibility matrix does not support such a broad operator-facing claim.
   Hotline 1.8.5 is currently `Partial` in `docs/internal-compatibility-
   matrix.md`, with user-list and messaging parity still pending.

## `mxd/installation/index.html`

1. Claim: build variants include default SQLite, PostgreSQL, and the
   `mxd-wireframe-server` target.

   Benchmark: `Confirmed`.

   These are consistent with `docs/users-guide.md` and
   `docs/developers-guide.md`.

2. Claim: a wireframe-only build is produced by disabling default features and
   enabling only `sqlite toml`.

   Benchmark: `Confirmed`.

   This matches `docs/users-guide.md`.

3. Claim: prerequisites are anchored in a repository-root `rust-toolchain.toml`
   and the optional `pg-embed-setup-unpriv` helper.

   Benchmark: `Partially supported`.

   The developer and user guides make the same claim, so the site is aligned
   with the reference set. The benchmark set, however, does not provide the
   toolchain file itself, only the documentation that mentions it.

## `mxd/configuration/index.html`

1. Claim: configuration precedence is compiled defaults, `.mxd.toml`,
   `MXD_` environment variables, then CLI flags.

   Benchmark: `Confirmed`.

   This matches `docs/design.md` and `docs/users-guide.md`.

2. Claim: the documented fields include bind address, database, and Argon2
   cost parameters.

   Benchmark: `Confirmed`.

   The configuration model and operational examples align with the design and
   user guide.

## `mxd/database-backends/index.html`

1. Claim: exactly one backend is selected at compile time, with SQLite as the
   default and PostgreSQL available through feature flags.

   Benchmark: `Confirmed`.

   This is a recurring design claim in `docs/design.md`,
   `docs/users-guide.md`, and `docs/developers-guide.md`.

2. Claim: `pg-embed-setup-unpriv` supports developer and test coverage for the
   PostgreSQL path.

   Benchmark: `Confirmed`.

   The helper is documented in both `docs/users-guide.md` and
   `docs/developers-guide.md`.

3. Claim: startup checks validate SQLite recursive CTE and JSON support.

   Benchmark: `Partially supported`.

   The broader design rationale around recursive CTEs and portable SQL is well
   supported in `docs/design.md`, but the site phrases the startup validation as
   a settled operational behaviour more strongly than the reference set does.

## `mxd/deployment/index.html`

1. Claim: recommended deployment modes include systemd, containers, and socket
   activation.

   Benchmark: `Confirmed`.

   `docs/design.md` explicitly discusses systemd integration, socket handling,
   and container-friendly deployment.

2. Claim: readiness signalling, watchdog heartbeats, and structured journald
   logging are part of the operator story.

   Benchmark: `Confirmed`.

   These are present in the design document's deployment and logging sections.

## `mxd/verification/index.html`

1. Claim: the project uses TLA+/TLC, Stateright, and Kani as complementary
   verification layers, and counterexamples become regression tests.

   Benchmark: `Confirmed`.

   This aligns closely with `docs/verification-strategy.md`.

2. Claim: the named artefact paths on the page represent the reference
   locations for the verification work.

   Benchmark: `Partially supported`.

   The concepts are right, but the page uses paths like `specs/handshake.tla`
   and `verify/session_gate.rs`, while `docs/verification-strategy.md` points
   to `crates/mxd-verification/tla/` and
   `crates/mxd-verification/src/session_model`.

## `mxd/roadmap/index.html`

1. Claim: the roadmap is organized around four phases:
   wireframe migration, presence and chat, file services, and administration.

   Benchmark: `Confirmed`.

   This sequencing matches the structure implied by `docs/design.md`,
   `docs/chat-schema.md`, `docs/news-schema.md`, and
   `docs/file-sharing-design.md`.

2. Claim: many chat, private-message, file-service, and admin features remain
   planned.

   Benchmark: `Confirmed`.

   This is the most honest page on the site with respect to implementation
   scope. It matches the design documents better than the home page and the
   compatibility page do.

3. Claim: the roadmap doubles as a decision log and links outward to the ADR
   and verification set.

   Benchmark: `Partially supported`.

   The design and ADR set do support that intent, but the site points to
   `docs/roadmap.md`, which is not part of the provided reference set.
