# MODcpoy

Tweak to bypass copy/paste restrictions on websites for iOS 18.x (roothide only).

## Requirements

- iOS 18.x jailbroken device with Relaxin
- Roothide environment
- arm64e architecture (iPhone XS Max supported)
- macOS with Theos installed

## Build

1. Clone or copy this project
2. Install dependencies: `make package`
3. Install on device: `make install`
4. Respring

## How it works

Hooks into `UIResponder`, `WKWebView`, `UIWebView`, and Safari classes (`SFLegacyBrowserViewController`, `SFContentViewController`) to force `canPerformAction:` to return `YES` for copy/paste/select actions.

## Supported

- Safari browser
- WKWebView-based apps (Twitter, Reddit, etc.)
- UIWebView-based apps (older apps)

## Files

- `Makefile` - Build configuration
- `Tweak.xm` - Main hook code
- `control` - Package metadata for Cydia/Sileo
- `layout/` - Layout directory for packaging

## License

MIT