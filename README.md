<p align="center">
  <img width="300" src="https://www.tari.com/assets/img/tari-aurora-logo.svg">
</p>

[![Build Status](https://travis-ci.com/tari-project/wallet-ios.svg?branch=development)](https://travis-ci.com/tari-project/wallet-ios)

## What is Aurora?
Aurora is a reference-design mobile wallet app for the forthcoming [Tari](https://www.tari.com/) digital currency. The goal is for creators and developers to be able to use the open-source Aurora libraries and codebase as a starting point for developing their own Tari wallets and applications. Aurora also sets the bar for applications that use the Tari protocol. In its production-ready state, it will be a beautiful, easy to use Tari wallet focused on Tari as a default-private digital currency.

Want to contribute to Aurora? Get started here in this repository.

<a href="https://apps.apple.com/us/app/tari-aurora/id1503654828" target="_blank"><img width="100" src="https://aurora.tari.com/img/AppStoreButton_large.svg"></a>

## Build Instructions

### Swift Style Guide

Code follows [Github's](https://github.com/github/swift-style-guide) style guide and the [SwiftLint](https://github.com/realm/SwiftLint) is run on each build using. Code is linted on each build.

### Getting started

```bash
git clone git@github.com:tari-project/wallet-ios.git
cd wallet-ios
sh update_dependencies.sh
```

This will also create a default `env.json` file for sensitive vars. Adjust these settings as needed.

### Dependencies

Third party frameworks and Library are managed using a pre-compiled [Tari](https://github.com/tari-project/tari)
binary from https://www.tari.com/downloads/ as well as packages from Cocoapods, plus jq for scripts.

Cocoapods can either be installed directly
```bash
sudo gem install cocoapods
```
or via brew
```bash
brew install cocoapods jq fastlane
```

### Pods used (Cocoapods)

```ruby
- pod 'SwiftLint'
- pod 'Tor', '~> 407.11'
- pod 'FloatingPanel', '1.7.5'
- pod 'lottie-ios'
- pod 'SwiftEntryKit', '1.2.3'
- pod 'ReachabilitySwift'
- pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.27.1'
- pod 'SwiftKeychainWrapper', '3.4.0'
- pod 'Giphy', '2.1.22'
- pod 'IPtProxy', '1.8.0'
- pod 'OpenSSL-Universal'
- pod 'Zip', '2.1.2'
- pod 'SwiftyDropbox', '8.2.1'
- pod 'YatLib', '0.3.2'
- pod 'TariCommon', '0.2.0'
```

### Version Management

* Build Number willl increased for each iTunes submission and are increased automatically with fastlane
* App version will only increase on app submiting to App Store

### Folder Structure and Architecture

Coming soon.

### Git

- `development` will be the semi-stable branch with `tag` on each stable merge. This is the branch from where IPA should be published to iTunes Test Flight.
- `master` will have code that are fully stable with `release` on each merge. App store publishing should be done from this branch only.

### UI testing

Right now we don't have UI tests using asserts but running `generate_screenshots.sh` will automatically generate a report containing screenshots of each view on multiple simulators. This report can be used to visually inspect each PR for any possible UI or layout bugs that might have been introduced.

### Local Build

```bash
pod install
xcodebuild build -workspace MobileWallet.xcworkspace -scheme MobileWallet \
  -destination 'platform=iOS Simulator,OS=16.1,name=iPhone 14' \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO \
  ONLY_ACTIVE_ARCH=No
```
