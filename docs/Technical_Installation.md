# TailWaggr Installation Manual

## Introduction

TailWaggr is a comprehensive pet management application designed to enhance the interaction between pet owners and their furry friends. Built using Flutter, it offers a seamless cross-platform experience, ensuring functionality across various devices. The backend is powered by Firebase, providing real-time data synchronization, authentication, and cloud storage capabilities. This manual guides you through setting up TailWaggr on your system, including the installation of necessary software and running the application.

## Prerequisites

Before installing TailWaggr, ensure the following software is installed on your system:

- **Git**: For cloning the repository. (Version: 2.30.0 or later)
- **Flutter SDK**: The core framework for running and building Flutter applications. (Version: 2.10.0 or later)
- **Dart SDK**: Required for Flutter development. (Version: 2.16.0 or later)
- **Android Studio and Visual Studio or Visual Studio Code**: Recommended IDEs for Flutter development.
  - **Android Studio**: (Version: 2021.1.1 or later)
  - **Visual Studio**: (Version: 17.10.0 or later) (needed for android development)
  - **Visual Studio Code**: (Version: 1.60.0 or later)
- **Firebase CLI**: For deploying the application. (Version: 10.0.1 or later)

### Installing Prerequisites

1. **Git**: Download and install Git from [https://git-scm.com/](https://git-scm.com/).
2. **Flutter SDK**: Follow the installation guide on [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
3. **Dart SDK**: Usually comes with the Flutter SDK, but if needed, follow [https://dart.dev/get-dart](https://dart.dev/get-dart).
4. **IDE (Android Studio/VS Code)**: 
    - Android Studio: [https://developer.android.com/studio](https://developer.android.com/studio)
    - Visual Studio: [https://visualstudio.microsoft.com/](https://visualstudio.microsoft.com/)
    - Visual Studio Code: [https://code.visualstudio.com/](https://code.visualstudio.com/)
5. **Firebase CLI**: Install the Firebase CLI using the following command:
    ```bash
    npm install -g firebase-tools
    ```

## Installation

1. **Clone the TailWaggr Repository**:
    Open a terminal or command prompt and run the following command:
    ```bash
    git clone https://github.com/COS301-SE-2024/TailWaggr.git
    ```
2. **Navigate to the Project Directory**:
    ```bash
    cd TailWaggr/cos301_capstone
    ```
3. **Install Dependencies**:
    Run the following command to install the required dependencies:
    ```bash
    flutter pub get
    ```
    The above command will install all the dependencies specified in the `pubspec.yaml` file.
4. **Run the Application**:
    To run Tailwaggr, use the following command:
    ```bash
    flutter run
    ```
5. **Deploy the Application**:
    Log into your firbase account (Argonauts is ours)
    ```bash
    firebase login
    ```
    Deploy the application using the following command:
    ```bash
    firebase deploy
    ```
    The application is automatically deployed using github actions.
6. **Access the Application**:
    Once the application is running, you can access it on your emulator or connected device.
    If deploying the application, you can access it using [tailwaggr.web.app](https://tailwaggr.web.app/).
5. **User Manual**:
    Refer to the [User Manual](https://docs.google.com/document/d/1TiRA697HTTGuLCOzq20es4q_fotXlDpTnVuov_7zNP0/edit) for detailed instructions on using TailWaggr.