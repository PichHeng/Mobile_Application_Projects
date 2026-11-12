# demo1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



sample structure :

plant_tech/
├── lib/
│   ├── main.dart                  # ចំណុចចាប់ផ្តើម (ខ្លីបំផុត)
│   ├── app.dart                   # MaterialApp, theme, router
│   │
│   ├── core/                      # របស់ដែលប្រើរួមគ្រប់ feature
│   │   ├── constants/             # ទំហំ, string keys
│   │   ├── theme/                 # AppTheme, typography
│   │   ├── router/                # route ទាំងអស់
│   │   ├── network/               # HTTP client, error handling
│   │   ├── utils/                 # validators, helpers
│   │   └── widgets/               # widget ប្រើឡើងវិញ (GlassTextField...)
│   │
│   ├── features/
│   │   ├── auth/                  # ← feature ទី ១ (ពី design របស់អ្នក)
│   │   │   ├── data/
│   │   │   │   ├── models/        # UserModel (fromJson/toJson)
│   │   │   │   ├── datasources/   # ទំនាក់ទំនង Firebase/API
│   │   │   │   └── repositories/  # AuthRepository
│   │   │   └── presentation/
│   │   │       ├── viewmodels/    # LoginViewModel, SignUpViewModel
│   │   │       ├── views/         # LoginView, SignUpView
│   │   │       └── widgets/       # widget ពិសេសរបស់ auth
│   │   │
│   │   ├── plant/                 # (ថ្ងៃក្រោយ) បញ្ជីរុក្ខជាតិ
│   │   ├── care_schedule/         # (ថ្ងៃក្រោយ) កាលវិភាគស្រោចទឹក ដាក់ជី
│   │   ├── notification/          # (ថ្ងៃក្រោយ) ការរំលឹក
│   │   └── profile/
│   │
│   └── l10n/                      # ភាសាខ្មែរ + អង់គ្លេស
│
├── assets/ (images, fonts, icons)
└── test/                          # រចនាសម្ព័ន្ធដូច lib/




## 📱 Application UI Preview

### 1. Sign Up Screen

![PlantX Sign Up Screen](docs/screenshots/signup-page.png)

### 2. Dashboard Screen

![PlantX Dashboard](docs/screenshots/dashboard.png)


