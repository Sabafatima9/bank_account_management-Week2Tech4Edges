import 'package:flutter/material.dart';

void main() => runApp(const BankApp());

/// ---------------- Exceptions ----------------

class InsufficientFundsException implements Exception {
  final String message;
  InsufficientFundsException(this.message);
  @override
  String toString() => message;
}

class InvalidAmountException implements Exception {
  final String message;
  InvalidAmountException(this.message);
  @override
  String toString() => message;
}

/// ---------------- Models (Encapsulation + Inheritance) ----------------

class BankAccount {
  final String _accountNumber;
  final String _accountHolder;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolder) : _balance = 0.0;

  BankAccount.withInitialDeposit(
      this._accountNumber,
      this._accountHolder,
      double initialDeposit,
      ) : _balance = 0.0 {
    if (initialDeposit < 0) {
      throw InvalidAmountException('Initial deposit cannot be negative.');
    }
    _balance = initialDeposit;
  }

  String get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;
  String get accountType => 'Standard Account';

  void deposit(double amount) {
    if (amount <= 0) {
      throw InvalidAmountException('Deposit amount must be greater than zero.');
    }
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw InvalidAmountException('Withdrawal amount must be greater than zero.');
    }
    if (amount > _balance) {
      throw InsufficientFundsException(
        'Insufficient balance. Available: Rs. ${_balance.toStringAsFixed(2)}, '
            'Requested: Rs. ${amount.toStringAsFixed(2)}.',
      );
    }
    _balance -= amount;
  }

  double checkBalance() => _balance;

  void applyBalanceChange(double delta) {
    _balance += delta;
  }
}

class SavingsAccount extends BankAccount {
  final double interestRate;

  SavingsAccount(String accountNumber, String accountHolder, this.interestRate)
      : super(accountNumber, accountHolder);

  SavingsAccount.withInitialDeposit(
      String accountNumber,
      String accountHolder,
      double initialDeposit,
      this.interestRate,
      ) : super.withInitialDeposit(accountNumber, accountHolder, initialDeposit);

  @override
  String get accountType => 'Savings Account';

  double applyInterest() {
    final interest = balance * (interestRate / 100);
    deposit(interest);
    return interest;
  }
}

class CurrentAccount extends BankAccount {
  final double overdraftLimit;

  CurrentAccount(String accountNumber, String accountHolder, this.overdraftLimit)
      : super(accountNumber, accountHolder);

  CurrentAccount.withInitialDeposit(
      String accountNumber,
      String accountHolder,
      double initialDeposit,
      this.overdraftLimit,
      ) : super.withInitialDeposit(accountNumber, accountHolder, initialDeposit);

  @override
  String get accountType => 'Current Account';

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      throw InvalidAmountException('Withdrawal amount must be greater than zero.');
    }
    final projectedBalance = balance - amount;
    if (projectedBalance < -overdraftLimit) {
      throw InsufficientFundsException(
        'Withdrawal exceeds overdraft limit. Available (incl. overdraft): '
            'Rs. ${(balance + overdraftLimit).toStringAsFixed(2)}, '
            'Requested: Rs. ${amount.toStringAsFixed(2)}.',
      );
    }
    applyBalanceChange(-amount);
  }
}

/// ---------------- App ----------------

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Account Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2E5EFF),
          secondary: Color(0xFF00C9A7),
        ),
      ),
      home: const BankHomePage(),
    );
  }
}

class BankHomePage extends StatefulWidget {
  const BankHomePage({super.key});
  @override
  State<BankHomePage> createState() => _BankHomePageState();
}

class _BankHomePageState extends State<BankHomePage> {
  BankAccount? _account;
  String? _lastMessage;
  bool _lastMessageIsError = false;

  void _flash(String message, {bool isError = false}) {
    setState(() {
      _lastMessage = message;
      _lastMessageIsError = isError;
    });
  }

  String _generateAccountNumber() {
    final rand = DateTime.now().millisecondsSinceEpoch % 900000 + 100000;
    return 'ACC-$rand';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (_account == null) _CreateAccountForm(
                  onCreate: (account) {
                    setState(() => _account = account);
                    _flash('Account created successfully!');
                  },
                  generateAccountNumber: _generateAccountNumber,
                ) else _AccountDashboard(
                  account: _account!,
                  onMessage: _flash,
                  onRefresh: () => setState(() {}),
                ),
                if (_lastMessage != null) ...[
                  const SizedBox(height: 16),
                  _MessageBanner(message: _lastMessage!, isError: _lastMessageIsError),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E5EFF), Color(0xFF00C9A7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5EFF).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'BANK ACCOUNT MANAGEMENT SYSTEM',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6),

        ],
      ),
    );
  }
}

/// ---------------- Shared UI helpers ----------------

Widget sectionCard({required String title, required Widget child, Color accent = const Color(0xFF2E5EFF)}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF141B2E),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: accent),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.6),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: const Color(0xFF0B1220),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2E5EFF), width: 1.5),
    ),
  );
}

Widget infoRow(String label, String value, {Color valueColor = Colors.white}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60)),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _MessageBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const _MessageBanner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final color = isError ? Colors.redAccent : Colors.greenAccent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        (isError ? '✘  ' : '✔  ') + message,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// ---------------- Create Account Form ----------------

