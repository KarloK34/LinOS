# LinOS 🚊🚌

LinOS je moderna Flutter aplikacija za upravljanje javnim prijevozom u gradu Osijeku. Aplikacija pruža korisnicima kompletno rješenje za navigaciju, kupnju karata i praćenje voznih redova tramvaja i autobusa.

## 📖 Sadržaj
- [📱 Funkcionalnosti](#-funkcionalnosti)
- [🏗️ Arhitektura aplikacije](#️-arhitektura-aplikacije)
- [🛠️ Tehnologije i paketi](#️-tehnologije-i-paketi)
- [🚀 Pokretanje aplikacije](#-pokretanje-aplikacije)
- [🌐 Lokalizacija](#-lokalizacija)
- [🔒 Sigurnost](#-sigurnost)
- [📊 Firebase struktura](#-firebase-struktura)
- [📈 Buduća proširenja](#-buduća-proširenja)
- [🎓 Akademska napomena](#-akademska-napomena)

## 📱 Funkcionalnosti

### 🔐 Autentifikacija i upravljanje korisnicima
- **Registracija i prijava** - Sigurno stvaranje računa i prijava putem Firebase Auth
- **Zaboravljena lozinka** - Funkcionalnost resetiranja lozinke putem e-pošte
- **Upravljanje profilom** - Osnovne postavke korisničkog profila
- **Validacija podataka** - Napredna validacija email adresa i lozinki
- **Error handling** - Lokalizirane poruke grešaka za sve Firebase Auth scenarije

### 🏠 Početna stranica i navigacija
- **Interaktivna mapa** - Google Maps integracija s prikazom trenutne lokacije
- **Pretraživanje odredišta** - Inteligentna pretraga mjesta s autocompletom (Google Places API)
- **Popularna odredišta** - Brz pristup često posjećenim lokacijama
- **Planiranje rute** - Prikaz optimalne rute javnim prijevozom (Google Directions API)
- **Navigacija** - Integracija s Google Maps aplikacijom za navigaciju
- **Dinamička mapa** - Mogućnost proširivanja i smanjivanja prikaza mape
- **Praćenje lokacije** - Automatsko dohvaćanje i praćenje korisničke lokacije

### 🎫 Sustav digitalnih karata
- **Kupnja karata** - Četiri tipa karata:
  - Jednokratna vožnja (2.00€, 1 sat)
  - Dnevna karta (10.00€, 24 sata)
  - Tjedna karta (50.00€, 7 dana)
  - Mjesečna karta (100.00€, 30 dana)
- **QR kodovi** - Sigurni QR kodovi za validaciju s kriptografskim hashom
- **Upravljanje stanjem** - Dodavanje sredstava na korisnički račun
- **Aktivne karte** - Prikaz trenutno važećih karata s odbrojavanjem u stvarnom vremenu
- **Povijest kupnje** - Detaljni pregled svih kupljenih karata s filterima i sortiranjem
- **Validacija karata** - Sigurnosni sustav validacije sa SHA-256 hash-om
- **Automatsko upravljanje** - Karte se automatski označavaju kao neaktivne nakon isteka
- **Upravljanje stanjem računa** - Kompletno upravljanje stanjem korisničkog računa s transakcijskim logovima

### 🚊 Linije i vozni redovi
- **Mapa linija** - Vizualni prikaz tramvajskih i autobusnih linija na Google Maps karti
- **Simulacija vozila** - Prikaz vozila u realnom vremenu na karti s animiranim markerima
- **Vozni redovi** - Detaljni rasporedi polazaka po stanicama
- **Omiljene stanice** - Označavanje često korištenih stanica za brži pristup
- **Filtriranje po tipovima** - Mogućnost prikaza samo tramvajskih ili samo autobusnih linija

### ⚙️ Postavke i personalizacija
- **Višejezična podrška** - Hrvatski i engleski jezik s potpunom lokalizacijom
- **Obavijesti** - Push notifikacije za polaske s omiljenih stanica
- **Tema aplikacije** - Svjetla i tamna tema s Material Design 3
- **Upravljanje dozvolama** - Lokacija, obavijesti
- **Automatsko osvježavanje** - Periodično osvježavanje obavijesti
- **Upravljanje postavkama** - Mogućnost uključivanja/isključivanja različitih značajki

## 🏗️ Arhitektura aplikacije

### 📁 Struktura projekta
```
lib/
├── core/                    # Osnovna funkcionalnost
│   ├── app_theme/          # Teme i stilovi
│   ├── data/               # Zajedničke data klase
│   ├── di/                 # Dependency injection (GetIt + Injectable)
│   ├── locale/             # Upravljanje jezicima
│   ├── navigation/         # Routing (GoRouter)
│   ├── services/           # Osnovni servisi
│   ├── utils/              # Utilities
│   └── widgets/            # Zajedničke UI komponente
├── features/               # Feature-based organizacija
│   ├── auth/              # Autentifikacija
│   ├── home/              # Početna stranica
│   ├── lines/             # Linije javnog prijevoza
│   ├── schedule/          # Vozni redovi
│   ├── settings/          # Postavke aplikacije
│   └── tickets/           # Sustav karata
├── l10n/                  # Lokalizacija (ARB datoteke)
└── main.dart             # Početna točka aplikacije
```

### 🎯 Arhitektonski obrasci
- **Clean Architecture** - Razdvojeni domain, data i presentation slojevi
- **BLoC Pattern** - State management s flutter_bloc
- **Repository Pattern** - Abstrakcija podatkovnog sloja s Firebase integracijama
- **Dependency Injection** - GetIt + Injectable za loose coupling i testabilnost
- **Feature-first organizacija** - Modularnost po funkcionalnostima
- **SOLID principi** - Poštivanje osnovnih principa objektno-orijentiranog programiranja

### 🔄 State Management
- **BLoC/Cubit** - Centralizirano upravljanje stanjem
- **Stream-based komunikacija** - Reaktivni podatkovni tokovi
- **Equatable** - Optimizacija performansi kroz value equality
- **Real-time updates** - Firebase Firestore real-time listeners
- **Error handling** - Centralizirano upravljanje greškama s lokaliziranim porukama

### 🎨 UI/UX Design
- **Material Design 3** - Moderna dizajnerska načela
- **Responzivni design** - Prilagodba različitim veličinama ekrana
- **Accessibility** - Podrška za pristupačnost
- **Animate transitions** - Glatke animacije između ekrana
- **Consistent theming** - Jedinstvena tema kroz cijelu aplikaciju

## 🛠️ Tehnologije i paketi

### 📱 Flutter paketi
```yaml
# Core Flutter
flutter: sdk
flutter_localizations: sdk

# UI & Navigation
go_router: ^15.1.2           # Declarative routing
google_fonts: ^6.2.1        # Typography
flutter_native_splash: ^2.4.4 # Splash screen

# State Management
flutter_bloc: ^9.1.1        # BLoC pattern implementation
equatable: ^2.0.7           # Value equality

# Backend Services
firebase_core: ^3.13.1      # Firebase initialization
firebase_auth: ^5.5.4       # Authentication
cloud_firestore: ^5.6.8     # NoSQL database
firebase_storage: ^12.4.6   # File storage

# Maps & Location
google_maps_flutter: ^2.12.2 # Google Maps integration
geolocator: ^14.0.1         # Location services
google_polyline_algorithm: ^3.1.0 # Route encoding

# Dependency Injection
get_it: ^8.0.3              # Service locator
injectable: ^2.3.2          # Code generation for DI

# Networking & Data
http: ^1.4.0                # HTTP client
dio: ^5.8.0+1               # Advanced HTTP client
connectivity_plus: ^6.1.4   # Network connectivity

# Local Storage
shared_preferences: ^2.5.3  # Key-value storage

# Notifications
flutter_local_notifications: ^19.2.1 # Local notifications
timezone: ^0.10.1           # Timezone handling
flutter_timezone: ^4.1.1    # Device timezone

# Utilities
qr_flutter: ^4.1.0         # QR code generation
flutter_dotenv: ^5.2.1     # Environment variables
uuid: ^4.5.1                # UUID generation
crypto: ^3.0.6              # Cryptographic functions
url_launcher: ^6.3.1       # External URL launching
app_settings: ^6.1.1       # Device settings access
intl: ^0.20.2               # Internationalization
rxdart: ^0.28.0             # Reactive extensions
```

### 🔧 Development tools
```yaml
# Code Generation
build_runner: ^2.4.8       # Build system
injectable_generator: ^2.4.1 # DI code generation

# Code Quality
flutter_lints: ^6.0.0      # Lint rules
```

## 🚀 Pokretanje aplikacije

### 📋 Preduvjeti
- **Flutter SDK** ≥ 3.32.0
- **Dart SDK** ≥ 3.8.0
- **Android Studio** / **VS Code** s Flutter ekstenzijama
- **Firebase projekt** s konfiguriranim servisima
- **Google Maps API ključ**

### ⚙️ Konfiguracija

1. **Kloniranje repozitorija**
```bash
git clone <repository-url>
cd linos
```

2. **Instalacija ovisnosti**
```bash
flutter pub get
```

3. **Kreiranje .env datoteke**
```bash
# Kreirajte .env datoteku u root direktoriju
MAPS_API_KEY=your_google_maps_api_key_here
LINOS_SECRET_KEY=your_secret_key_for_ticket_encryption
```

4. **Firebase konfiguracija**
   - Dodajte `google-services.json` u `android/app/`
   - Dodajte `GoogleService-Info.plist` u `ios/Runner/`
   - Konfigurirajte Firebase Authentication, Firestore i Storage

5. **Google Maps konfiguracija**
   - **Android**: Dodajte API ključ u `android/app/src/main/AndroidManifest.xml`
   - **iOS**: Dodajte API ključ u `ios/Runner/Info.plist`

6. **Generiranje koda**
```bash
flutter packages pub run build_runner build
```

### 🔥 Pokretanje aplikacije
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

## 🌐 Lokalizacija

Aplikacija podržava potpunu lokalizaciju s dvije glavne jezične varijante:

### 📝 Podržani jezici
- **Engleski** (en) 
- **Hrvatski** (hr) 

### 🔧 Lokalizacijska infrastruktura
- **ARB format** - Application Resource Bundle datoteke za translacije
- **Automatsko generiranje** - flutter gen-l10n za generiranje dart kodova
- **Context extensions** - `context.l10n.key` pristup kroz cijelu aplikaciju
- **Parametrizirane poruke** - Podrška za dinamičke varijable u prijevodima
- **Pluralizacija** - Podrška za različite oblike riječi

### 📋 Dodavanje novih prijevoda
1. Uredite ARB datoteke u `lib/l10n/`
2. Pokrenite `flutter gen-l10n` za generiranje kodova
3. Koristite `context.l10n.key` u UI komponentama
4. Testirajte lokalizaciju u različitim jezicima

### 🌍 Lokalizirani sadržaj
- Sve UI komponente i poruke
- Error poruke i validacije
- Obavijesti
- Vremenski i datumski formati

## 🔒 Sigurnost

### 🛡️ Autentifikacijska sigurnost
- **Firebase Authentication** - Industriji standard za sigurnu autentifikaciju
- **Email/Password** - Sigurna autentifikacija s encrypted komunikacijom
- **Session management** - Automatsko upravljanje korisničkim sesijama
- **Password reset** - Sigurna funkcionalnost resetiranja lozinke
- **Input validacija** - Striktna validacija email adresa i lozinki
- **Error handling** - Lokalizirane poruke grešaka za sve scenarije

### 🎟️ Sigurnost karata
- **Kriptografska validacija** - SHA-256 hash za svaku kartu
- **Environment varijable** - Tajni ključevi pohranjeni u .env datoteci
- **QR kod enkripcija** - Base64 kodiranje s sigurnosnim hashom
- **Timestamp validacija** - Provjera valjanosti karte prema vremenu
- **Unique ID generiranje** - UUID v4 za jedinstvene identifikatore

### 📡 Network sigurnost
- **HTTPS komunikacija** - Sva komunikacija s vanjskim API-jima
- **Firebase Rules** - Sigurnosna pravila na Firestore razini
- **API ključevi** - Sigurno pohranjivanje i korištenje API ključeva
- **Connectivity checks** - Provjera mrežne povezanosti

### 🔐 Data privacy
- **Minimalna data kolekcija** - Prikupljanje samo potrebnih podataka
- **User consent** - Jasno traženje dozvola za lokaciju i notifikacije
- **Secure storage** - Sigurno pohranjivanje osjetljivih podataka u SharedPreferences
- **Real-time validation** - Trenutna provjera valjanosti tokena i sesija

### 🔐 QR kod sigurnost
QR kodovi sadrže enkodirane podatke s dodatnim sigurnosnim slojem:
- **ID karte** - Jedinstveni identifikator
- **Tip karte** - Vrsta vozne karte
- **Vrijeme isteka** - ISO8601 format timestamp
- **Kriptografski hash** - SHA-256 hash za validaciju autentičnosti

## 📊 Firebase struktura

### 🗄️ Firestore kolekcije
```
users/
├── {userId}/
│   ├── tickets/           # Korisničke karte
│   │   ├── id: string     # Jedinstveni ID karte
│   │   ├── type: string   # Tip karte (single, daily, weekly, monthly)
│   │   ├── purchaseDate: timestamp
│   │   ├── validFrom: timestamp
│   │   ├── validUntil: timestamp
│   │   ├── status: string # active, expired, used
│   │   ├── qrCode: string # Generirani QR kod
│   │   └── pricePaid: number
│   ├── balance/           # Stanje računa
│   │   ├── current/
│   │   │   ├── amount: number
│   │   │   └── lastUpdated: timestamp
│   └── favorite_stops/    # Omiljene stanice
│       ├── id: string     # ID stanice
│       ├── name: string   # Naziv stanice
│       ├── type: string   # tram/bus
│       ├── coordinates: geopoint
│       └── addedAt: timestamp

balance_logs/              # Logovi dodavanja sredstava
├── userId: string
├── amount: number
├── previousBalance: number
├── newBalance: number
└── timestamp: timestamp

ticket_validation_logs/    # Logovi validacije karata (buduće)
└── purchase_logs/         # Logovi kupnje (buduće)
```

### 🔧 Firebase servisi
- **Authentication** - Upravljanje korisnicima i sesijama
- **Firestore** - NoSQL baza podataka s real-time slušačima
- **Storage** - Pohranjivanje datoteka (rezervirano za buduća proširenja)
- **Functions** - Cloud funkcije za server-side logiku (planirano)

### 🔐 Firestore sigurnosna pravila
```javascript
// Korisnici mogu pristupiti samo svojim podacima
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
  
  match /tickets/{ticketId} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
  }
  
  match /balance/{document=**} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
  }
}
```
- **Storage** - Pohranjivanje datoteka (buduće proširenje)

## 📈 Buduća proširenja

### 🚀 Kratkotrajni ciljevi 
- **Real-time tracking** - Praćenje vozila u stvarnom vremenu s GPS podacima
- **Offline mode** - Osnovna funkcionalnost bez internetske veze
- **Push notifications enhancement** - Pametniji algoritmi za obavijesti
- **Performance optimizacija** - Poboljšanja brzine i responzivnosti

### 🎯 Srednjotrajni ciljevi 
- **Payment gateway integracija** - Visa, Mastercard, Google Pay, Apple Pay
- **Social features** - Dijeljenje ruta, grupne karte, preporuke
- **Advanced analytics** - Detaljni dashboard za analitiku korištenja
- **Multi-city support** - Proširenje na druge gradove u Hrvatskoj

### 🌟 Dugotrajni ciljevi 
- **AI-powered route optimization** - Machine learning za optimalne rute
- **Accessibility enhancements** - Kompletna podrška za osobe s invaliditetom
- **IoT integracija** - Pametne stanice i vozila
- **Blockchain ticketing** - Decentralizirani sustav karata

### 🔧 Tehnička poboljšanja
- **Microservices architecture** - Skalabilnost backend sustava
- **GraphQL API** - Efikasnija komunikacija podataka
- **Progressive Web App** - Web verzija aplikacije
- **CI/CD pipeline** - Potpuna automatizacija deploymenta

### 🌍 Međunarodna ekspanzija
- **Višejezična podrška** - Dodavanje novih jezika
- **Lokalizacija za različite tržišta** - Prilagodba lokalnim potrebama
- **Integracjie s međunarodnim sustavima** - GTFS, OpenStreetMap
- **Compliance** - GDPR, lokalni propisi

---

## 🎓 Akademska napomena

> **Važno**: Ovaj projekt je kreiran u edukacijske svrhe kao dio kolegija **Razvoj mobilnih aplikacija** na [Fakultet elektrotehnike računarstva i informacijskih tehnologija Osijek]. Aplikacija predstavlja simulaciju stvarnog sustava javnog prijevoza grada Osijeka i služi za demonstraciju moderne Flutter razvojne prakse.

### 📚 Kolegij informacije
- **Kolegij**: Razvoj mobilnih aplikacija
- **Akademska godina**: 2024/2025
- **Profesor**: [Josip Balen]
- **Asistent**: [Miljenko Švarcmajer]
- **Student**: [Karlo Kraml]

### 🎯 Ciljevi
Ovaj projekt demonstrira:
- Flutter framework i Dart programski jezik
- Clean Architecture i SOLID principe
- BLoC state management pattern
- Firebase backend integraciju
- Google Maps API implementaciju
- Lokalizaciju i internacionalizaciju

---

**Verzija dokumentacije**: 1.0.0  
**Zadnje ažuriranje**: June 2025  
**Flutter verzija**: 3.32.0  
**Minimum SDK**: Android 21+ / iOS 11.0+
