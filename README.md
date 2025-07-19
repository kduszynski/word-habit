# Word Habit

## Project Description

Word Habit is a responsive, mobile-first web application designed to support systematic learning of English and Polish vocabulary. Built on the "atomic habits" philosophy, it encourages users to build a daily learning habit by introducing one new word per day. Users can manage a personal dictionary by manually adding words or using AI-generated translations, with features including viewing, and deleting words, as well as receiving daily notifications.

## Tech Stack

- **Frontend:** Next.js 15, React 19, TypeScript 5, Tailwind CSS, Shadcn/ui
- **Backend:** Supabase (for PostgreSQL and authentication)
- **AI Integration:** Openrouter.ai (access to various AI models for generating translations)
- **CI/CD & Hosting:** GitHub Actions and DigitalOcean

## Getting Started Locally

### Prerequisites

- Node.js version **22.14.0** (refer to `.nvmrc`)
- Git

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your_username/word-habit.git
   cd word-habit
   ```
2. **Install dependencies:**
   ```bash
   npm install
   ```
3. **Run the development server:**
   ```bash
   npm run dev
   ```
4. Open your browser and navigate to [http://localhost:3000](http://localhost:3000) to view the app.

## Available Scripts

- **`npm run dev`**: Starts the development server.
- **`npm run build`**: Builds the application for production.
- **`npm run start`**: Runs the application in production mode.
- **`npm run lint`**: Lints the codebase for potential errors and enforces style guidelines.

## Project Scope

The current MVP of Word Habit includes:

- **User Authentication:**
  - Register and log in using email and password.
- **Dictionary Management (CRUD):**
  - **Create:** Add new words manually or via AI assistance.
  - **Read:** Browse a list of saved words and view their details.
  - **Delete:** Permanently remove words from your dictionary.
- **Notifications:**
  - Set a preferred time for daily notifications.
  - Receive a daily notification featuring one word from your dictionary.
- **Additional Features:**
  - Mark words as "known" to exclude them from future notifications.

## Project Status

This project is currently in the MVP stage and is actively under development. Future updates may include additional features and enhancements based on user feedback.

## License

This project is licensed under the MIT License.
