import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promotion Setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const PromotionSetupScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PromotionSetupScreen extends StatefulWidget {
  const PromotionSetupScreen({super.key});

  @override
  State<PromotionSetupScreen> createState() => _PromotionSetupScreenState();
}

class _PromotionSetupScreenState extends State<PromotionSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _promoNameController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _selectedLocation;

  // Location dropdown values as specified
  final List<String> _locations = ['Kandy', 'Colombo', 'Negombo'];

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _promoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.indigo],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.local_offer_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Promotion Setup',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Create a new promotional campaign',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Promo Name Field
                      const Text(
                        'Promo Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _promoNameController,
                        decoration: InputDecoration(
                          hintText: 'e.g., Aurudu Sale 2024',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.tag_outlined,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a promo name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Date Time Field
                      const Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDateTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.blue,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDateTime == null
                                      ? 'Select date & time'
                                      : '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} • ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: _selectedDateTime == null
                                        ? Colors.grey.shade500
                                        : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Location Dropdown - Values from array ['Kandy', 'Colombo', 'Negombo']
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedLocation,
                          hint: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Select a location',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blue,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: _locations.map((location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_city,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    location,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a location';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Create Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Promotion created at $_selectedLocation!',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              // Optional: Reset form
                              // _promoNameController.clear();
                              // setState(() {
                              //   _selectedDateTime = null;
                              //   _selectedLocation = null;
                              // });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Create',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Hint text
                      Center(
                        child: Text(
                          'Fill in all fields to create your promotion',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
