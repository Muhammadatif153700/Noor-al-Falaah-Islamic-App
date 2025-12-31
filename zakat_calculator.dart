// lib/screens/zakat_calculator.dart
import 'package:flutter/material.dart';

class ZakatCalculator extends StatefulWidget {
  const ZakatCalculator({super.key});

  @override
  State<ZakatCalculator> createState() => _ZakatCalculatorState();
}

class _ZakatCalculatorState extends State<ZakatCalculator> {
  // Input fields
  double _cash = 0;
  double _gold = 0;
  double _silver = 0;
  double _stocks = 0;
  double _businessAssets = 0;
  double _loansReceivable = 0;
  double _otherAssets = 0;

  // Liabilities
  double _debts = 0;
  double _expenses = 0;

  // Results
  double _totalAssets = 0;
  double _totalLiabilities = 0;
  double _netWorth = 0;
  double _zakatAmount = 0;

  // Current prices (can be updated via API)
  final double _goldPricePerGram = 7000; // Example: 7000 PKR per gram
  final double _silverPricePerGram = 80; // Example: 80 PKR per gram
  final double _nisabGold = 87.48; // grams (7.5 tola)
  final double _nisabSilver = 612.36; // grams (52.5 tola)

  void _calculateZakat() {
    setState(() {
      // Convert gold and silver to monetary value
      double goldValue = _gold * _goldPricePerGram;
      double silverValue = _silver * _silverPricePerGram;

      // Calculate total assets
      _totalAssets = _cash + goldValue + silverValue + _stocks +
          _businessAssets + _loansReceivable + _otherAssets;

      // Calculate total liabilities
      _totalLiabilities = _debts + _expenses;

      // Calculate net worth
      _netWorth = _totalAssets - _totalLiabilities;

      // Calculate Zakat (2.5% of net worth if above nisab)
      _zakatAmount = (_netWorth >= _calculateNisabValue())
          ? _netWorth * 0.025
          : 0;
    });
  }

  double _calculateNisabValue() {
    // Nisab is the minimum of gold or silver nisab value
    double goldNisab = _nisabGold * _goldPricePerGram;
    double silverNisab = _nisabSilver * _silverPricePerGram;

    return goldNisab < silverNisab ? goldNisab : silverNisab;
  }

  void _resetCalculator() {
    setState(() {
      _cash = 0;
      _gold = 0;
      _silver = 0;
      _stocks = 0;
      _businessAssets = 0;
      _loansReceivable = 0;
      _otherAssets = 0;
      _debts = 0;
      _expenses = 0;
      _totalAssets = 0;
      _totalLiabilities = 0;
      _netWorth = 0;
      _zakatAmount = 0;
    });
  }

  Widget _buildInputField(String label, String hint, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              suffixText: 'PKR',
              suffixStyle: TextStyle(color: Colors.grey.shade600),
            ),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              double val = double.tryParse(text) ?? 0;
              onChanged(val);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGoldSilverField(String label, String unit, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter amount',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              suffixText: unit,
              suffixStyle: TextStyle(color: Colors.grey.shade600),
            ),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              double val = double.tryParse(text) ?? 0;
              onChanged(val);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF074C4C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakat Calculator'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Zakat Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Zakat is 2.5% of your wealth held for one lunar year',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  Text(
                    '• Nisab threshold: 87.48g gold or 612.36g silver',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  Text(
                    '• Exclude personal use items and immediate expenses',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'Your Assets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Assets Inputs
            _buildInputField('Cash & Bank Balance', 'Enter amount', _cash, (value) => _cash = value),
            _buildGoldSilverField('Gold', 'grams', _gold, (value) => _gold = value),
            _buildGoldSilverField('Silver', 'grams', _silver, (value) => _silver = value),
            _buildInputField('Stocks & Investments', 'Enter amount', _stocks, (value) => _stocks = value),
            _buildInputField('Business Assets', 'Enter amount', _businessAssets, (value) => _businessAssets = value),
            _buildInputField('Loans Receivable', 'Enter amount', _loansReceivable, (value) => _loansReceivable = value),
            _buildInputField('Other Assets', 'Enter amount', _otherAssets, (value) => _otherAssets = value),

            Text(
              'Liabilities & Expenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Liabilities Inputs
            _buildInputField('Outstanding Debts', 'Enter amount', _debts, (value) => _debts = value),
            _buildInputField('Immediate Expenses (next 30 days)', 'Enter amount', _expenses, (value) => _expenses = value),

            const SizedBox(height: 25),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateZakat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CALCULATE ZAKAT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (_zakatAmount > 0) ...[
              // Results Section
              Text(
                'Zakat Calculation Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              Column(
                children: [
                  _buildResultCard('Total Assets', '${_totalAssets.toStringAsFixed(0)} PKR', Colors.green),
                  const SizedBox(height: 12),
                  _buildResultCard('Total Liabilities', '${_totalLiabilities.toStringAsFixed(0)} PKR', Colors.orange),
                  const SizedBox(height: 12),
                  _buildResultCard('Net Worth', '${_netWorth.toStringAsFixed(0)} PKR', Colors.blue),
                  const SizedBox(height: 12),
                  _buildResultCard('Your Zakat Amount', '${_zakatAmount.toStringAsFixed(0)} PKR', primaryColor),
                ],
              ),

              const SizedBox(height: 16),

              // Reset Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resetCalculator,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Text('Reset Calculator'),
                ),
              ),
            ] else if (_totalAssets > 0) ...[
              // Not eligible for Zakat
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'Not Eligible for Zakat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your net worth is below the nisab threshold (${_calculateNisabValue().toStringAsFixed(0)} PKR)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 25),

            // Zakat Distribution Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Who Receives Zakat?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. The Poor\n2. The Needy\n3. Those employed to collect Zakat\n4. Those whose hearts are to be reconciled\n5. Those in bondage (slaves)\n6. The debt-ridden\n7. In the cause of Allah\n8. The wayfarer (traveler in need)',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}