// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';

class PP_ToS extends StatelessWidget {
  const PP_ToS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSettings.backgroundColor,
      appBar: AppBar(
        title: Text("Privacy Policy and Terms of Service", style: TextStyle(color: Colors.white)),
        backgroundColor: themeSettings.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: themeSettings.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: themeSettings.secondaryColor,
                    indicatorColor: themeSettings.secondaryColor,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Text("Terms of Service"),
                      ),
                      Tab(
                        child: Text("Privacy Policy"),
                      )
                    ],
                  ),
                  Divider(),
                  Expanded(
                    // Constrain the TabBarView's height
                    child: TabBarView(
                      children: [
                        // Wrap notifications list in a scrollable view
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terms of Service',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: themeSettings.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Effective Date: 20/10/2024',
                                style: TextStyle(fontSize: 16, color: themeSettings.textColor),
                              ),
                              SizedBox(height: 20),
                              _buildSectionTitle(context, '1. Acceptance of Terms'),
                              _buildSectionContent(
                                  context, 'By using TailWaggr (“we,” “our,” or “us”), you agree to comply with these Terms of Service. If you do not agree to these terms, do not use our service.'),
                              _buildSectionTitle(context, '2. Use of Services'),
                              _buildSectionContent(context,
                                  '- Account Security: You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.'),
                              _buildSectionTitle(context, '3. Intellectual Property'),
                              _buildSectionContent(
                                  context,
                                  'All content, features, and functionality (such as text, images, video, and code) on the service are owned by us or our licensors and are protected by '
                                  'intellectual property laws. You may not reproduce, distribute, or create derivative works without our permission.'),
                              _buildSectionTitle(context, '4. User Content'),
                              _buildSectionContent(
                                  context,
                                  '- Ownership: You retain ownership of any content you submit, post, or display on or through the service.'
                                  '- License: By submitting content, you grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, and display your content '
                                  'for the purposes of operating and improving the service.'),
                              
                              _buildSectionTitle(context, '5. Prohibited Conduct'),
                              _buildSectionContent(
                                  context,
                                  'You may not:\n'
                                  '- Use the service for any illegal or unauthorized purpose.\n'
                                  '- Disrupt or interfere with the security of the service.\n'
                                  '- Upload viruses or malicious code.'),

                              _buildSectionTitle(context, '6. Limitation of Liability'),
                              _buildSectionContent(
                                  context,
                                  'We are not responsible for any indirect, incidental, special, or consequential damages that result from the use of or inability to use our services.'),

                              _buildSectionTitle(context, '7. Termination'),
                              _buildSectionContent(
                                  context,
                                  'We reserve the right to suspend or terminate your access to our service at any time, for any reason, without notice.'),

                              _buildSectionTitle(context, '8. Governing Law'),
                              _buildSectionContent(
                                  context,
                                  'These Terms of Service will be governed by and construed in accordance with the laws of South Africa, without regard to its conflict of law provisions.'),

                              _buildSectionTitle(context, '9. Changes to Terms'),
                              _buildSectionContent(
                                  context,
                                  'We may update these Terms of Service from time to time. If we make significant changes, we will notify you through the service or via email.'),

                              _buildSectionTitle(context, '10. Contact Us'),
                              _buildSectionContent(
                                  context,
                                  'If you have any questions or concerns about our Terms of Service, please contact us at argonauts004@gmail.com.'),
                            ],
                          ),
                        ),
                        // Second tab content
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Privacy Policy',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: themeSettings.textColor),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Effective Date: 20/10/2024',
                                style: TextStyle(fontSize: 16, color: themeSettings.textColor),
                              ),
                              SizedBox(height: 20),
                              _buildSectionTitle(context, '1. Introduction'),
                              _buildSectionContent(
                                  context,
                                  'Welcome to TailWaggr '
                                  '("we," "our," or "us"). We are committed to protecting your personal information '
                                  'and your right to privacy. This Privacy Policy explains what information we collect, '
                                  'how we use it, and your rights regarding your information.'),
                              _buildSectionTitle(context, '2. Information We Collect'),
                              _buildSectionContent(
                                  context,
                                  '- Personal Information: We may collect personal '
                                  'information such as your name, email address, phone number, and other information '
                                  'you provide directly to us.\n- Usage Data: We may collect information about your '
                                  'device, browsing actions, and usage patterns when you use our website or services, '
                                  'such as IP address, browser type, and pages you visit.\n- Cookies and Tracking '
                                  'Technologies: We may use cookies or similar tracking technologies to enhance your '
                                  'experience and analyze usage trends.'),
                              _buildSectionTitle(context, '3. How We Use Your Information'),
                              _buildSectionContent(
                                  context,
                                  'We use the information we collect for:\n'
                                  '- Providing and maintaining our services.\n'
                                  '- Personalizing user experience.\n'
                                  '- Communicating with you, including sending marketing materials, if you have opted in.\n'
                                  '- Analyzing usage trends to improve our services.'),
                              _buildSectionTitle(context, '4. Sharing Your Information We may share your information with:'),
                              _buildSectionContent(
                                  context,
                                  '- Service Providers: We may share your information with third-party providers that help us with operations like hosting, analytics, and marketing.\n'
                                  '- Legal Requirements: We may disclose your information when required by law or in response to legal proceedings. '),
                              _buildSectionTitle(context, '5. Data Security'),
                              _buildSectionContent(context, 'We implement industry-standard security measures to protect your information from unauthorized access, alteration, or disclosure.'),
                              _buildSectionTitle(context, '6. Your Rights'),
                              _buildSectionContent(
                                  context,
                                  'You have the right to:\n'
                                  '- Access, update, or delete your information.\n'
                                  '- Object to the processing of your information.\n'
                                  '- Opt-out of marketing communications.\n'
                                  '- Request a copy of your information.'),
                              _buildSectionTitle(context, '7. Changes to This Policy'),
                              _buildSectionContent(context, 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.'),
                              _buildSectionTitle(context, '8. Contact Us'),
                              _buildSectionContent(context, 'If you have any questions or concerns about our Privacy Policy, please contact us at argonauts004@gmail.com'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to build section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeSettings.textColor),
      ),
    );
  }

  // Function to build section content
  Widget _buildSectionContent(BuildContext context, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16, color: themeSettings.textColor),
      ),
    );
  }
}
