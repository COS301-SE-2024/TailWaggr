# Argonauts
# Tailwaggr
[![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Platform-yellow?logo=firebase)](https://firebase.google.com)
<!-- [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=TailWaggr&metric=alert_status)](https://sonarcloud.io/dashboard?id=TailWaggr) -->
[![Flutter Test](https://github.com/COS301-SE-2024/TailWaggr/workflows/Flutter%20Test/badge.svg)](https://github.com/COS301-SE-2024/TailWaggr/actions)
[![Flutter Lint](https://github.com/COS301-SE-2024/TailWaggr/workflows/Flutter%20Lint/badge.svg)](https://github.com/COS301-SE-2024/TailWaggr/actions)
<!-- [![Requirements Status](https://requires.io/github/COS301-SE-2024/TailWaggr/requirements.svg?branch=master)](https://requires.io/github/COS301-SE-2024/TailWaggr/requirements/?branch=master) -->
[![GitHub issues](https://img.shields.io/github/issues/COS301-SE-2024/TailWaggr)](https://github.com/COS301-SE-2024/TailWaggr/issues)

Tailwaggr is a Flutter-based mobile application that aims to connect pet owners with veterinarians, pet keepers, and a supportive community of fellow pet enthusiasts. Our app provides a platform for creating profiles, finding professional pet care, engaging in discussions, and reuniting lost pets with their owners.

## Project Board
You can view our project board [here](https://github.com/orgs/COS301-SE-2024/projects/99/views/1).

## The Team

| Name             | Role            | Description                                                                                                | Photo                                       | LinkedIn                                                                                         |
|------------------|-----------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------|--------------------------------------------------------------------------------------------------|
| Timothy Whitaker| Project Manager, Integration Engineer | I am a student and employee who loves computers and programming. Many fields of computer science interest me especially game development and some of my other interests include gyming, socializing, reading and playing guitar.                                                                            | ![Timothy Whitaker](assets/team/Timothy_Whitaker.jpg) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/timothy-whitaker-34ab281bb/) |
| Scott Bebington  |        UI Engineer         | I am a final year computer science student specializing in front end development. My other hobbies include working out and socializing.                                                                             | ![Scott Bebington](assets/team/Scott_Bebington.jpg)   | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/scott-bebington/) |
| Ethan Groenendyk      |       Business Analyst          | I am a passionate game dev looking to gameify and make good fun out of my projects                                                                               | ![Ethan Groenendyk](assets/team/Ethan_Groenendyk.jpg)           | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/ethan-groenendyk-183620142/) |
| Given Chauke  |        Service Engineer         | Life long learner who enjoys challenges and building useful software products. Interested in gaming 🎮 and board games ♟                                                                             | ![Given Chauke](assets/team/Given_Chauke.jpg)     | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/given-chauke-10a6b927a/) |
| Nicholas Harvey    |        Dev Ops Engineer         | I have a lot of interest in the future of technology and how it might impact the world, especially the use of AI in a supportive capacity to assist people in their endeavours to enhance productivity more than using either AI or people could accomplish alone. This interest has led to me developing a passion for programming, especially the more mathematically and data-oriented side of things - and thus, I tend to work best in a backend capacity.                                                                           | ![Nicholas Harvey](assets/team/Nicholas_Harvey.png)       | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/nicholas-harvey-b11455144/) |

## Core Features

1. **Pet and Pet Owner Profiles**
   - Pet owners can create and manage profiles for themselves and their pets.
   - Connect pet profiles with their respective owners.

2. **Find a Veterinarian**
   - Veterinarians can register on the platform.
   - Pet owners can search for and contact veterinarians for their pets.

3. **Find a Pet Keeper**
   - Pet keepers can register on the platform.
   - Pet owners can search for and hire pet keepers to look after their pets.

4. **Forums**
   - Discussion boards for users to engage in conversations about pets.
   - Share resources, seek advice, and connect with other pet owners.

5. **Lost and Found Database**
   - Report lost pets and search for found pets in the area.
   - Facilitate reunions between lost pets and their owners.
  
## Firebase Integration

Tailwaggr uses Firebase for backend services. Here's a breakdown of how we utilize its different services:

- **Authentication**: Firebase Authentication provides a secure and reliable authentication system. We use it to manage user accounts and handle user sign-in and sign-up processes. It supports various authentication methods, including email and password, Google Sign-In, and Facebook Login.

- **Firestore Database**: We use Firebase's Cloud Firestore to store and sync data in real time. It allows us to store user profiles, pet information, and other relevant data. The data is synced across all clients in real time and remains available when the app goes offline.

- **Cloud Storage**: Firebase Cloud Storage is used to store images and other media. This includes profile pictures and any photos shared by users. It provides secure file uploads and downloads for our Firebase apps, regardless of network quality.

- **Cloud Functions**: We use Firebase Cloud Functions to run backend code in response to events triggered by Firebase features and HTTPS requests. This serverless framework allows us to execute our code in a secure, managed environment.

- **Firebase Hosting**: We use Firebase Hosting to serve our static and dynamic content. It provides fast and secure hosting for our web app, with a simple deployment process.

By integrating Firebase, we can focus on creating a great user experience, knowing that Firebase's secure and scalable infrastructure is powering our backend.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/COS301-SE-2024/TailWaggr.git 
   cd cos301_capstone

2. **Install Dependencies:**
   ```bash
   flutter pub get

3. **Run The App:**
   ```bash
   flutter run

## Demo Video
https://drive.google.com/file/d/1tC8j1FsY6oPOFMTz301LnhL8oH5_-M4U/view?usp=sharing

## Folder Structure
