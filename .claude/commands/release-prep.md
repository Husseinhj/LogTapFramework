---
description: Pre-release checklist for tagging a new LogTapIOS version
---

Walk through the release prep without making any commits or pushes. Report status of each item; do not auto-fix.

Argument: $ARGUMENTS — the proposed version (e.g., `0.14.0`). If empty, ask the user.

Checks:

1. **Working tree clean** — `git status` shows no uncommitted changes (or only intended ones).
2. **CHANGELOG.md** — has an entry for the proposed version with bullet points covering changes since the previous tag. Run `git log <previous-tag>..HEAD --oneline` to summarize.
3. **README.md install snippet** — version strings in the SPM `.package(url:, from:)` and any Xcode package-add screenshots match the proposed version.
4. **API parity** — invoke `/parity-check` (or run the same checks inline). Report any drift between `LogTapFramework` and `LogTapFrameworkNoop`.
5. **Public API stability** — diff public symbols against the previous tag (`git show <previous-tag>:Sources/LogTapFramework/LogTap.swift` vs current). Flag any breaking change so the user can pick the right semver bump.
6. **Web UI parity with Android sibling** — if `Sources/LogTapFramework/Utils/Resources+{HTML,CSS,JS}.swift` was regenerated, confirm it was sourced from the matching Android `LogTap/src/main/java/com/github/husseinhj/logtap/utils/Resources.kt` release tag. Stale UI = drift.
7. **XcodeGen regeneration** — if `project.yml` was edited, `LogTapFramework.xcodeproj` must be regenerated via `xcodegen generate`. Remind the user; don't run it automatically.
8. **SPM resolves cleanly** — remind the user to run `cd LogTapFramework-Noop && swift build` and `xcodebuild -workspace LogTapIOS.xcworkspace -scheme LogTapFramework -destination 'generic/platform=iOS Simulator' build` locally.
9. **Sample app builds** — remind user to build `LogTapSample` against both products before tagging.
10. **No debug artifacts checked in** — `xcuserdata/`, `.build/`, `.swiftpm/`, derived data should not appear in `git diff`.

Output a checklist with ✓/✗/? for each item and a final summary: `READY TO TAG vX.Y.Z` or `BLOCKERS: ...`.
