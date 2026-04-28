# Chat Application

A full-stack real-time chat application built with **Node.js/Express** (backend) and **Flutter** (frontend). The app supports user registration, login, real-time messaging via WebSockets, and conversation management.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Backend Details](#-backend-details)
  - [API Endpoints](#api-endpoints)
  - [Database Models](#database-models)
  - [Real-time Communication](#real-time-communication)
- [Frontend Details](#-frontend-details)
  - [Architecture](#architecture)
  - [Key Features](#key-features)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [Environment Variables](#-environment-variables)
- [Future Enhancements](#-future-enhancements)

---

## 📖 Project Overview

This is a real-time chat application that enables users to:

- Register and authenticate securely
- Create and manage conversations with other users
- Send and receive messages in real-time
- View conversation history

The application uses **Socket.io** for bidirectional real-time communication between clients and the server.

---

## 🛠 Tech Stack

### Backend

| Technology | Purpose                           |
| ---------- | --------------------------------- |
| Node.js    | Runtime environment               |
| Express.js | Web framework                     |
| MongoDB    | Database                          |
| Mongoose   | ODM for MongoDB                   |
| Socket.io  | Real-time WebSocket communication |
| JWT        | Authentication tokens             |
| bcrypt     | Password hashing                  |
| TypeScript | Type-safe JavaScript              |

### Frontend

| Technology             | Purpose                        |
| ---------------------- | ------------------------------ |
| Flutter                | Cross-platform UI framework    |
| flutter_bloc           | State management               |
| socket_io_client       | Socket.io client for Flutter   |
| flutter_secure_storage | Secure token storage           |
| http                   | HTTP client for REST API       |
| equatable              | Value equality for BLoC states |

---

## 📂 Project Structure

```
chat-app/
├── README.md
├── backend/                    # Node.js + Express backend
│   ├── package.json
│   ├── tsconfig.json
│   └── src/
│       ├── index.ts            # Main server entry point
│       ├── controller/
│       │   ├── authController.ts
│       │   ├── conversationController.ts
│       │   └── messageController.ts
│       ├── middleware/
│       │   └── authMiddleware.ts
│       ├── models/
│       │   ├── db.ts           # MongoDB connection
│       │   ├── userModel.ts
│       │   ├── conversationModel.ts
│       │   └── messageModel.ts
│       ├── routes/
│       │   ├── authRoute.ts
│       │   ├── conversationRoute.ts
│       │   └── messageRoute.ts
│       ├── services/
│       ├── types/
│       │   └── express/
│       └── utils/
│
└── my_chat_app/                # Flutter frontend
    ├── pubspec.yaml
    ├── lib/
    │   ├── main.dart           # App entry point
    │   ├── core/
    │   │   ├── theme.dart      # App theming
    │   │   ├── socket_service.dart
    │   │   └── feature/
    │   │       ├── auth/       # Authentication feature
    │   │       │   ├── data/
    │   │       │   ├── domain/
    │   │       │   └── presentation/
    │   │       ├── chat/       # Messaging feature
    │   │       │   ├── data/
    │   │       │   ├── domain/
    │   │       │   └── presentation/
    │   │       └── conversation/  # Conversation feature
    │   │           ├── data/
    │   │           ├── domain/
    │   │           └── presentation/
    │   └── dummy.dart
    ├── android/
    ├── ios/
    ├── linux/
    ├── macos/
    ├── web/
    ├── windows/
    └── test/
```

---

## 🔙 Backend Details

### Server Configuration

- **Port**: 5000
- **CORS**: Enabled for all origins (`*`)
- **Database**: MongoDB (connection string configurable)
- **Protocol**: HTTP + WebSocket

### Main Entry Point (`src/index.ts`)

The backend server initializes:

1. Express app with CORS and JSON parsing
2. MongoDB connection via Mongoose
3. REST API routes for authentication, conversations, and messages
4. Socket.io server for real-time messaging

```typescript
// Key socket events
- "joinConversation" → Join a conversation room
- "sendMessage" → Send a message and broadcast to room
- "newMessage" → Receive new messages (client-side)
```

### API Endpoints

#### Authentication (`/auth`)

| Method | Endpoint         | Description           |
| ------ | ---------------- | --------------------- |
| POST   | `/auth/register` | Register a new user   |
| POST   | `/auth/login`    | Login and receive JWT |

#### Conversations (`/conversation`)

| Method | Endpoint        | Description                    |
| ------ | --------------- | ------------------------------ |
| POST   | `/conversation` | Create a new conversation      |
| GET    | `/conversation` | Get all conversations for user |

#### Messages (`/message`)

| Method | Endpoint                   | Description                     |
| ------ | -------------------------- | ------------------------------- |
| GET    | `/message/:conversationId` | Get messages for a conversation |
| POST   | `/message/:conversationId` | Send a message (requires auth)  |

### Database Models

#### User Model (`userModel.ts`)

```typescript
{
  username: String,      // Required
  email: String,        // Required, Unique
  password: String,     // Required, Hashed
  createdAt: Date,
  updatedAt: Date
}
```

**Collection name**: `chat`

#### Conversation Model (`conversationModel.ts`)

```typescript
{
  participants: [ObjectId],  // References User
  lastMessage: ObjectId,    // Reference to Message
  createdAt: Date,
  updatedAt: Date
}
```

**Collection name**: `conversations`

#### Message Model (`messageModel.ts`)

```typescript
{
  conversationId: ObjectId,  // Reference to Conversation
  senderId: ObjectId,       // Reference to User
  content: String,         // Message text
  readBy: [ObjectId],      // Array of user IDs who read
  createdAt: Date,
  updatedAt: Date
}
```

**Collection name**: `messages`

### Real-time Communication

Socket.io handles real-time message delivery:

1. **Client joins a conversation**:

   ```typescript
   socket.emit("joinConversation", conversationId);
   ```

2. **Client sends a message**:

   ```typescript
   socket.emit("sendMessage", {
     conversationId,
     senderId,
     content,
   });
   ```

3. **Server broadcasts to room**:
   ```typescript
   io.to(conversationId).emit("newMessage", newMessage);
   ```

---

## 🔜 Frontend Details

### Architecture

The Flutter app follows **Clean Architecture** with three layers:

```
lib/
├── core/
│   ├── theme.dart           # App-wide theming
│   └── socket_service.dart  # WebSocket management
└── feature/
    ├── auth/                # Authentication feature
    │   ├── data/            # Data layer (API, models)
    │   ├── domain/          # Business logic (entities, use cases)
    │   └── presentation/   # UI layer (BLoC, pages)
    ├── chat/                # Messaging feature
    └── conversation/       # Conversation management
```

### State Management

- **BLoC Pattern** using `flutter_bloc`
- Separate BLoCs for:
  - `AuthBloc` → Authentication state
  - `ConversationBloc` → Conversation list
  - `ChatBloc` → Messages and sending

### Key Features

| Feature           | Implementation                                  |
| ----------------- | ----------------------------------------------- |
| User Registration | `RegisterPage` + `RegisterUseCases`             |
| User Login        | `LoginPage` + `LoginUseCases`                   |
| Conversation List | `ConversationPage` + `FetchConversationUseCase` |
| Real-time Chat    | `ChatPage` + `SocketService` + `ChatBloc`       |
| Secure Storage    | `flutter_secure_storage` for JWT tokens         |
| Dark Theme        | Custom `AppTheme.darkTheme`                     |

### Pages

1. **LoginPage** (`/login`)
   - Email and password fields
   - Navigation to register

2. **RegisterPage** (`/register`)
   - Username, email, password fields
   - Creates new user account

3. **ConversationPage** (`/conversationPage`)
   - List of all conversations
   - Tap to open chat

4. **ChatPage** (`/chat`)
   - Real-time message display
   - Text input for sending messages

### Services

#### SocketService (`core/socket_service.dart`)

- Singleton pattern for WebSocket connection
- Connects to `http://localhost:5000`
- Handles connection/disconnection events
- Provides socket instance for emitting/listening events

---

## 🚀 Getting Started

### Prerequisites

| Requirement | Version               |
| ----------- | --------------------- |
| Node.js     | 18+                   |
| npm         | 9+                    |
| Flutter     | 3.10+                 |
| MongoDB     | 6.0+ (local or Atlas) |

### Backend Setup

1. **Navigate to backend directory**:

   ```bash
   cd backend
   ```

2. **Install dependencies**:

   ```bash
   npm install
   ```

3. **Configure MongoDB**:
   - Update connection string in `src/models/db.ts`
   - Default: `mongodb://localhost:27017/chat-app`

4. **Start the server**:

   ```bash
   # Development mode (with nodemon)
   npm run dev

   # Production mode
   npm run build
   npm start
   ```

5. **Server running at**:
   ```
   http://localhost:5000
   ```

### Frontend Setup

1. **Navigate to Flutter project**:

   ```bash
   cd my_chat_app
   ```

2. **Get dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the app**:

   ```bash
   flutter run
   ```

4. **Build for specific platform**:

   ```bash
   # Android
   flutter build apk

   # iOS
   flutter build ios

   # Web
   flutter build web
   ```

---

## 🔧 Environment Variables

### Backend

No explicit environment variables required (hardcoded defaults):

- JWT Secret: `secretKey`
- MongoDB: `mongodb://localhost:27017/chat-app`
- Server Port: `5000`

### Frontend

The base URL is configured in `AuthRemoteDataSource`:

```dart
// For web builds
final String baseURL = 'http://localhost:5000';

// For mobile builds (replace [IP_ADDRESS] with actual server IP)
final String baseURL = 'http://[IP_ADDRESS]';
```

> **Note**: For mobile devices to connect, replace `localhost` with the actual IP address of the backend server (e.g., `http://192.168.1.100:5000`).

---

## 🔮 Future Enhancements

- [ ] Group chat support
- [ ] Message read receipts
- [ ] Online/offline status indicators
- [ ] Push notifications for mobile
- [ ] Image and file sharing
- [ ] Message encryption (E2E)
- [ ] User profile pictures
- [ ] Search functionality
- [ ] Typing indicators
- [ ] Message reactions

---

## 📄 License

ISC License

---

## 👤 Author

Ayush Sharma

---

## 🆘 Support

For issues or questions, please open an issue on the project repository.
