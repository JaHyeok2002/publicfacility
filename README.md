# 🏢 publicfacility

> 공공시설 정보를 조회하고 관리할 수 있는 iOS 기반 공공시설 안내 서비스

publicfacility는 사용자가 공공시설 정보를 편리하게 확인할 수 있도록
Spring Boot 백엔드와 iOS 프론트엔드를 연동하여 제작한 앱 프로젝트입니다.

사용자는 앱을 통해 공공시설 정보를 조회하고,
즐겨찾기 및 최근 조회 기능을 활용하여 필요한 시설 정보를 쉽게 관리할 수 있습니다.

<br>

---

## 📚 목차

* [🎯 프로젝트 개요](#-프로젝트-개요)
* [✨ 주요 기능](#-주요-기능)
* [🛠 기술 스택](#-기술-스택)
* [📱 주요 화면](#-주요-화면)
* [🔗 API 구조](#-api-구조)
* [🚀 실행 방법](#-실행-방법)
* [📁 프로젝트 구조](#-프로젝트-구조)
* [📌 Contact](#-contact)

<br>

---

## 🎯 프로젝트 개요

publicfacility는 공공시설 정보를 제공하는 iOS 앱 서비스입니다.

백엔드는 Spring Boot 기반 REST API 서버로 구성했으며,
프론트엔드는 iOS 앱으로 제작했습니다.

사용자는 회원가입 및 로그인을 통해 서비스를 이용할 수 있고,
공공시설 목록 조회, 시설 상세 정보 확인, 즐겨찾기, 최근 조회 기능 등을 사용할 수 있습니다.

<br>

### 핵심 목표

* 공공시설 정보를 사용자에게 편리하게 제공
* Spring Boot 기반 REST API 서버 구현
* iOS 앱과 백엔드 API 연동
* JWT 기반 로그인 인증 구조 적용
* 즐겨찾기 및 최근 조회 기능을 통한 사용자 편의성 향상

<br>

---

## ✨ 주요 기능

* 👤 회원가입 및 로그인
* 🔐 JWT 기반 인증
* 🏢 공공시설 정보 조회
* 🚻 공공화장실 데이터 조회
* ⭐ 즐겨찾기 등록 및 삭제
* 🕘 최근 조회 시설 관리
* 📱 iOS 앱 화면 구성
* 🔗 백엔드 REST API 연동
* 🗄️ H2 Database 연동
* 🌐 공공데이터 API 활용

<br>

---

## 🛠 기술 스택

### Backend

![Java](https://img.shields.io/badge/Java-17-007396?style=for-the-badge\&logo=openjdk\&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-Backend-6DB33F?style=for-the-badge\&logo=springboot\&logoColor=white)
![Spring Security](https://img.shields.io/badge/Spring_Security-Authentication-6DB33F?style=for-the-badge\&logo=springsecurity\&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-Authentication-000000?style=for-the-badge\&logo=jsonwebtokens\&logoColor=white)
![Spring Data JPA](https://img.shields.io/badge/Spring_Data_JPA-Hibernate-59666C?style=for-the-badge\&logo=hibernate\&logoColor=white)
![Gradle](https://img.shields.io/badge/Gradle-Build_Tool-02303A?style=for-the-badge\&logo=gradle\&logoColor=white)

<br>

### Database

![H2](https://img.shields.io/badge/H2-Database-09476B?style=for-the-badge\&logoColor=white)

<br>

### Frontend

![Swift](https://img.shields.io/badge/Swift-iOS-FA7343?style=for-the-badge\&logo=swift\&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-UI_Framework-0D96F6?style=for-the-badge\&logo=swift\&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-iOS_IDE-147EFB?style=for-the-badge\&logo=xcode\&logoColor=white)

<br>

### Tool

![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge\&logo=github\&logoColor=white)
![IntelliJ IDEA](https://img.shields.io/badge/IntelliJ_IDEA-Backend_IDE-000000?style=for-the-badge\&logo=intellijidea\&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-API_Test-FF6C37?style=for-the-badge\&logo=postman\&logoColor=white)

<br>

---

## 📱 주요 화면

### 1. 로그인 화면

> 사용자가 이메일과 비밀번호를 입력하여 로그인할 수 있습니다.

<br>

### 2. 회원가입 화면

> 사용자가 계정을 생성하고 서비스를 이용할 수 있습니다.

<br>

### 3. 홈 화면

> 공공시설 정보를 확인할 수 있는 메인 화면입니다.

<br>

### 4. 공공시설 목록 화면

> 등록된 공공시설 목록을 조회할 수 있습니다.

<br>

### 5. 시설 상세 화면

> 선택한 공공시설의 상세 정보를 확인할 수 있습니다.

<br>

### 6. 즐겨찾기 화면

> 자주 이용하는 공공시설을 즐겨찾기로 관리할 수 있습니다.

<br>

### 7. 최근 조회 화면

> 최근에 확인한 공공시설 정보를 다시 확인할 수 있습니다.

<br>

---

## 🔗 API 구조

### Auth API

| Method | URL                | 설명   |
| ------ | ------------------ | ---- |
| POST   | `/api/auth/signup` | 회원가입 |
| POST   | `/api/auth/login`  | 로그인  |

<br>

### User API

| Method | URL             | 설명      |
| ------ | --------------- | ------- |
| GET    | `/api/users/me` | 내 정보 조회 |
| PUT    | `/api/users/me` | 내 정보 수정 |

<br>

### Facility API

| Method | URL                    | 설명         |
| ------ | ---------------------- | ---------- |
| GET    | `/api/facilities`      | 공공시설 목록 조회 |
| GET    | `/api/facilities/{id}` | 공공시설 상세 조회 |

<br>

### Favorite API

| Method | URL                   | 설명         |
| ------ | --------------------- | ---------- |
| GET    | `/api/favorites`      | 즐겨찾기 목록 조회 |
| POST   | `/api/favorites`      | 즐겨찾기 등록    |
| DELETE | `/api/favorites/{id}` | 즐겨찾기 삭제    |

<br>

### Recent API

| Method | URL           | 설명          |
| ------ | ------------- | ----------- |
| GET    | `/api/recent` | 최근 조회 목록 조회 |
| POST   | `/api/recent` | 최근 조회 등록    |

<br>

---

## 🚀 실행 방법

## 1. 저장소 클론

```bash
git clone https://github.com/JaHyeok2002/publicfacility.git
cd publicfacility
```

<br>

## 2. Backend 실행

```bash
cd backend
./gradlew bootRun
```

<br>

### H2 Database 접속

```text
http://localhost:8080/h2-console
```

<br>

### 기본 서버 주소

```text
http://localhost:8080
```

<br>

## 3. Frontend 실행

```text
frontend/pulbicfacilityApp.xcodeproj
```

위 파일을 Xcode에서 열고 실행합니다.

<br>

---

## 📁 프로젝트 구조

```text
publicfacility
├── backend
│   ├── src
│   │   ├── main
│   │   │   ├── java
│   │   │   │   └── com.example.publicfacility
│   │   │   │       ├── auth
│   │   │   │       ├── facility
│   │   │   │       ├── favorite
│   │   │   │       ├── global
│   │   │   │       ├── recent
│   │   │   │       ├── user
│   │   │   │       └── PublicfacilityApplication
│   │   │   └── resources
│   │   │       ├── application.yaml
│   │   │       ├── static
│   │   │       └── templates
│   │   └── test
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradlew
│
├── frontend
│   ├── pulbicfacilityApp
│   │   ├── Components
│   │   ├── Models
│   │   ├── Services
│   │   ├── ViewModels
│   │   ├── Views
│   │   ├── Assets.xcassets
│   │   ├── AppDelegate.swift
│   │   ├── ContentView.swift
│   │   ├── SceneDelegate.swift
│   │   └── ViewController.swift
│   └── pulbicfacilityApp.xcodeproj
│
└── .gitignore
```

<br>

---

## 📌 개발 내용

### Backend

* Spring Boot 기반 REST API 서버 구현
* 회원가입 및 로그인 API 구현
* JWT 기반 인증 구조 구현
* 사용자 도메인 설계
* 공공시설 도메인 설계
* 즐겨찾기 기능 구현
* 최근 조회 기능 구현
* H2 Database 연동
* 공공데이터 API 연동 구조 구현

<br>

### Frontend

* iOS 앱 프로젝트 구성
* SwiftUI 기반 화면 구현
* MVVM 구조 적용
* Model, Service, ViewModel, View 계층 분리
* 로그인 및 회원가입 화면 구현
* 공공시설 목록 및 상세 화면 구현
* 즐겨찾기 화면 구현
* 최근 조회 화면 구현
* 백엔드 API 통신 구조 구현

<br>

---

## 📌 Contact

* GitHub: [JaHyeok2002](https://github.com/JaHyeok2002)
* Project Repository: [publicfacility](https://github.com/JaHyeok2002/publicfacility)

<br>

---

## 👤 작성자

| 이름  | 역할                 | 담당                                |
| --- | ------------------ | --------------------------------- |
| 구자혁 | Backend / Frontend | Spring Boot 백엔드 및 iOS 프론트엔드 전체 구현 |
