# 📲 Media Utilities in Dart/Flutter

This project demonstrates two key features often needed in media-heavy Flutter applications:

1. ✅ **Resumable Video Downloads**
2. 🖼️ **Simple Image Caching**

---

## ✨ Features

### 📥 Resumable Video Download

- Resume downloads after interruption using HTTP `Range` headers.
- Avoid downloading from scratch if a partial file exists.
- Handles large video files efficiently.
- Minimal setup using only Dart and the `http` package.

### 🖼️ Simple Image Caching

- Download images once and cache them locally.
- Serve cached images instantly on next app load.
- Reduces network usage and improves performance.