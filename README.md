# Runoogers

<p align="center">
  <img width="460" height="300" src="https://i.imgur.com/oWnM7SE.png">
</p>
<div align='center'>
  
<a href='https://github.com/wenjebs/Runoogers/releases'>
  
<img src='https://img.shields.io/github/v/release/wenjebs/Runoogers?color=%23FDD835&label=version&style=for-the-badge'>
  
</a>
  
<a href='https://github.com/wenjebs/Runoogers/blob/main/LICENSE'>
  
<img src='https://img.shields.io/github/license/wenjebs/Runoogers?style=for-the-badge'>
  
</a>
  
</div>

<br />

Runoogers is a versatile project designed for runners seeking a gamified experienced. This comprehensive guide will provide you with everything you need to know to get started with the project, from installation instructions to a detailed description of its features.

## Table of Contents

- [Features](#features)

- [Installation](#installation)

- [Prerequisites](#prerequisites)

- [Clone the Repository](#clone-the-repository)

- [Configuration](#configuration)

- [Build and Run](#build-and-run)

- [Usage](#usage)

- [Contributing](#contributing)

- [License](#license)

## Features

List the key features and functionalities of your project:

- **User Account Authentication:** Securely authenticate users to access the app.
- **User Onboarding:** Guide new users through the initial setup and introduction to the app.

- **Run Logging:** Track and log user runs with detailed statistics.

- **Real Time Tracking:** Provide real-time tracking of runs using GPS.

- **Route Generation & Planning:** Generate and plan running routes for users.

- **AI Running Plans:** Offer personalized running plans powered by AI.

- **Challenges & Achievements:** Create challenges and track achievements to motivate users.

- **Leaderboard System:** Display user rankings and leaderboards.

- **Social Networking:** Enable users to connect and share their progress with friends.

- **Customisable 3D Avatars:** Allow users to create and customize their own 3D avatars.

- **Running Campaigns with Audio:** Provide audio-guided running campaigns.

- **Dark Mode:** Offer a dark mode for better usability in low-light conditions.

## Installation

Follow these steps to install and run ProjectName on your system.

### Prerequisites

Before you begin, ensure you have the following dependencies and tools installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install): Ensure you have the Flutter SDK installed.

- [Dart SDK](https://dart.dev/get-dart): The Dart SDK is included with the Flutter SDK, but make sure it is properly set up.

- [Android Studio or Xcode](https://flutter.dev/docs/get-started/install): Depending on your development environment, you need either Android Studio (for Android development) or Xcode (for iOS development).

- [Visual Studio Code](https://code.visualstudio.com/): A lightweight code editor with Flutter and Dart plugins installed.

- [Git](https://git-scm.com/): Version control system to manage your codebase.

- [Firebase CLI](https://firebase.google.com/docs/cli): If you are using Firebase for backend services, install the Firebase CLI.

- [Node.js and npm](https://nodejs.org/): Required for some build tools and package management.

- [Android/iOS Device or Emulator](https://flutter.dev/docs/get-started/install): Ensure you have a physical device or an emulator set up for testing your application.

### Clone the Repository

1. Open your terminal or command prompt.

2. Use the following command to clone the ProjectName repository:

git clone https://github.com/your-username/Runoogers.git

Replace `your-username` with your GitHub username.

### Configuration

1. Change your working directory to the cloned repository:

cd Runoogers

2. **Configuration Step 1: Setting Up Environment Variables**

   To configure the project, you need to set up environment variables. Follow these steps:

   - Create a `.env` file in the root directory of your project.
   - Add the necessary environment variables to the `.env` file. For example:

     ```plaintext
     API_KEY=your_api_key_here
     DATABASE_URL=your_database_url_here
     FIREBASE_API_KEY=your_firebase_api_key_here
     ```

   - Ensure that the `.env` file is included in your `.gitignore` file to prevent sensitive information from being committed to version control.

3. **Configuration Step 2: Creating Configuration Files**

   If there are additional configuration steps, outline them here:

   - **Firebase Configuration:**

     - Create a `firebase_config.json` file in the `assets` directory.
     - Add your Firebase configuration details to the `firebase_config.json` file. For example:

       ```json
       {
         "apiKey": "your_firebase_api_key_here",
         "authDomain": "your_project_id.firebaseapp.com",
         "projectId": "your_project_id",
         "storageBucket": "your_project_id.appspot.com",
         "messagingSenderId": "your_messaging_sender_id",
         "appId": "your_app_id"
       }
       ```

   - **Google Maps API Configuration:**

     - Create a `google_maps_config.json` file in the `assets` directory.
     - Add your Google Maps API key to the `google_maps_config.json` file. For example:

       ```json
       {
         "apiKey": "your_google_maps_api_key_here"
       }
       ```

   - **Loading Configuration Files:**
     - Ensure that your application loads these configuration files at runtime. You can use a package like `flutter_dotenv` to load environment variables and custom code to load JSON configuration files.

4. Install the required dependencies using:

flutter pub get

### Build and Run

1. Connect your device or start an emulator.

2. To build and run the project, use the following command:

flutter run

This will build the project and install it on your connected device or emulator.

## Usage

1. **Usage Step 1: User Registration and Login**

   - **User Registration:**

     - Open the app and navigate to the registration page.
     - Fill in the required details such as username, email, and password.
     - Click on the "Register" button to create a new account.
     - Verify your email if required.

   - **User Login:**
     - Open the app and navigate to the login page.
     - Enter your registered email and password.
     - Click on the "Login" button to access your account.

2. **Usage Step 2: Main Functionalities**

   - **Run Logging:**

     - Navigate to the "Run Logging" section from the main menu.
     - Start a new run by clicking the "Start Run" button.
     - The app will track your run in real-time using GPS.
     - After completing your run, click the "Stop Run" button to log the run details.

   - **Route Generation & Planning:**

     - Go to the "Route Planning" section.
     - Enter your starting point and destination.
     - The app will generate a running route for you.
     - You can save the route for future use or start running immediately.

   - **AI Running Plans:**

     - Access the "AI Running Plans" section.
     - Provide your running goals and current fitness level.
     - The app will generate a personalized running plan for you.
     - Follow the plan to achieve your running goals.

   - **Challenges & Achievements:**

     - Navigate to the "Challenges" section.
     - Join available challenges to compete with other users.
     - Track your progress and earn achievements as you complete challenges.

   - **Leaderboard System:**

     - Go to the "Leaderboard" section.
     - View the rankings of users based on their running performance.
     - Compare your performance with friends and other users.

   - **Social Networking:**

     - Access the "Social" section.
     - Connect with friends and share your running progress.
     - Post updates, photos, and achievements to your social feed.

   - **Customisable 3D Avatars:**

     - Navigate to the "Avatar" section.
     - Customize your 3D avatar with different outfits and accessories.
     - Save your avatar and use it in the app.

   - **Running Campaigns with Audio:**

     - Go to the "Campaigns" section.
     - Select an audio-guided running campaign.
     - Follow the audio instructions and complete the campaign.

   - **Dark Mode:**
     - Access the "Settings" section.
     - Toggle the "Dark Mode" option to switch between light and dark themes.

## Contributing

We welcome contributions to ProjectName. If you would like to contribute to the development or report issues, please follow these guidelines:

1. Fork the repository.

2. Create a new branch for your feature or bug fix.

3. Make your changes and commit them with descriptive messages.

4. Push your changes to your fork.

5. Submit a pull request to the main repository.

## License

Runoogers is licensed under the [License Type](LICENSE).

Thank you for choosing Runoogers! If you encounter any issues or have suggestions for improvements, please don't hesitate to [create an issue](https://github.com/your-username/Runoogers/issues) or [contribute to the project](#contributing). We look forward to your feedback and collaboration.