class _CreateAccountForm extends StatefulWidget {
  final void Function(BankAccount) onCreate;
  final String Function() generateAccountNumber;
  const _CreateAccountForm({required this.onCreate, required this.generateAccountNumber});

  @override
  State<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _depositController = TextEditingController(text: '0');
  final _rateOrOverdraftController = TextEditingController(text: '0');
  String _accountType = 'Savings';

  @override
  Widget build(BuildContext context) {
    final isSavings = _accountType == 'Savings';

    return Form(
      key: _formKey,
      child: Column(
        children: [
          sectionCard(
            title: 'Open a New Account',
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration('Account holder name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name cannot be empty' : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _accountType,
                  dropdownColor: const Color(0xFF141B2E),
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration('Account type'),
                  items: const [
                    DropdownMenuItem(value: 'Savings', child: Text('Savings Account')),
                    DropdownMenuItem(value: 'Current', child: Text('Current Account')),
                  ],
                  onChanged: (v) => setState(() => _accountType = v!),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _depositController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration('Initial deposit (0 for none)'),
                  validator: (v) => double.tryParse(v ?? '') == null ? 'Enter a valid number' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _rateOrOverdraftController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration(
                    isSavings ? 'Annual interest rate % (e.g. 5)' : 'Overdraft limit (0 for none)',
                  ),
                  validator: (v) => double.tryParse(v ?? '') == null ? 'Enter a valid number' : null,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E5EFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('OPEN ACCOUNT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final holderName = _nameController.text.trim();
    final accountNumber = widget.generateAccountNumber();
    final initialDeposit = double.parse(_depositController.text.trim());
    final rateOrOverdraft = double.parse(_rateOrOverdraftController.text.trim());

    BankAccount account;
    if (_accountType == 'Savings') {
      account = initialDeposit > 0
          ? SavingsAccount.withInitialDeposit(accountNumber, holderName, initialDeposit, rateOrOverdraft)
          : SavingsAccount(accountNumber, holderName, rateOrOverdraft);
    } else {
      account = initialDeposit > 0
          ? CurrentAccount.withInitialDeposit(accountNumber, holderName, initialDeposit, rateOrOverdraft)
          : CurrentAccount(accountNumber, holderName, rateOrOverdraft);
    }

    widget.onCreate(account);
  }
}

/// ---------------- Dashboard (after account creation) ----------------

class _AccountDashboard extends StatefulWidget {
  final BankAccount account;
  final void Function(String message, {bool isError}) onMessage;
  final VoidCallback onRefresh;
  const _AccountDashboard({required this.account, required this.onMessage, required this.onRefresh});

  @override
  State<_AccountDashboard> createState() => _AccountDashboardState();
}

class _AccountDashboardState extends State<_AccountDashboard> {
  Future<double?> _askAmount(String title) async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141B2E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: inputDecoration('Amount (Rs.)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, double.tryParse(controller.text.trim())),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeposit() async {
    final amount = await _askAmount('Deposit Amount');
    if (amount == null) return;
    try {
      widget.account.deposit(amount);
      widget.onMessage('Deposited Rs. ${amount.toStringAsFixed(2)} successfully.');
    } on InvalidAmountException catch (e) {
      widget.onMessage(e.toString(), isError: true);
    }
    setState(() {});
  }

  Future<void> _handleWithdraw() async {
    final amount = await _askAmount('Withdraw Amount');
    if (amount == null) return;
    try {
      widget.account.withdraw(amount);
      widget.onMessage('Withdrew Rs. ${amount.toStringAsFixed(2)} successfully.');
    } on InsufficientFundsException catch (e) {
      widget.onMessage(e.toString(), isError: true);
    } on InvalidAmountException catch (e) {
      widget.onMessage(e.toString(), isError: true);
    }
    setState(() {});
  }

  void _handleApplyInterest() {
    final account = widget.account;
    if (account is SavingsAccount) {
      final interest = account.applyInterest();
      widget.onMessage('Interest of Rs. ${interest.toStringAsFixed(2)} credited.');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;

    return Column(
      children: [
        sectionCard(
          title: 'Account Details',
          accent: const Color(0xFF00C9A7),
          child: Column(
            children: [
              infoRow('Account Holder', account.accountHolder),
              infoRow('Account Number', account.accountNumber),
              infoRow('Account Type', account.accountType),
              infoRow('Balance', 'Rs. ${account.balance.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF00C9A7)),
              if (account is SavingsAccount)
                infoRow('Interest Rate', '${account.interestRate}% / year'),
              if (account is CurrentAccount)
                infoRow('Overdraft Limit', 'Rs. ${account.overdraftLimit.toStringAsFixed(2)}'),
            ],
          ),
        ),
        sectionCard(
          title: 'Actions',
          child: Column(
            children: [
              _actionButton('Deposit', Icons.arrow_downward, _handleDeposit),
              const SizedBox(height: 10),
              _actionButton('Withdraw', Icons.arrow_upward, _handleWithdraw),
              if (account is SavingsAccount) ...[
                const SizedBox(height: 10),
                _actionButton('Apply Annual Interest', Icons.percent, _handleApplyInterest),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}