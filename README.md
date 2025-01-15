
# Benji Mobile App Repository

Welcome to the **Benji Mobile App Repository**! This repository contains the source code for the Benji mobile application, developed using Flutter for both Android and iOS platforms. It integrates seamlessly with the Benji backend to deliver a robust personal financial management experience.

---

## Project Overview

The Benji Mobile App is a user-centric application designed to provide intuitive and insightful personal financial management. With its modern design and seamless integration, the app enables users to track expenses, set budgets, and gain valuable financial insights.

### Key Features:
- **Expense Tracking**: Categorize and monitor expenses in real-time.
- **Budget Management**: Set financial goals and track progress.
- **Insights and Analytics**: Leverage AI to forecast and analyze financial trends.
- **User-Friendly Interface**: Simple navigation with visually appealing charts and reports.
- **Secure Authentication**: Leverages backend services for user authentication and data protection.

---

## Project Structure

### Key Directories:

- **lib/**: Contains the main application code.
  - **core/**: Configuration and utility functions.
  - **data/**: Models, repositories, and API service integrations.
  - **controllers/**: State management and business logic.
  - **screens/**: UI screens for different features.
  - **widgets/**: Reusable UI components.
- **assets/**: Static assets like images and fonts.
- **test/**: Unit and widget tests.

---

## Requirements

### Prerequisites:
Ensure the following are installed:

- Flutter SDK (>=3.4.3)
- Dart (>=2.19.0)
- Android Studio / Xcode (for device emulation and builds)
- Node.js (for additional scripts if needed)

---

## Environment Configuration

### Setting Up Environment:
Update `lib/core/config/api_endpoints.dart` with the backend base URL and endpoints.

Example:
```dart
const String baseUrl = "https://api.benjiapp.com";
const String loginEndpoint = "/api/login";
const String registerEndpoint = "/api/register";
```

Ensure API keys and sensitive data are managed securely.

---

## Getting Started

### Installation Steps:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yesenvidnath/Benji.git
   cd Benji
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Application:**
   ```bash
   flutter run
   ```

4. **Build the Application:**
   - For Android:
     ```bash
     flutter build apk
     ```
   - For iOS:
     ```bash
     flutter build ios
     ```

---

## Contribution Guidelines

Contributions are welcome! Please adhere to the following steps:

1. Fork the repository and create a new branch for your feature or bugfix.
2. Write clean, well-documented code.
3. Test your changes thoroughly before submitting.
4. Open a detailed pull request with a summary of your changes.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Contact

For further inquiries or support:
- **Name**: K.K.Y. Vidnath
- **Email**: support@benji.com

Thank you for contributing to the Benji Mobile App!
