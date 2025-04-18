# AscendExaminer Installation Guide (macOS)

This guide provides step-by-step instructions to set up the AscendExaminer project on a macOS operating system.

⚠️ IMPORTANT! This guide is also self-generated by AI, so take it with a pinch of salt!

## Prerequisites

1.  **Node.js:** Install the latest LTS version of Node.js. The recommended way is using Homebrew:
    ```bash
    brew install node
    ```
    If you don't have Homebrew, install it from [https://brew.sh/](https://brew.sh/). npm (Node Package Manager) is included with Node.js.
2.  **Git:** Git usually comes pre-installed on macOS. You can check by running `git --version`. If not installed, install it using Homebrew:
    ```bash
    brew install git
    ```
3.  **PostgreSQL:** Install PostgreSQL using Homebrew:
    ```bash
    brew install postgresql
    ```
    After installation, you might need to start the PostgreSQL service:
    ```bash
    brew services start postgresql
    ```
    You'll also need to create a user and a database. By default, Homebrew creates a superuser matching your macOS username. You can create the database using:
    ```bash
    createdb myapp
    ```
    Replace `myapp` if you use a different database name.

## Setup Steps

1.  **Clone the Repository:**
    Open Terminal and run:
    ```bash
    git clone <repository_url> AscendExaminer
    cd AscendExaminer
    ```
    Replace `<repository_url>` with the actual URL of your Git repository. If you downloaded the code as a ZIP file, extract it and navigate to the project folder in Terminal.

2.  **Install Dependencies:**
    Install the necessary Node.js packages:
    ```bash
    npm install
    ```

3.  **Configure Environment Variables:**
    The application expects environment variables for the database connection. You might need to set these in your shell profile (e.g., `~/.zshrc` or `~/.bash_profile`) or use a `.env` file if the application supports it. The key variables are:
    *   `DB_TYPE=postgresql`
    *   `DATABASE_URL`: The connection string (e.g., `postgresql://your_macos_user@localhost:5432/myapp`). Replace `your_macos_user` with your macOS username if you used the default PostgreSQL setup, or the specific user/password you configured.

4.  **Database Migration:**
    Apply the database schema migrations. Ensure your PostgreSQL service is running and the database exists. Update the `DATABASE_URL` in the `package.json`'s `db:push` script if necessary.
    ```bash
    npm run db:push
    ```
    *Note: This command uses the `DATABASE_URL` defined within the `scripts.db:push` section of `package.json`. You might need to `export DATABASE_URL=your_actual_url` before running this if the script doesn't explicitly set it.*

5.  **Start the Development Server:**
    You can start the server in development mode using:
    ```bash
    npm run dev
    ```
    The server should now be running. Access the application as specified in the project's documentation or console output (likely involving a specific port on `localhost`).

## Creating a Start Script (Optional)

You can create a simple shell script to start the server easily:

1.  Create a file named `start-dev-server.sh`:
    ```bash
    #!/bin/bash
    echo "Starting development server..."
    cd "$(dirname "$0")" # Ensure script runs from project root
    npm run dev
    ```
2.  Make it executable:
    ```bash
    chmod +x start-dev-server.sh
    ```
3.  Run it:
    ```bash
    ./start-dev-server.sh
