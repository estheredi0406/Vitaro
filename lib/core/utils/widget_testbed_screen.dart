import 'package:flutter/material.dart';
import 'package:vitaro/shared_widgets/custom_button.dart';
import 'package:vitaro/shared_widgets/custom_text_field.dart';
// Import your new widgets here
import 'package:vitaro/shared_widgets/info_card.dart';
import 'package:vitaro/shared_widgets/screen_app_bar.dart';

class WidgetTestbedScreen extends StatelessWidget {
  const WidgetTestbedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy controllers for the text fields
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      // 3. Add your ScreenAppBar here
      appBar: const ScreenAppBar(
        title: 'Widget Testbed',
        showBackArrow: false, // Test it with and without the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'InfoCard Row',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              // 4. Add your InfoCards here
              const Row(
                children: [
                  InfoCard(title: 'Hemoglobin', value: '14.2', unit: 'g/dl'),
                  SizedBox(width: 12),
                  InfoCard(title: 'Blood Pressure', value: '120/80', unit: 'mmHg'),
                  SizedBox(width: 12),
                  InfoCard(title: 'Pulse', value: '72', unit: 'bpm'),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                'CustomButton',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              // 1. Add your CustomButton here
              CustomButton(
                text: 'Sign In',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Loading...',
                onPressed: () {},
                isLoading: true,
              ),

              const SizedBox(height: 24),
              Text(
                'CustomTextField',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              // 2. Add your CustomTextFields here
              CustomTextField(
                controller: emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}