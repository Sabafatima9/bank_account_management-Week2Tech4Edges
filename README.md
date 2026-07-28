<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:00C9A7,100:2E5EFF&height=220&section=header&text=Bank%20Account%20Management&fontSize=36&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=A%20polished%20Dart%20OOP%20console%20app%20%E2%80%A2%20Tech4Edges%20Internship%20%E2%80%A2%20Week%202&descAlignY=58&descSize=16" width="100%"/>

<img src="https://readme-typing-svg.demolab.com/?font=Fira+Code&pause=1000&color=2E5EFF&center=true&vCenter=true&width=560&lines=Deposit+%E2%80%A2+Withdraw+%E2%80%A2+Check+Balance;Built+with+Dart+OOP+%E2%80%94+zero+dependencies;Savings+%26+Current+accounts%2C+real+inheritance" />

<br/>

![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![OOP](https://img.shields.io/badge/Paradigm-OOP-2E5EFF?style=for-the-badge)
![Internship](https://img.shields.io/badge/Tech4Edges-Internship-00C9A7?style=for-the-badge)
![Week](https://img.shields.io/badge/Week-2-2E5EFF?style=for-the-badge)

</div>

<br/>

<br>




## 📖 About The Project

**Bank Account Management System** is a console-based Dart application built for **Week 2** of my internship at **Tech4Edges**. It simulates real banking operations — opening an account, depositing, withdrawing, and checking balances — through an interactive, menu-driven terminal interface.

The project is built around genuine object-oriented design: a base `BankAccount` class with proper **encapsulation**, extended by `SavingsAccount` and `CurrentAccount` subclasses that demonstrate real **inheritance** and **method overriding**, plus custom exceptions for clean, predictable error handling.

<br/>

## ✨ Features

| Feature | Description |
|---|---|
| 🏦 **Two Account Types** | `SavingsAccount` (earns interest) and `CurrentAccount` (has an overdraft limit) |
| 🔒 **True Encapsulation** | Balance is private — only ever changed through validated class methods |
| 🧬 **Real Inheritance** | Both account types extend a shared `BankAccount` base class |
| 🧾 **Interactive Menu** | Boxed, color-coded menu — deposit, withdraw, check balance, view details, exit |
| ⚠️ **Custom Exceptions** | `InsufficientFundsException` & `InvalidAmountException` for precise error messages |
| 💳 **Overdraft Support** | `CurrentAccount` overrides `withdraw()` to safely allow controlled overdrafts |
| 📈 **Interest Engine** | `SavingsAccount.applyInterest()` credits interest based on its own rate |

<br/>

## 🖥️ Preview

```
╔════════════════════════════════════════════════════════╗
║             BANK ACCOUNT MANAGEMENT SYSTEM              ║
║          Tech4Edges Internship • Week 2 • Dart App      ║
╚════════════════════════════════════════════════════════╝

┌────────────────────────────────────────────────────────┐
│ MAIN MENU                                               │
├────────────────────────────────────────────────────────┤
│   1. Deposit                                            │
│   2. Withdraw                                           │
│   3. Check Balance                                      │
│   4. Account Details                                    │
│   5. Apply Annual Interest                               │
│   6. Exit                                               │
└────────────────────────────────────────────────────────┘

▌ WITHDRAW
  ✘  Insufficient balance. Available: Rs. 500.00, Requested: Rs. 800.00.
```

<br/>

## 🏗️ Class Design

```
                 ┌────────────────────┐
                 │     BankAccount     │
                 │--------------------│
                 │ - _accountNumber    │
                 │ - _accountHolder    │
                 │ - _balance          │
                 │--------------------│
                 │ + deposit()         │
                 │ + withdraw()        │
                 │ + checkBalance()    │
                 └─────────▲──────────┘
                           │  extends
              ┌────────────┴────────────┐
              │                         │
   ┌──────────────────────┐  ┌───────────────────────┐
   │    SavingsAccount     │  │    CurrentAccount      │
   │-----------------------│  │------------------------│
   │ + interestRate         │  │ + overdraftLimit        │
   │ + applyInterest()       │  │ ⤷ overrides withdraw()   │
   └──────────────────────┘  └───────────────────────┘
```

<br/>

## 🛠️ Tech Stack

![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![ANSI](https://img.shields.io/badge/Terminal-ANSI_Escape_Codes-333333?style=flat-square)
![No Dependencies](https://img.shields.io/badge/Dependencies-None-success?style=flat-square)

<br/>

## 📂 Project Structure

```
bank-account-management/
├── bin/
│   └── main.dart                  # Entry point — menu loop & I/O
├── lib/
│   ├── models/
│   │   ├── bank_account.dart      # Base class (encapsulation, constructors)
│   │   ├── savings_account.dart   # Inheritance — interest logic
│   │   └── current_account.dart   # Inheritance — overdraft logic
│   ├── exceptions/
│   │   └── bank_exceptions.dart   # Custom exception types
│   └── utils/
│       └── console_ui.dart        # Reusable terminal UI toolkit
├── pubspec.yaml
├── .gitignore
└── README.md
```

<br/>

## 🚀 Getting Started

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) installed (`dart --version` to confirm)

### Run it locally

```bash
# 1. Clone the repository
git clone https://github.com/Sabafatima9/bank-account-management.git
cd bank-account-management

# 2. Run the app
dart run bin/main.dart
```

No `pub get` needed — this project has zero external dependencies.

<br/>

## 🎯 Concepts Demonstrated

- ✅ Classes & Objects
- ✅ Constructors & Named Constructors
- ✅ Encapsulation (private fields, controlled access)
- ✅ Methods
- ✅ Inheritance & Method Overriding
- ✅ Custom Exceptions & Exception Handling
- ✅ Business Logic Implementation (overdrafts, interest)

<br/>

## 👩‍💻 Author

<div align="center">

**Saba Fatima**
• IT Student @ Rawalpindi Women University

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sabafatima9)

</div>

<br/>

<div align="center">

*Submitted as part of the Week 2 Internship Assignment at* **Tech4Edges** 🚀

</div>

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:2E5EFF,100:00C9A7&height=100&section=footer" width="100%"/>
