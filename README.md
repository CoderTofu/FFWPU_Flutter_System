# ffwpu_flutter_view

A new Flutter project.

## If [ApiService](/lib/api/ApiService.dart) is not fetching data/logging in:

Update the baseURL to match your device's IPv4 address

```
ipconfig
```

Copy the IPv4 Address and replace the baseURL:

```
Wireless LAN adapter Wi-Fi:

   Connection-specific DNS Suffix  . :
   IPv6 Address. . . . . . . . . . . : <value>
   Temporary IPv6 Address. . . . . . : <value>
   Link-local IPv6 Address . . . . . : <value>
   IPv4 Address. . . . . . . . . . . : 192.168.1.11
   Subnet Mask . . . . . . . . . . . : <value>
   Default Gateway . . . . . . . . . : <value>
                                       192.168.1.1
```

In [ApiService](/lib/api/ApiService.dart):

```
class ApiService {
  static const String baseUrl =
      'http://192.168.1.11:8000/api'; // Replace 192.168.1.11 with your IPv4 Address
```

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/to/state-management-sample).

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/to/resolution-aware-images).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter apps](https://flutter.dev/to/internationalization).

# FFWPU_Flutter_System

# If
