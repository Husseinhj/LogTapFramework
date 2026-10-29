#!/usr/bin/env python3
"""Release helper for LogTapFramework.

  release.py next <patch|minor|major|X.Y.Z>   print the next version
  release.py prepare <X.Y.Z> [YYYY-MM-DD]     move "### Unreleased" in CHANGELOG.md
                                              to a version section, bump README
  release.py notes <X.Y.Z>                    print that version's CHANGELOG section
"""
import datetime
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
CHANGELOG = ROOT / "CHANGELOG.md"
README = ROOT / "README.md"
SEMVER = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")
HEADING = re.compile(r"^### +(\S+).*$", re.M)


def fail(msg):
    sys.exit(f"error: {msg}")


def latest_tag():
    tags = subprocess.run(["git", "tag", "--list"], cwd=ROOT, capture_output=True,
                          text=True, check=True).stdout.split()
    versions = [tuple(map(int, m.groups())) for t in tags if (m := SEMVER.match(t.lstrip("v")))]
    return max(versions, default=(0, 0, 0))


def next_version(bump):
    if SEMVER.match(bump):
        return bump
    major, minor, patch = latest_tag()
    if bump == "major":
        return f"{major + 1}.0.0"
    if bump == "minor":
        return f"{major}.{minor + 1}.0"
    if bump == "patch":
        return f"{major}.{minor}.{patch + 1}"
    fail(f"unknown bump '{bump}'")


def section(text, name):
    """Return (start, end) of the body under '### <name>', up to the next heading or '---'."""
    for m in HEADING.finditer(text):
        if m.group(1) == name:
            nxt = HEADING.search(text, m.end())
            end = nxt.start() if nxt else len(text)
            return m.start(), m.end(), end
    return None


def prepare(version, date):
    if not SEMVER.match(version):
        fail(f"'{version}' is not X.Y.Z")
    text = CHANGELOG.read_text()
    if section(text, version):
        fail(f"CHANGELOG.md already has a {version} section")
    found = section(text, "Unreleased")
    if not found:
        fail("CHANGELOG.md has no '### Unreleased' section")
    start, head_end, end = found
    body = text[head_end:end].strip()
    if not body:
        fail("'### Unreleased' section is empty, nothing to release")
    text = (text[:start] + "### Unreleased\n\n" + f"### {version} - {date}\n\n" + body + "\n\n"
            + text[end:])
    CHANGELOG.write_text(text)

    readme = README.read_text()
    readme, n = re.subn(r'(LogTapFramework\.git", from: ")[^"]+(")', rf"\g<1>{version}\2", readme)
    if n == 0:
        fail("README.md has no SPM 'from:' version to bump")
    README.write_text(readme)


def notes(version):
    text = CHANGELOG.read_text()
    found = section(text, version)
    if not found:
        fail(f"CHANGELOG.md has no {version} section")
    _, head_end, end = found
    print(text[head_end:end].strip().rstrip("-").strip())


def main(argv):
    if len(argv) < 2:
        fail(__doc__)
    cmd, args = argv[1], argv[2:]
    if cmd == "next" and len(args) == 1:
        print(next_version(args[0]))
    elif cmd == "prepare" and len(args) in (1, 2):
        prepare(args[0], args[1] if len(args) == 2 else datetime.date.today().isoformat())
    elif cmd == "notes" and len(args) == 1:
        notes(args[0])
    else:
        fail(__doc__)


if __name__ == "__main__":
    main(sys.argv)
