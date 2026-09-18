# Development and releases

Keep ongoing development in this folder as a Git repository. Do not initialise the repository around a parent chat directory containing old ZIPs, rendered music or private request records.

## Each change

1. Make a focused change on a branch and run the relevant tests.
2. Review the diff and commit the working change with a descriptive message.
3. Commit logical steps as needed; not every commit needs a public version number.

## Each release

1. Update `VERSION` and `CHANGELOG.md`. Use patch versions for fixes/packaging and minor versions for new features while the project is experimental.
2. Run the builder, then both test scripts from README.
3. Check the device inside Live, including script resolution from a newly extracted folder.
4. Run `python scripts/release.py`. Inspect both ZIPs in `dist/` and their SHA-256 checksums.
5. Review/commit the source and generated device files. Tag that tested commit with `v` plus the version, for example `v0.5.1`.
6. Push the branch and tag to the intended GitHub remote. Create a release for that tag and attach the device ZIP, source ZIP, and checksums.

GitHub releases are created manually after validation. Authentication is configured locally and is never included in the package.

The bridge uses the MIT License. Avoid posting request records or logs containing private lyrics in issues. The supplied `.gitignore` protects newly added files, not files already committed in some other repository.


