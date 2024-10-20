# Argonauts
# Tailwaggr
[![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Platform-yellow?logo=firebase)](https://firebase.google.com)
<!-- [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=TailWaggr&metric=alert_status)](https://sonarcloud.io/dashboard?id=TailWaggr) -->
[![Flutter Test](https://github.com/COS301-SE-2024/TailWaggr/workflows/Flutter%20Test/badge.svg)](https://github.com/COS301-SE-2024/TailWaggr/actions/workflows/testing.yaml)
[![Flutter Lint](https://github.com/COS301-SE-2024/TailWaggr/workflows/Flutter%20Lint/badge.svg)](https://github.com/COS301-SE-2024/TailWaggr/actions/workflows/linting.yaml)
<!-- [![Requirements Status](https://requires.io/github/COS301-SE-2024/TailWaggr/requirements.svg?branch=master)](https://requires.io/github/COS301-SE-2024/TailWaggr/requirements/?branch=master) -->

[![GitHub issues](https://img.shields.io/github/issues/COS301-SE-2024/TailWaggr)](https://github.com/COS301-SE-2024/TailWaggr/issues)
[![Code Coverage](https://codecov.io/gh/COS301-SE-2024/TailWaggr/branch/main/graph/badge.svg)](https://codecov.io/gh/COS301-SE-2024/TailWaggr)
[![Lighthouse Performance](https://img.shields.io/badge/Performance-95-brightgreen)]
[![Lighthouse Accessibility](https://img.shields.io/badge/Accessibility-82-brightgreen)]
[![Lighthouse Best Practices](https://img.shields.io/badge/Best_Practices-100-brightgreen)]
[![Lighthouse SEO](https://img.shields.io/badge/SEO-100-brightgreen)]

Tailwaggr is a Flutter-based mobile application that aims to connect pet owners with veterinarians, pet keepers, and a supportive community of fellow pet enthusiasts. Our app provides a platform for creating profiles, finding professional pet care, engaging in discussions, and reuniting lost pets with their owners.

## Tailwaggr App
The app can be viewed [Here](https://tailwaggr.web.app)

## Project Board
You can view our project board [Here](https://github.com/orgs/COS301-SE-2024/projects/99/views/1).

## Tech Stack
You can view our tech stack [Here](docs/TechStack.pdf)

## Architecture
You can view our architecture [Here](docs/architecture.pdf)

## User Manual
You can view our user manual [Here](docs/UserGuide.pdf)

## Technical Installation Manual
You can view our technical installation manual [Here](docs/Technical_Installation.pdf)

## Coding Standards
You can view our coding standards [Here](docs/CodingStandards.pdf)

## Software Requirements Specification
You can view our SRS [Here](docs/srs.pdf)

## The Team

| Name             | Role            | Description                                                                                                | Photo                                       | LinkedIn                                                                                         |
|------------------|-----------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------|--------------------------------------------------------------------------------------------------|
| Timothy Whitaker | Project Manager, Integration Engineer | A dedicated student and professional with a passion for computers and programming. Timothy is particularly interested in game development and enjoys a variety of activities including gym workouts, socializing, reading, and playing the guitar. | ![Timothy Whitaker](assets/team/Timothy_Whitaker.jpg) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/timothy-whitaker-34ab281bb/) |
| Scott Bebington  | UI Engineer     | A final-year computer science student specializing in front-end development. Scott's hobbies include working out and socializing, reflecting his dynamic and engaging personality. | ![Scott Bebington](assets/team/Scott_Bebington.jpg) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/scott-bebington/) |
| Ethan Groenendyk | Business Analyst | A passionate game developer who loves to gamify projects and create enjoyable experiences. Ethan's enthusiasm for game development drives his innovative approach to business analysis. | ![Ethan Groenendyk](assets/team/Ethan_Groenendyk.jpg) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/ethan-groenendyk-183620142/) |
| Given Chauke     | Service Engineer | A lifelong learner who thrives on challenges and enjoys building useful software products. Given is also an avid gamer and board game enthusiast, always eager to explore new strategies and technologies. | ![Given Chauke](assets/team/Given_Chauke.jpg) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/given-chauke-10a6b927a/) |
| Nicholas Harvey  | DevOps Engineer | Deeply interested in the future of technology and its potential impact on the world, especially the role of AI in enhancing productivity. Nicholas excels in backend development, driven by his passion for programming and data-oriented tasks. | ![Nicholas Harvey](assets/team/Nicholas_Harvey.png) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/nicholas-harvey-b11455144/) |
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

## Bonus Features

1. **Image Recognition**
   - Utilize advanced image recognition technology to identify pets and other objects in photos.
   - Enhance user experience by providing automated tagging and categorization of images.

2. **Image Filtering**
   - Filter out inappropriate or bad images to ensure a safe and positive user experience.
   - Automatically detect and remove images that do not meet community guidelines before sharing.
   - Replace inappropriate images with placeholders or warnings.

3. **Mini Game: PetRunner**
   - An engaging mini game where users can play as a dog.
   - Avoid obstacles and get to the top of the leaderboard.
  
## Firebase Integration

Tailwaggr uses Firebase for backend services. Here's a breakdown of how we utilize its different services:

- **Authentication**: Firebase Authentication provides a secure and reliable authentication system. We use it to manage user accounts and handle user sign-in and sign-up processes. It supports various authentication methods, including email and password, Google Sign-In, and Facebook Login.

- **Firestore Database**: We use Firebase's Cloud Firestore to store and sync data in real time. It allows us to store user profiles, pet information, and other relevant data. The data is synced across all clients in real time and remains available when the app goes offline.

- **Cloud Storage**: Firebase Cloud Storage is used to store images and other media. This includes profile pictures and any photos shared by users. It provides secure file uploads and downloads for our Firebase apps, regardless of network quality.

- **Cloud Functions**: We use Firebase Cloud Functions to run backend code in response to events triggered by Firebase features and HTTPS requests. This serverless framework allows us to execute our code in a secure, managed environment.

- **Firebase Hosting**: We use Firebase Hosting to serve our static and dynamic content. It provides fast and secure hosting for our web app, with a simple deployment process.

By integrating Firebase, we can focus on creating a great user experience, knowing that Firebase's secure and scalable infrastructure is powering our backend.

## Demo Video
https://drive.google.com/file/d/1tC8j1FsY6oPOFMTz301LnhL8oH5_-M4U/view?usp=sharing
