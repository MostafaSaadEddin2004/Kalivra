# Project Instructions for Codex

This is a Flutter project.

## Main rules
- Use clean, readable Dart code.
- Follow the existing project architecture.
- Do not rewrite large files unless necessary.
- Make small, safe changes.
- Explain important changes after editing.
- Prefer stable Flutter APIs.
- Avoid deprecated widgets/APIs.
- Do not change UI design unless requested.
- Do not remove existing features.
- Do not add packages unless necessary.
- Do just what I exactly ask and nothing else.
- Do not change any color or theme I used.
- Always use the AppTheme for colors and text style.
- Don't use isDark method and it's enough to use the AppTheme.
- Check if the text color match the theme and if it's not make sure to use ".copyWith".

## Commands to check work
Run these after meaningful changes:

```bash
flutter analyze
flutter test