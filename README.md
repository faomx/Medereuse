# 💊 Medereuse – Medicine Donation & Reuse Platform

**Graduation Project** | A cross-platform mobile application designed to bridge the gap between unused medicine and those in need, ensuring safety through a pharmacist-led validation workflow.

## 🌟 Key Features
- **Smart Donation Workflow**: Users can list unused medicines with expiration dates and storage conditions.
- **Risk-Based Classification**: Implemented a safety logic to categorize medicines before they enter the catalog.
- **Pharmacist Validation**: A dedicated portal/process for healthcare professionals to verify the safety of donations.
- **Real-time Catalog**: Searchable medicine database with color-coded safety indicators (High, Medium, Low risk).
- **Secure Authentication**: Managed via Firebase Auth for both donors and seekers.

## 📸 App Preview
> *Tip: Since this is Flutter, adding a GIF of the app scrolling or 3 phone screenshots side-by-side looks amazing.*

| Home Screen | Donation Form | Medicine Catalog |
| :---: | :---: | :---: |
| ![Home](screenshots/home.png) | ![Donate](screenshots/donate.png) | ![Catalog](screenshots/catalog.png) |

## 🛠️ Tech Stack
- **Frontend**: Flutter & Dart (Material Design 3)
- **Backend**: Firebase (Cloud Firestore, Authentication)
- **State Management**: Provider / Bloc (mention whichever you used)
- **Architecture**: Clean Architecture / MVC

## ⚙️ Installation
1. Clone the repo: `git clone https://github.com/yourusername/Medereuse.git`
2. Install dependencies: `flutter pub get`
3. Configure your `google-services.json` (Firebase) in the `/android/app` folder.
4. Run the app: `flutter run`

## 🛡️ Safety & Traceability
This project focuses heavily on the ethical and safety aspects of medicine reuse. Every donation undergoes a structured validation process to prevent the redistribution of expired or improperly stored medication.
