# 🎯Vazhi – Your Path

You’ve seen (or heard of) “A Day in the Life of” videos and stories, right? How about we take a peek at a day in the life of **YOU**?

**Vazhi** takes you to your future to give you the smallest of nudges that you absolutely need to manifest your dreams.

---

## Features

- Live Gemini-powered FastAPI backend hosted on GCP
- Cross-platform Flutter frontend
- Intelligent and dynamic story generation
- Intelligent daily task generation 

---

## How to get started locally

### Flutter Frontend

#### Prerequisites

- Flutter SDK installed
- Dart installed
- A valid backend API URL (already deployed on GCP)

### Setup

**Step 1:** Navigate to project directory and get dependencies

```bash
cd vazhi
flutter pub get
```

**Step 2:** Create a .env file and add the server url.

The server for the app is hosted on Google Cloud Platform. The Flutter app requires the URL to communicate with the server. So create a .env file in project directory and add the following line:

```bash
GEMINI_URL=https://gemini-api-backend-140623945393.asia-south1.run.app/gemini
```

By default, the app connects to this live backend URL. You can change it if you host your own.

That's it!! Now if you want to configure the server by yourself, the code is in 'python_backend' directory. 

**Remember to create a .env file and add your own API key.** 

Pull requests are welcome! If you’d like to improve the app or add new features, please fork the repository and create a new branch for your changes.

For questions, suggestions, or collaborations, feel free to reach out via GitHub issues or connect directly.








