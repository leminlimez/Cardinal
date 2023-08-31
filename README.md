# Cardinal
Change the images on the cards in your Apple Wallet on iOS 15.0-16.5 (and 16.6b1).
Tested on an iPhone 13 Pro (iOS 15.3.1, TrollStore & MDC) and an iPhone 12 Pro (iOS 16.6b1, KFD).

## Exploit (per version):
- iOS 15.0-15.4.1:  TrollStore or MacDirtyCow
- iOS 15.5-16.1.2:  MacDirtyCow
- iOS 16.2-16.5:    KFD

## How To Install
You can use any method you want, such as AltStore, Sideloadly, TrollStore (for iOS 15.4.1 and below only), etc. The ipa file will be in the releases tab.

## Warning for iOS 16.2+
The kfd exploit likes to corrupt the id after using it multiple times. If this happens, you will have to re-add it. It seemed pretty likely from when I was testing. You might have to delete the app's data after using it once.
You may also kernel panic after using the app. Your device will be fine, it will only reboot once and then continue working as normal.
Some offsets may also not be correct for some version and device combos.
You can ignore this if you are on versions prior to iOS 16.2, as this will not be an issue.

## Credits
- Offsets and KFD from Misaka and [Cluckabunga](https://github.com/leminlimez/Cluckabunga)
- Card changer code adapted from [Cowabunga](https://github.com/leminlimez/Cowabunga)
- Initial app for testing was [ID Changer](https://github.com/leminlimez/ID-Changer)
