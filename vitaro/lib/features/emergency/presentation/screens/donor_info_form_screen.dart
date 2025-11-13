import 'package:flutter/material.dart';

class DonorInfoFormScreen extends StatefulWidget {
  final String alertId;
  final String hospitalName;
  final String bloodTypeNeeded;

  const DonorInfoFormScreen({
    Key? key,
    required this.alertId,
    required this.hospitalName,
    required this.bloodTypeNeeded,
  }) : super(key: key);

  @override
  State<DonorInfoFormScreen> createState() => _DonorInfoFormScreenState();
}

class _DonorInfoFormScreenState extends State<DonorInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _medicalNotesController = TextEditingController();

  String _selectedBloodType = 'A+';
  String? _lastDonationDate;
  bool _isSubmitting = false;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBloodType =
        widget.bloodTypeNeeded; // Pre-select matching blood type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Information'),
        backgroundColor: Colors.red.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_hospital, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.hospitalName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Blood Type Needed: ${widget.bloodTypeNeeded}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Instructions
              const Text(
                'Please provide your information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'The hospital will use this information to contact you and verify your eligibility.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'John Doe',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: '+250788123456',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value.trim())) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email (Optional)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  hintText: 'john@example.com',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Blood Type
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: InputDecoration(
                  labelText: 'Your Blood Type *',
                  prefixIcon: const Icon(Icons.water_drop),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _bloodTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBloodType = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your blood type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age *',
                  hintText: '25',
                  prefixIcon: const Icon(Icons.cake),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  helperText: 'Must be between 18-65 years old',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value.trim());
                  if (age == null) {
                    return 'Please enter a valid age';
                  }
                  if (age < 18 || age > 65) {
                    return 'Age must be between 18-65';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Last Donation Date
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 90),
                    ),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _lastDonationDate = date.toString().split(' ')[0];
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Last Donation Date (Optional)',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    helperText: 'Must wait 3 months between donations',
                  ),
                  child: Text(
                    _lastDonationDate ?? 'Select date',
                    style: TextStyle(
                      color: _lastDonationDate == null
                          ? Colors.grey.shade600
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Medical Notes
              TextFormField(
                controller: _medicalNotesController,
                decoration: InputDecoration(
                  labelText: 'Medical Notes (Optional)',
                  hintText: 'Any medical conditions we should know about?',
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Important Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'By submitting, you confirm that the information provided is accurate and you are eligible to donate blood.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
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
                          'Submit Response',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Return the collected data
      Navigator.pop(context, {
        'userName': _nameController.text.trim(),
        'userPhone': _phoneController.text.trim(),
        'userEmail': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'userBloodType': _selectedBloodType,
        'userAge': int.parse(_ageController.text.trim()),
        'lastDonationDate': _lastDonationDate,
        'medicalNotes': _medicalNotesController.text.trim().isEmpty
            ? null
            : _medicalNotesController.text.trim(),
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }
}
