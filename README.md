# PhotoApp 📸

A simple iOS photo gallery app built with Swift and UIKit, demonstrating MVC architecture and image caching.

## ✨ Features

- Photo list from JSONPlaceholder API
- Custom table view cells with images
- Memory-based image caching
- Proper cell reuse handling
- Clean MVC architecture

## 🛠️ Tech Stack

- **Language**: Swift 5.0+
- **UI Framework**: UIKit (programmatic, no Storyboard)
- **Architecture**: MVC pattern
- **Caching**: NSCache for images
- **Networking**: URLSession
- **Dependencies**: None

## 🚀 Getting Started

**Clone the repository**
   ```bash
   git clone https://github.com/MaksimLiV/PhotoApp.git
   cd PhotoApp
   ```
   
## 📋 Requirements

- iOS 13.0+
- Xcode 12.0+

## 🔧 Key Implementation

### Image Loading Pipeline
1. Check cache → 2. Download → 3. Cache → 4. Display

### Cell Reuse Safety
- Tracks current image URL per cell
- Cancels outdated requests
- Prevents wrong images during scroll

## 👨‍💻 Author

**Maksim Li**

---
