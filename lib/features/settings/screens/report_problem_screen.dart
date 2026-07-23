import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/premium_card.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  String _selectedCategory = 'Bug';
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<String> _categories = ['Bug', 'Feedback', 'Payment Issue', 'Other'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    // In a real app, send data to the backend.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Problem reported successfully.'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report a Problem'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.mdRadius,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.mdRadius,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                ),
                dropdownColor: AppColors.surface,
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSpacing.lg),
              CustomTextField(
                hintText: 'Briefly describe the issue',
                controller: _titleController,
              ),
              SizedBox(height: AppSpacing.lg),
              CustomTextField(
                hintText: 'Provide details...',
                controller: _descController,
                maxLines: 5,
              ),
              SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Submit',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
