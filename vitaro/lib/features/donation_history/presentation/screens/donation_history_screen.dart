import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/donation_history_bloc.dart';
import '../bloc/donation_history_event.dart';
import '../bloc/donation_history_state.dart';
import 'add_donation_screen.dart';
import 'donation_tracking_screen.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonationHistoryBloc>().add(FetchDonationHistory());
  }

  Future<void> _navigateToAddDonation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDonationScreen()),
    );
    if (result == true && mounted) {
      context.read<DonationHistoryBloc>().add(FetchDonationHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonationHistoryBloc, DonationHistoryState>(
      builder: (context, state) {
        bool isEligible = true;
        DateTime? nextDate;

        if (state is DonationHistoryLoaded && state.donations.isNotEmpty) {
          final lastDonation = state.donations.first.date;
          final difference = DateTime.now().difference(lastDonation).inDays;

          if (difference < 56) {
            isEligible = false;
            nextDate = lastDonation.add(const Duration(days: 56));
          }
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'History',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: () => context.read<DonationHistoryBloc>().add(
                  FetchDonationHistory(),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: isEligible ? const Color(0xFFD32F2F) : Colors.grey,
            foregroundColor: Colors.white,
            onPressed: isEligible
                ? _navigateToAddDonation
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "You must wait until ${DateFormat('MMM dd').format(nextDate!)} to donate again.",
                        ),
                      ),
                    );
                  },
            label: Text(isEligible ? 'Add Donation' : 'Not Eligible'),
            icon: Icon(
              isEligible ? Icons.add : Icons.lock_clock,
              color: Colors.white,
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state is DonationHistoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              } else if (state is DonationHistoryError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is DonationHistoryLoaded) {
                int totalAmount = state.donations.fold(
                  0,
                  (sum, item) => sum + item.amountMl,
                );
                int livesSaved = state.donations.length * 3;

                String eligibilityText = "You can donate today!";
                if (!isEligible && nextDate != null) {
                  eligibilityText =
                      "Next eligible date: ${DateFormat('MMM dd, yyyy').format(nextDate)}";
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Donation Eligibility",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            eligibilityText,
                            style: TextStyle(
                              color: isEligible
                                  ? Colors.green[700]
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: state.donations.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: state.donations.length,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              itemBuilder: (context, index) {
                                final donation = state.donations[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.water_drop,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat(
                                                'MMM dd, yyyy',
                                              ).format(donation.date),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              donation.location,
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          donation.status,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DonationTrackingScreen(
                                                    donation: donation,
                                                  ),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 30),
                                        ),
                                        child: const Text(
                                          'Track',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildSummaryCard(
                                "Total Amount\nDonated",
                                "$totalAmount ml",
                                "Top 20%",
                              ),
                              const SizedBox(width: 16),
                              _buildSummaryCard(
                                "Number of\nLives Saved",
                                "$livesSaved",
                                "Top 80%",
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No donations yet. Add one!',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
