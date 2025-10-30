# ShéaRose E-Commerce App

Step into style with our animated e-commerce app, designed exclusively for women to explore fashion, discover new trends, and enjoy a seamless shopping experience.

## Features

*   **Beautifully Animated UI:** A visually appealing and engaging user interface.
*   **Supabase Backend:** Powered by Supabase for authentication, database, and future scalability.
*   **Product Catalog:** Browse and search for products, view details, and see what's new and featured.
*   **User Authentication:** Sign up, log in, and manage your account securely.
*   **Wishlist & Cart:** Save your favorite items and manage your shopping cart.
*   **Order Management:** Track your orders and view your order history.
*   **Theming:** Supports both light and dark themes, adapting to your system settings.

## Getting Started

### Prerequisites

*   Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
*   A Supabase account: [Create a Supabase project](https://supabase.com/)

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/shearose.git
    cd shearose
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Set up Supabase:**
    *   Create a `.env` file in the root of the project.
    *   Add your Supabase URL and anonymous key to the `.env` file:
        ```
        SUPABASE_URL=YOUR_SUPABASE_URL
        SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
        ```
    *   Update the `lib/supabase/supabase_config.dart` file to load these values.

4.  **Run the app:**
    ```sh
    flutter run
    ```

## Project Structure

```
.
├── android
├── assets
│   ├── icons
│   └── images
├── ios
├── lib
│   ├── auth
│   ├── main.dart
│   ├── models
│   ├── screens
│   ├── services
│   ├── supabase
│   ├── theme.dart
│   └── widgets
├── pubspec.lock
├── pubspec.yaml
└── web
```

*   `lib/`: The main source code of the application.
    *   `auth/`: Handles user authentication.
    *   `main.dart`: The entry point of the application.
    *   `models/`: Contains the data models for the app (e.g., `Product`, `User`).
    *   `screens/`: The different screens of the application (e.g., `HomeScreen`, `LoginScreen`).
    *   `services/`: Contains the business logic and services that interact with the backend.
    *   `supabase/`: Configuration and helper classes for Supabase.
    *   `theme.dart`: Defines the light and dark themes for the app.
    *   `widgets/`: Reusable UI components.
*   `assets/`: Contains the static assets for the app, such as images and icons.
*   `pubspec.yaml`: The project's configuration file, including dependencies.

## Backend Configuration

This project uses [Supabase](https://supabase.com/) for its backend. You will need to set up the following in your Supabase project:

### Tables

*   **`products`:** Stores the product information.
*   **`users`:** Stores user profiles.
*   **`categories`:** Stores product categories.
*   **`orders`:** Stores user orders.
*   **`wishlist`:** Stores user wishlists.
*   **`cart`:** Stores user shopping carts.

The SQL schemas for these tables can be found in the `lib/supabase/` directory.

### Authentication

The app uses Supabase's built-in authentication for email and password sign-up and sign-in.

### Row-Level Security (RLS)

It is highly recommended to enable Row-Level Security on your Supabase tables to ensure that users can only access their own data. The SQL policies for RLS can be found in the `lib/supabase/` directory.

## Deployment

This project is configured for easy deployment to [Netlify](https://www.netlify.com/).

### Connecting to Netlify

1.  **Create a new site from Git:**
    *   Log in to your Netlify account.
    *   Click "Add new site" -> "Import an existing project".
    *   Connect your Git provider (e.g., GitHub, GitLab, Bitbucket).
    *   Select the repository for this project.

2.  **Configure build settings:**
    *   Netlify will automatically detect the `netlify.toml` file in the root of the repository and use the build settings from it.
    *   You can leave the "Build command" and "Publish directory" fields blank, as they will be overridden by the `netlify.toml` file.

3.  **Deploy your site:**
    *   Click "Deploy site".
    *   Netlify will build and deploy your Flutter web app.

### `netlify.toml` Configuration

The `netlify.toml` file in the root of the project contains the following configuration:

```toml
[build]
  command = "flutter build web"
  publish = "build/web"

[dev]
  command = "flutter run -d chrome"
  port = 8686
  publish = "build/web"
  targetPort = 8686
```

*   **`[build]`:**
    *   `command`: The command to build the Flutter web app.
    *   `publish`: The directory that contains the built app.
*   **`[dev]`:**
    *   `command`: The command to run the app in development mode.
    *   `port`: The port to run the development server on.
    *   `publish`: The directory to serve in development mode.
    *   `targetPort`: The port that the `flutter run` command will be listening on.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue to discuss any changes.
