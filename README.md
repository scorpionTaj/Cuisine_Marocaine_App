# Cuisine Marocaine App

[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)] [![Flutter](https://img.shields.io/badge/Flutter-3.0-blue)]

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [API Keys & Configuration](#api-keys--configuration)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Customization](#customization)
- [Testing](#testing)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

Cuisine Marocaine is a cross-platform Flutter application that brings the rich flavors of Moroccan cuisine to your mobile device. Explore authentic dishes, reserve tables, connect via social media, and get culinary advice from an AI-powered assistant.

## Features

- **Home & Promotions**: Browse featured dishes, daily specials, and chef recommendations.
- **Menu**: Category-based menu (starters, tagines, desserts, beverages) with detailed descriptions and high-quality images.
- **Table Reservations**: Select date, time, party size, and special requests; view upcoming and past bookings.
- **Contact & Social**: View restaurant contact details, open social profiles (Facebook, Instagram), and send feedback.
- **User Authentication**: Sign up, log in, and secure protected profile and settings sections.
- **Settings**:
  - Light/dark theme toggle.
  - Custom primary color picker.
  - Manage notification preferences.
- **AI Chat Assistant**: Ask questions about recipes, ingredients, and cooking tips via integrated chat powered by a language model.
- **Splash & Onboarding**: Smooth startup screen with initialization logic and first-time walkthrough.
- **Offline Support & Caching**: Cache menu data with automatic expiration cleanup.
- **Responsive Design**: Adaptive layouts for phones, tablets, and web.
- **Animations & Transitions**: Custom fade, slide, and shimmer effects for enhanced UX.

## Architecture

This project follows a modular architecture:

- **Presentation**: `lib/screens/`, `lib/widgets/`
- **Business Logic**: `lib/services/`, `lib/models/`
- **Data Layer**: Local cache (`cache_service`), remote APIs (`appwrite_service`, `http`).
- **Utilities**: `lib/utils/` (responsive layout, animations).
- **Theme & Styles**: `app_theme.dart`

State management is implemented using Provider or ValueNotifier (depending on the screen). Services are injected at runtime.


## Tech Stack

- Flutter & Dart
- Provider / Riverpod (state management)
- shared_preferences (persistent storage)
- google_fonts
- appwrite / REST API backend
- sqlite / sqflite (optional local DB)
- Mockito / flutter_test (unit & widget testing)

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 2.17.0
- Android Studio or VS Code with Flutter plugins
- Xcode (for iOS builds on macOS)
- Running Appwrite server (if using Appwrite backend)

### Installation

```bash
git clone https://github.com/yourusername/cuisine-marocaine-app.git
cd cuisine-marocaine-app
flutter pub get
```

### API Keys & Configuration

1. Rename `.env.example` to `.env` and fill in:
   ```
   APPWRITE_ENDPOINT=...
   APPWRITE_PROJECT_ID=...
   GEMINI_API_KEY=...
   ```
2. Add `.env` to `.gitignore` to avoid committing secrets.

3. For local testing, ensure `assets/apikey.txt` exists with any required tokens.

## Project Structure

```
lib/
├── app_theme.dart
├── main.dart
├── data/                    # Mock or sample JSON data
├── models/                  # Domain models
├── screens/                 # UI screens and pages
├── services/                # API, auth, chat, cache, data services
├── utils/                   # Helpers (responsive, animations)
└── widgets/                 # Reusable UI components
```

## Usage

- Launch the app on emulator or device: `flutter run`.
- Navigate via bottom tab bar.
- Tap chat icon for AI assistant.
- Use Settings to customize theme and preferences.

## Customization

- Update primary color and fonts in `app_theme.dart`.
- Replace placeholder images in `assets/images/`.
- Configure endpoints and API keys in `.env` or `assets/apikey.txt`.
- Modify screen layouts in `lib/screens/`.

## Testing

Run all tests:

```bash
flutter test
```

Generate code coverage report (requires `lcov`):

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Roadmap

- [ ] Add online ordering functionality.
- [ ] Integrate payment gateway.
- [ ] Multi-language localization.
- [ ] Push notifications for promotions.
- [ ] Web version enhancements.

## Contributing

Your contributions are welcome!  
1. Fork the repo.  
2. Create a feature branch.  
3. Commit your changes.  
4. Open a Pull Request.

Please follow the [Contributor Covenant](CODE_OF_CONDUCT.md).

## License

MIT License © 2025 [Tajeddine Bourhim & Imad El Khelyfy]. See [LICENSE](LICENSE) for details.

## Contact

- Author: [Tajeddine Bourhim](mailto:bourhimtajeddine@gmail.com) - [Imad El Khelyfy](mailto:imadelkhelyfy@gmail.com)  
- GitHub: 
- [@scorpiontaj](https://github.com/scorpiontaj)
- [@IMADKHKHALIF](https://github.com/IMADKHKHALIFI)
