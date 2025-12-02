# 🧭 User Explorer App  
A modern Flutter application to browse, search, and favorite users using the JSONPlaceholder API.  
Built with **Flutter**, **BLoC state management**, smooth animations, light/dark themes, and SharedPreferences.

---

## 🚀 Features

### 🔹 User Features  
- Fetches users from API  
- Smooth list animations  
- Shimmer loading effects  
- User detail screen  

### 🔹 Search  
- Real-time search by name/email  
- Clear button  
- Auto reset on empty search  

### 🔹 Favorites  
- Add/remove favorites  
- Stores favorites locally using SharedPreferences  
- Persists across app restarts  

### 🔹 Authentication UI  
- Login with validation  
- “Remember Me” support  
- Auto-fill saved email/password  

### 🔹 Themes  
- Full Light & Dark Mode  
- Theme preference saved locally  

---

## 🏗️ Tech Stack

| Area | Technology |
|------|------------|
| Framework | Flutter |
| State Management | BLoC |
| Local Storage | SharedPreferences |
| Networking | http |
| Fonts | Manrope (Google Fonts) |
| Animations | Hero, TweenAnimationBuilder |

---

## 📁 Folder Structure
lib/
│
├── blocs/
│ └── home/
│ ├── home_bloc.dart
│ ├── home_event.dart
│ └── home_state.dart
│
├── models/
│ └── user_model.dart
│
├── services/
│ ├── api_service.dart
│ └── shared_pref_service.dart
│
├── screens/
│ ├── login_screen.dart
│ ├── home_screen.dart
│ └── user_detail_screen.dart
│
├── widgets/
│ ├── search_bar.dart
│ └── user_card.dart
│
└── utils/
├── app_colors.dart
├── app_themes.dart
└── app_constants.dart


## 🌐 API Used

JSONPlaceholder Users API  
https://jsonplaceholder.typicode.com/users


---

## ⚙️ Installation & Setup

### **1️⃣ Clone the repo**
### **2️⃣ Install dependencies**
### **3️⃣ Run the app**
```bash
1️⃣ git clone https://github.com/kavana-kr/user_explorer_app.git
2️⃣ flutter pub get
3️⃣ flutter run


