<div align="center">

# 🚚 KhojLive

### Fleet Tracking and Delivery Management System

<a href="https://github.com/keshavappdev/khojlive-fleet-tracking-system">
  <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&size=22&pause=1000&color=00D4FF&center=true&vCenter=true&width=700&lines=Track+your+fleet+in+real+time;Live+GPS+on+the+Dispatcher+Dashboard;Driver+app+that+works+offline;Auto+sync+when+the+network+is+back" alt="Track your fleet in real time | Live GPS | Offline driver app | Auto sync" />
</a>

<br/>

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js" />
<img src="https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript" />
<img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
<img src="https://img.shields.io/badge/Socket.IO-010101?style=for-the-badge&logo=socketdotio&logoColor=white" alt="Socket.IO" />
<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />

</div>

---

## 🚀 About The Project

**KhojLive** is a full-stack **fleet tracking and delivery management system**. Dispatchers monitor vehicles and deliveries live on a dashboard, while drivers use a Flutter mobile app that shares GPS location in real time and keeps working **offline**, syncing automatically when the connection returns.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📍 **Real-time GPS Tracking** | Live vehicle location streamed over Socket.IO |
| 🖥️ **Dispatcher / Admin App** | Manage drivers, deliveries and fleet from one place |
| 📱 **Driver Mobile App** | Simple Flutter app for deliveries and location sharing |
| 📶 **Offline Synchronization** | Data is stored locally and synced when back online |
| 📦 **Delivery Management** | Create, assign and track deliveries |
| 🗄️ **PostgreSQL Database** | Reliable relational storage with a ready SQL schema |
| 🐳 **Docker Support** | Run the backend stack quickly with docker-compose |
| ✅ **Automated Checks** | CI workflow and unit tests for backend and app domain logic |

---

## 📸 Screenshots

### 🖥️ Admin Panel

<div align="center">

| Screen 1 | Screen 2 | Screen 3 |
|:---:|:---:|:---:|
| <img src="screenshots/admin/1.png" width="280" /> | <img src="screenshots/admin/2.png" width="280" /> | <img src="screenshots/admin/3.png" width="280" /> |

</div>

### 📱 Phone App

<div align="center">

| Screen 1 | Screen 2 | Screen 3 |
|:---:|:---:|:---:|
| <img src="screenshots/phone/1.png" width="180" /> | <img src="screenshots/phone/2.png" width="180" /> | <img src="screenshots/phone/3.png" width="180" /> |

</div>

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| 📱 Mobile Apps | Flutter, Dart, Riverpod |
| ⚙️ Backend | Node.js, Express, TypeScript |
| 🗄️ Database | PostgreSQL |
| 🔌 Real-time | Socket.IO |
| 📍 Tracking | GPS location service with offline sync |
| 🐳 DevOps | Docker, docker-compose, GitHub Actions |

---

## 📂 Project Structure

```
khojlive-fleet-tracking-system/
├── apps/
│   ├── driver/          # Flutter driver app
│   └── dispatcher/      # Flutter dispatcher / admin app
├── backend/             # Node.js + Express + TypeScript API
│   ├── src/
│   ├── sql/schema.sql
│   └── tests/
├── docs/
│   ├── api/API.md
│   └── architecture/DECISIONS.md
├── scripts/             # Setup scripts
├── screenshots/
│   ├── admin/
│   └── phone/
├── .github/workflows/   # CI checks
├── docker-compose.yml
└── README.md
```

---

## ⚙️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/) 18 or newer
- [PostgreSQL](https://www.postgresql.org/) or Docker

### 1. Clone the repository

```bash
git clone https://github.com/keshavappdev/khojlive-fleet-tracking-system.git
cd khojlive-fleet-tracking-system
```

### 2. Run the backend

```bash
cd backend
cp .env.example .env      # then edit the values
npm install
npm run dev
```

Or start the stack with Docker:

```bash
docker-compose up -d
```

The database schema is in `backend/sql/schema.sql`.

### 3. Run the Driver app

```bash
cd apps/driver
flutter pub get
flutter run
```

### 4. Run the Dispatcher app

```bash
cd apps/dispatcher
flutter pub get
flutter run
```

### Run tests

```bash
# Backend
cd backend && npm test

# Driver app
cd apps/driver && flutter test
```

---

## 📖 Documentation

- 📡 [API Reference](docs/api/API.md)
- 🏗️ [Architecture Decisions](docs/architecture/DECISIONS.md)

---

## 🤝 Contributing

Contributions, issues and feature requests are welcome!
Feel free to open an issue or submit a pull request.

---

## 👨‍💻 Author

**Keshav** — [@keshavappdev](https://github.com/keshavappdev)

<div align="center">

⭐ **If you like this project, give it a star!** ⭐

</div>
