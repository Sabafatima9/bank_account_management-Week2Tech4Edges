// Week 2 Assignment - Bank Account Management System
// Concepts: Classes, Objects, Constructors, Named Constructors, Encapsulation,
// Methods, Inheritance, Exception Handling

import 'dart:io';

// Custom exception for insufficient balance
class InsufficientBalanceException implements Exception {
  final String message;
  InsufficientBalanceException(this.message);

  @override
  String toString() => message;
}

// Base class demonstrating encapsulation
class BankAccount {
  // Private fields (encapsulation)
  final String _accountHolder;
  double _balance;

  // Default constructor
  BankAccount(this._accountHolder, this._balance);

  // Named constructor - open account with zero balance
  BankAccount.newAccount(String accountHolder)
      : _accountHolder = accountHolder,
        _balance = 0.0;

  // Getter methods to safely access private fields
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  // Method to deposit money
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be greater than zero.');
      return;
    }
    _balance += amount;
    print('Deposited \$${amount.toStringAsFixed(2)}. New balance: \$${_balance.toStringAsFixed(2)}');
  }

  // Method to withdraw money, throws exception if insufficient funds
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Withdrawal amount must be greater than zero.');
      return;
    }
    if (amount > _balance) {
      throw InsufficientBalanceException(
          'Withdrawal failed: insufficient balance. Available balance: \$${_balance.toStringAsFixed(2)}');
    }
    _balance -= amount;
    print('Withdrew \$${amount.toStringAsFixed(2)}. New balance: \$${_balance.toStringAsFixed(2)}');
  }

  // Method to display balance
  void displayBalance() {
    print('Account Holder: $_accountHolder | Current Balance: \$${_balance.toStringAsFixed(2)}');
  }
}

// Derived class demonstrating inheritance
class SavingsAccount extends BankAccount {
  final double interestRate; // e.g., 0.05 for 5%

  SavingsAccount(String accountHolder, double balance, this.interestRate)
      : super(accountHolder, balance);

  // Named constructor for a new savings account
  SavingsAccount.newAccount(String accountHolder, this.interestRate)
      : super.newAccount(accountHolder);

  // Additional method specific to SavingsAccount
  void applyInterest() {
    double interest = balance * interestRate;
    deposit(interest);
    print('Interest of \$${interest.toStringAsFixed(2)} applied at rate ${(interestRate * 100).toStringAsFixed(1)}%.');
  }
}

void main() {
  print('===== Bank Account Management System =====\n');

  stdout.write('Enter account holder name: ');
  String name = stdin.readLineSync() ?? 'Customer';

  // Create a new savings account using named constructor (Inheritance + Named Constructors)
  SavingsAccount account = SavingsAccount.newAccount(name, 0.05);
  account.displayBalance();

  bool running = true;
  while (running) {
    print('\n--- Menu ---');
    print('1. Deposit');
    print('2. Withdraw');
    print('3. Display Balance');
    print('4. Apply Interest (Savings)');
    print('5. Exit');
    stdout.write('Choose an option: ');

    String? choice = stdin.readLineSync();

    try {
      switch (choice) {
        case '1':
          stdout.write('Enter amount to deposit: ');
          double amount = double.parse(stdin.readLineSync()!.trim());
          account.deposit(amount);
          break;

        case '2':
          stdout.write('Enter amount to withdraw: ');
          double amount = double.parse(stdin.readLineSync()!.trim());
          account.withdraw(amount); // may throw InsufficientBalanceException
          break;

        case '3':
          account.displayBalance();
          break;

        case '4':
          account.applyInterest();
          break;

        case '5':
          running = false;
          print('Thank you for using the Bank Account Management System.');
          break;

        default:
          print('Invalid option. Please choose between 1-5.');
      }
    } on InsufficientBalanceException catch (e) {
      // Handle custom exception
      print(e.toString());
    } on FormatException {
      // Handle invalid number input
      print('Invalid amount entered. Please enter a valid number.');
    } catch (e) {
      // Catch-all for any unexpected errors
      print('An unexpected error occurred: $e');
    }
  }
}
