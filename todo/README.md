# 🌐 Platform-Aware HTTP Client for Dart/Flutter

This project showcases how to use different HTTP clients in Dart/Flutter based on the platform your app is running on (Android, iOS, macOS, or others). It ensures optimal network performance and behavior tailored to each platform by leveraging platform-specific HTTP implementations.

## ✨ Features

- Uses **Cronet** on Android for improved performance.
- Uses **Cupertino HTTP (NSURLSession)** on iOS and macOS.
- Falls back to **dart:io**’s `HttpClient` for other platforms.
- Built-in **timeout handling**.
- Customizable **user agent** and **memory cache size**.
- Clean interface via a reusable `CustomHttpClient` class.