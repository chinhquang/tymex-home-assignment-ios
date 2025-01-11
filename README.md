# tymex-home-assignment-ios
# GithubUserPage iOS App

An innovative iOS app built with SwiftUI, following MVVM, Clean Architecture, and the Coordinator pattern. This app is designed to deliver an intuitive user experience while maintaining clean and modular code.

---

## **Table of Contents**
1. [Features](#features)
2. [UI Design](#ui-design)
3. [Setup & Installation](#setup--installation)
4. [How to Run](#how-to-run)
5. [Project Architecture](#project-architecture)

---

## **Features**
1. **User Listing**:
   - Display list of users github page
   - Each item of the list will contain an profile picture, a login username and a landing page url

2. **User Profiles**:
   - Display user profile (including Profile picture, Full name, Location, Number of followers, number of followings and their blog website )

3. **Dynamic Content**:
   - Browse a list of users
   - Tap on an item to view detailed information.

4. **Image Caching**:
   - Image Caching(Ram caching): reduce number of request to load image on client side.

5. **Smooth Navigation**:
   - Uses `NavigationStack` with the Coordinator pattern for a seamless navigation experience.

---

## **UI Design**
The app follows a minimalist and user-friendly design with the following key components:

1. **Github Users Screen**:
   - A list displaying users list

2. **Detail Screen**:
   - Displays detailed information for a selected user.

---

## **Setup & Installation**

1. Clone the repository:
   ```bash
   https://github.com/chinhquang/tymex-home-assignment-ios.git
   ```

2. Navigate to the project directory:
   ```bash
   cd tymex-home-assignment-ios/GithubUserPage
   ```

3. Open the project in Xcode:
   ```bash
   open GithubUserPage.xcodeproj using Xcode
   ```
---

## **How to Run**

1. Ensure your Mac is set up with the required Xcode version and iOS SDK.
2. Open the project in Xcode.
3. Select the appropriate simulator or a connected physical device.
4. Build and run the project using:
   - **Shortcut**: `Cmd + R`
   - Or click on the "Run" button in Xcode.

---

## **Project Architecture**
This app is built using the following principles and patterns:

1. **Clean Architecture**:
   - Separation of concerns with distinct layers for UI, business logic, and data handling.
   - Testable and maintainable codebase.

2. **MVVM Pattern**:
   - ViewModel handles the business logic, binding directly to the View.
   - Decouples UI and data layers.

3. **Coordinator Pattern**:
   - Manages navigation flow for modular and reusable code.

---

### **File Structure**
```plaintext
├── Models/              # Data models
├── Views/               # SwiftUI Views
├── ViewModels/          # ViewModels for handling business logic
├── Coordinators/        # Navigation and routing logic
├── Services/            # Network and data services
├── Resources/           # Assets, JSON files, and constants
└── Tests/               # Unit and UI tests
```

---

## **Contributing**
If you'd like to contribute to this project, feel free to open a pull request or submit an issue. Contributions are welcome!

---
