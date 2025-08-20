import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanReceiptScreen extends StatefulWidget {
  final String? amount;
  final String? date;
  final String? merchant;
  const ScanReceiptScreen({super.key, this.amount, this.date, this.merchant});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen> {
  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController merchantController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.amount ?? '7.25');
    dateController = TextEditingController(text: widget.date ?? '21/07/2025');
    merchantController =
        TextEditingController(text: widget.merchant ?? 'Gas Station');
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    merchantController.dispose();
    super.dispose();
  }

  void _scanAgain() {
    Navigator.of(context).pop('scan_again');
  }

  void _useThisData() {
    Get.snackbar(
      'Receipt Data Used',
      'Transaction details filled from receipt',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Navigator.of(context).pop({
      'amount': amountController.text,
      'date': dateController.text,
      'merchant': merchantController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildScannedView(),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScannedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.camera_alt, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Receipt Scanner',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 22),
            SizedBox(width: 8),
            Text(
              'Receipt scanned successfully!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Amount',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 6),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 18),
        const Text('Date',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 6),
        TextField(
          controller: dateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              dateController.text =
                  '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
            }
          },
        ),
        const SizedBox(height: 18),
        const Text('Merchant',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 6),
        TextField(
          controller: merchantController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _scanAgain,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Scan Again'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _useThisData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Use This Data'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Icon(Icons.edit, color: Colors.amber, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'You can edit the extracted information above before confirming',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
