# Flutter Real-Time Chat Application

This is a real-time chat application built with Flutter for the frontend and powered by a standard Node.js/Socket.io backend. The app provides a responsive UI that works seamlessly on both mobile (Android/iOS) and web platforms from a single codebase.

## Features

- **Real-Time Messaging:** Send and receive messages instantly.
- **User Presence:** See when users join or leave the chatroom.
- **Typing Indicator:** Know when another user is typing a message.
- **Responsive UI:** The layout adapts for both mobile (single-column) and web/desktop (multi-column with a user list).
- **Cross-Platform:** Single codebase runs on both mobile and web.

## Technology Stack

- **Frontend:**
    - **Flutter:** For building the cross-platform UI.
    - **Provider:** For simple and effective state management.
    - **socket_io_client:** Dart package to communicate with the Socket.io backend.
- **Backend:**
    - **Node.js & Express:** The runtime and web framework.
    - **Socket.io:** For enabling real-time, bidirectional event-based communication.
    - (Uses the official Socket.io chat example backend)

---

## Setup and Running Instructions

### Prerequisites

- [Node.js](https://nodejs.org/) installed on your machine.
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and configured.

### 1. Backend Setup

The application is designed to connect to the official Socket.io chat example backend.

1.  **Clone the official Socket.io repository:**
    ```
    git clone https://github.com/socketio/socket.io.git
    ```
2.  **Navigate to the chat example directory:**
    ```
    cd socket.io/examples/chat
    ```
3.  **Install dependencies:**
    ```
    npm install
    ```
4.  **Start the server:**
    ```
    node index.js
    ```
    The backend server will now be running on `http://localhost:3000`.

### 2. Frontend Setup (This Flutter App)

1.  **Clone this repository:**
    ```
    git clone https://github.com/lokeshramchand-ctrl/techindika.git
    cd fronten
    cd real_t_c
    ```
2.  **Get Flutter packages:**
    ```
    flutter pub get
    ```
3.  **Run the application:**

    **To Run on a Mobile Emulator or Physical Device:**
    *Ensure an emulator is running or a device is connected.*
    ```
    flutter run
    ```
    > **Note:** The code is configured to connect to `http://192.168.1.3:3000` for Android emulators automatically.

    **To Run on the Web:**
    ```
    flutter run -d chrome
    ```
    > **Note:** The code connects to `ws://localhost:3000` when running on the web.

---

## Socket.io Event Details

The application uses the following Socket.io events to communicate with the backend:

| Event Name | Direction | Description |
| :--- | :--- | :--- |
| `add user` | Client → Server | Sent when a new user joins the chat with their username. |
| `new message`| Client ↔ Server | Sent when a user sends a message. The server broadcasts it to all other clients. |
| `typing` | Client → Server | Sent when a user starts typing in the message input field. |
| `stop typing`| Client → Server | Sent when a user clears the input field or sends a message. |
| `login` | Server → Client | Sent to the client upon successful connection, providing a list of all current users. |
| `user joined`| Server → Client | Broadcast to all clients when a new user has joined the chat. |
| `user left` | Server → Client | Broadcast to all clients when a user has disconnected. |
```


