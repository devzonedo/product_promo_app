import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  void _scanBarcode() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _barcodeController.text = result;
      });
    }
  }

  Future<void> _addProduct() async {
    final String barcode = _barcodeController.text.trim();
    final String productName = _productNameController.text.trim();
    final String price = _priceController.text.trim();

    // Validation
    if (barcode.isEmpty) {
      _showErrorDialog('Barcode is required. Please scan or enter a barcode.');
      return;
    }

    if (productName.isEmpty) {
      _showErrorDialog('Product Name is required.');
      return;
    }

    if (price.isEmpty) {
      _showErrorDialog('Price is required.');
      return;
    }

    // Convert price to double
    double? priceValue;
    try {
      priceValue = double.parse(price);
    } catch (e) {
      _showErrorDialog('Please enter a valid price (e.g., 35.50)');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Call ApiService to add product
    final result = await _apiService.addProduct(
      barcode: barcode,
      name: productName,
      price: priceValue,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      // Success - parse the response data
      final Map<String, dynamic> productData = result['data'];
      final Product product = Product.fromJson(productData);
      _showSuccessDialog(product);
      _clearForm();
    } else {
      // Error
      _showErrorDialog(
        result['error'] ?? 'Failed to add product. Please try again.',
      );
    }
  }

  void _showSuccessDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Successfull', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          // ← Add this to make content scrollable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildDetailRow('Product ID', product.id.toString()),
              const SizedBox(height: 12),
              _buildDetailRow('Name', product.name),
              const SizedBox(height: 12),
              _buildDetailRow('Price', '\$${product.price.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _barcodeController.clear();
      _productNameController.clear();
      _priceController.clear();
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _productNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scan Barcode Section
            const Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _scanBarcode,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to scan barcode',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Barcode Field (Read-only)
            const Text(
              'Barcode *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _barcodeController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Scan or enter barcode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _scanBarcode,
                  tooltip: 'Scan Barcode',
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),

            // Product Name Field (Mandatory)
            const Text(
              'Product Name *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                hintText: 'Enter product name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: 'Required',
                helperStyle: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Price Field (Mandatory)
            const Text(
              'Price *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixText: '\$ ',
                helperText: 'Required',
                helperStyle: const TextStyle(fontSize: 12),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // Add Button with Loading indicator
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Barcode Scanner Page
class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isBusy = false;
  bool _torchEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              setState(() {
                _torchEnabled = !_torchEnabled;
              });
              await _controller.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_isBusy) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? rawValue = barcode.rawValue;
                if (rawValue != null && rawValue.isNotEmpty) {
                  _isBusy = true;
                  Navigator.pop(context, rawValue);
                  return;
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -1,
                    left: -1,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.green, width: 4),
                          left: BorderSide(color: Colors.green, width: 4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.green, width: 4),
                          right: BorderSide(color: Colors.green, width: 4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    left: -1,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.green, width: 4),
                          left: BorderSide(color: Colors.green, width: 4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.green, width: 4),
                          right: BorderSide(color: Colors.green, width: 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Position the barcode inside the frame',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
