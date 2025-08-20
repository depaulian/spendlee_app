import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/models/security_question.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/forget_password_phone/forget_password_phone.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';

class SecurityQuestionsScreen extends StatefulWidget {
  final String contactType;

  const SecurityQuestionsScreen({
    super.key,
    required this.contactType,
  });

  @override
  State<SecurityQuestionsScreen> createState() => _SecurityQuestionsScreenState();
}

class _SecurityQuestionsScreenState extends State<SecurityQuestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  SecurityQuestion? selectedQuestion1;
  SecurityQuestion? selectedQuestion2;
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();

  final List<SecurityQuestion> securityQuestions = [
    SecurityQuestion(id: 1, question: "What was the brand of your first motorcycle?"),
    SecurityQuestion(id: 2, question: "In which trading center/stage did you first operate as a boda boda?"),
    SecurityQuestion(id: 3, question: "What is the name of your first boda boda association/group?"),
    SecurityQuestion(id: 4, question: "Which primary school did you attend?"),
    SecurityQuestion(id: 5, question: "What is your village of birth?"),
    SecurityQuestion(id: 6, question: "What is your mother's first name?"),
    SecurityQuestion(id: 7, question: "What is the name of your local LC1 chairperson when you started riding?"),
    SecurityQuestion(id: 8, question: "What was your childhood nickname?"),
    SecurityQuestion(id: 9, question: "Which district were you born in?"),
    SecurityQuestion(id: 10, question: "What was your first job before becoming a boda boda rider?"),
    SecurityQuestion(id: 11, question: "What is the name of your favorite local market?"),
    SecurityQuestion(id: 12, question: "Who taught you how to ride a motorcycle?"),
    SecurityQuestion(id: 13, question: "What is the name of your first regular customer?"),
    SecurityQuestion(id: 14, question: "Which football team do you support in Uganda?"),
    SecurityQuestion(id: 15, question: "What is your stage name or rider nickname?"),
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final isDark = themeController.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark ? tBgDarkColor : tSecondaryColor,
      appBar: AppBar(
        title: const Text('Security Questions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please answer security questions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // First Question
                DropdownButtonFormField<SecurityQuestion>(
                  decoration: const InputDecoration(
                    labelText: 'Security Question 1',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  isExpanded: true, // This prevents overflow
                  value: selectedQuestion1,
                  items: securityQuestions
                      .map((q) => DropdownMenuItem(
                    value: q,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400), // Constrain width
                      child: Text(
                        q.question,
                        style: const TextStyle(fontSize: 12),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuestion1 = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a security question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // First Answer
                TextFormField(
                  controller: answer1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Answer 1',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your answer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Second Question
                DropdownButtonFormField<SecurityQuestion>(
                  decoration: const InputDecoration(
                    labelText: 'Security Question 2',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  isExpanded: true, // This prevents overflow
                  value: selectedQuestion2,
                  items: securityQuestions
                      .map((q) => DropdownMenuItem(
                    value: q,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400), // Constrain width
                      child: Text(
                        q.question,
                        style: const TextStyle(fontSize: 12),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuestion2 = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a security question';
                    }
                    if (value.id == selectedQuestion1?.id) {
                      return 'Please select a different question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Second Answer
                TextFormField(
                  controller: answer2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Answer 2',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your answer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final arguments = {
                          'contactType': widget.contactType,
                          'questionId1': selectedQuestion1?.id,
                          'question1': selectedQuestion1?.question,
                          'answer1': answer1Controller.text,
                          'questionId2': selectedQuestion2?.id,
                          'question2': selectedQuestion2?.question,
                          'answer2': answer2Controller.text,
                        };
                        if(widget.contactType=='email'){
                          Get.to(() => const ForgetPasswordMailScreen(), arguments: arguments);
                        }else{
                          Get.to(() => const ForgetPasswordPhoneScreen(), arguments: arguments);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Verify Answers',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    answer1Controller.dispose();
    answer2Controller.dispose();
    super.dispose();
  }
}