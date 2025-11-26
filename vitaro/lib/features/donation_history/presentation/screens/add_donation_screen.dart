import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_donation_bloc.dart';
import '../bloc/add_donation_event.dart';
import '../bloc/add_donation_state.dart';
import '../../domain/entities/donation.dart';

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final _locationController = TextEditingController(
    text: 'Kigali City Hospital',
  );
  final _amountController = TextEditingController(text: '450');
  final _formKey = GlobalKey<FormState>();

  void _submitDonation() {
    if (_formKey.currentState!.validate()) {
      final amount = int.tryParse(_amountController.text) ?? 0;

      final newDonation = Donation(
        location: _locationController.text,
        amountMl: amount,
        date: DateTime.now(),
        status: 'Processing', // Initial status
      );

      context.read<AddDonationBloc>().add(
        SaveNewDonation(donation: newDonation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color vitaroRed = Color(0xFFD32F2F);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Donation',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocListener<AddDonationBloc, AddDonationState>(
        listener: (context, state) {
          if (state is AddDonationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Donation recorded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AddDonationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Enter Donation Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                // Location Input
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Donation Location',
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: vitaroRed, width: 2),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a location' : null,
                ),
                const SizedBox(height: 20),

                // Amount Input
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (ml)',
                    prefixIcon: const Icon(
                      Icons.bloodtype_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: vitaroRed, width: 2),
                    ),
                  ),
                  validator: (value) =>
                      int.tryParse(value!) == null || int.parse(value) <= 0
                      ? 'Enter a valid amount'
                      : null,
                ),

                const Spacer(),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        context.watch<AddDonationBloc>().state
                            is AddDonationLoading
                        ? null
                        : _submitDonation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vitaroRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child:
                        context.watch<AddDonationBloc>().state
                            is AddDonationLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Record Donation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
