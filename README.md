# Hawthorne

## Native macOS Gemini client by Steven Frank

This is currently an _extremely barebones_ implementation of a native macOS [Gemini](https://gemini.circumlunar.space) client, written in Swift.

At the moment it is not really suitable for use, but may be useful as a jumping-off point for a community effort to flesh it out.

Among its _many_ problems:

- No controls in the toolbar, such as a reload button, loading status indicator, and navigation stack
- Currently only handles fully-qualified `gemini://` links, not relative URLs
- Doesn't handle status codes other than SUCCESS or REDIRECT
- Doesn't do all the things it's supposed to for TLS / certs
- gmi -> html formatting is implemented with seat-of-my-pants regexes rather than a real parser, and needs much nicer CSS
- Doesn't handle quote lines
- Doesn't handle downloads or anything besides displaying a single gmi page
- Ignores MIME types
- No icon
- No prefs
- And lots more!

Feel free to jump in if you want to jump in!
