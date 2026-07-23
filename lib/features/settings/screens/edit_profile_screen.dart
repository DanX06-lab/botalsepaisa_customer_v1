import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool _isSaving = false;
  bool _isAccountNoVisible = false;

  // Profile Info
  final _nameCtrl = TextEditingController(text: 'Rahul Kumar');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');
  final _emailCtrl = TextEditingController(text: 'rahul.kumar@email.com');
  final _dobCtrl = TextEditingController(text: '15 Aug 1995');
  String? _selectedGender = 'Male';

  // Address
  final _houseCtrl =
      TextEditingController(text: 'Flat 4B, Green Tower');
  final _streetCtrl = TextEditingController(text: 'MG Road');
  final _cityCtrl = TextEditingController(text: 'Bangalore');
  final _stateCtrl = TextEditingController(text: 'Karnataka');
  final _pinCtrl = TextEditingController(text: '560001');

  // Payment
  final _upiCtrl = TextEditingController(text: 'rahul@upi');
  String? _selectedUpiApp = 'Google Pay';
  final _accountHolderCtrl = TextEditingController(text: 'Rahul Kumar');
  final _bankNameCtrl =
      TextEditingController(text: 'State Bank of India');
  final _accountNoCtrl = TextEditingController(text: '12345678901234');
  final _ifscCtrl = TextEditingController(text: 'SBIN0001234');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    _houseCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pinCtrl.dispose();
    _upiCtrl.dispose();
    _accountHolderCtrl.dispose();
    _bankNameCtrl.dispose();
    _accountNoCtrl.dispose();
    _ifscCtrl.dispose();
    super.dispose();
  }

  // â”€â”€â”€ Validators â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String? _validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return null;
    final r = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    return r.hasMatch(v) ? null : 'Enter a valid email address';
  }

  String? _validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Phone is required';
    final clean = v.replaceAll(RegExp(r'[\s+\-()]'), '');
    return clean.length >= 10 ? null : 'Enter a valid phone number';
  }

  String? _validateUpi(String? v) {
    if (v == null || v.isEmpty) return null;
    return v.contains('@') ? null : 'Enter a valid UPI ID (e.g. name@upi)';
  }

  String? _validateIfsc(String? v) {
    if (v == null || v.isEmpty) return null;
    final r = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    return r.hasMatch(v.toUpperCase())
        ? null
        : 'Enter a valid IFSC code (e.g. SBIN0001234)';
  }

  // â”€â”€â”€ Image Picker â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text('Change Profile Photo',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.photo_library, color: AppColors.textPrimary),
                ),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.camera_alt, color: AppColors.textPrimary),
                ),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Permission permission = source == ImageSource.gallery
        ? Permission.photos
        : Permission.camera;
    final status = await permission.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission denied. Please allow in settings.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }
    final XFile? image = await _picker.pickImage(
        source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
    if (image != null && mounted) {
      setState(() => _profileImage = File(image.path));
    }
  }

  // â”€â”€â”€ Save Changes â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock API call
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // â”€â”€â”€ UI Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  // â”€â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _buildProfilePhotoSection(),
                  SizedBox(height: AppSpacing.xl),
                  _buildPersonalInfoSection(),
                  SizedBox(height: AppSpacing.xl),
                  _buildAddressSection(),
                  SizedBox(height: AppSpacing.xl),
                  _buildPaymentSection(),
                  SizedBox(height: AppSpacing.xl),
                  _buildStatsSection(),
                  SizedBox(height: AppSpacing.xl),
                  _buildDangerZoneSection(),
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
              child: PrimaryButton(
                text: 'Save Changes',
                icon: Icons.check,
                isLoading: _isSaving,
                onPressed: _saveChanges,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              boxShadow: AppShadows.primaryGlow,
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 57,
              backgroundColor: AppColors.surface,
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? Icon(Icons.person, size: 60, color: AppColors.primary)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImagePickerModal,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.textPrimary, width: 2),
                  boxShadow: AppShadows.soft,
                ),
                child: Icon(Icons.camera_alt,
                    color: AppColors.textPrimary, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Personal Information', Icons.person_outline),
          CustomTextField(
            controller: _nameCtrl,
            hintText: 'Full Name',
            prefixIcon: Icon(Icons.badge_outlined,
                color: AppColors.textSecondary),
            validator: _validateRequired,
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _phoneCtrl,
            hintText: 'Phone Number',
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(Icons.phone_outlined,
                color: AppColors.textSecondary),
            validator: _validatePhone,
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _emailCtrl,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined,
                color: AppColors.textSecondary),
            validator: _validateEmail,
          ),
          SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _dobCtrl,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Date of Birth (optional)',
              prefixIcon: Icon(Icons.calendar_today_outlined,
                  color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1995, 8, 15),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  final months = [
                    'Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'
                  ];
                  _dobCtrl.text =
                      '${picked.day} ${months[picked.month - 1]} ${picked.year}';
                });
              }
            },
          ),
          SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _selectedGender,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: 'Gender (optional)',
              prefixIcon: Icon(Icons.wc_outlined,
                  color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
            items: ['Male', 'Female', 'Prefer not to say']
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (v) => setState(() => _selectedGender = v),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Address', Icons.home_outlined),
          CustomTextField(
            controller: _houseCtrl,
            hintText: 'House / Flat Number',
            prefixIcon: Icon(Icons.apartment_outlined,
                color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _streetCtrl,
            hintText: 'Street / Area',
            prefixIcon: Icon(Icons.signpost_outlined,
                color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _cityCtrl,
                  hintText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined,
                      color: AppColors.textSecondary),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: CustomTextField(
                  controller: _stateCtrl,
                  hintText: 'State',
                  prefixIcon: Icon(Icons.map_outlined,
                      color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _pinCtrl,
            hintText: 'PIN Code',
            keyboardType: TextInputType.number,
            prefixIcon: Icon(Icons.pin_drop_outlined,
                color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.gps_fixed_outlined,
                  size: 14, color: AppColors.textSecondary.withValues(alpha: 0.6)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Auto-fill via GPS will be available in the next update.',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Payment Details', Icons.account_balance_outlined),

          // UPI
          CustomTextField(
            controller: _upiCtrl,
            hintText: 'UPI ID (e.g. name@upi)',
            prefixIcon: Icon(Icons.qr_code,
                color: AppColors.textSecondary),
            validator: _validateUpi,
          ),
          SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _selectedUpiApp,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: 'Preferred UPI App (optional)',
              prefixIcon: Icon(Icons.phone_android_outlined,
                  color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
            items: ['Google Pay', 'PhonePe', 'Paytm', 'BHIM', 'Other']
                .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                .toList(),
            onChanged: (v) => setState(() => _selectedUpiApp = v),
          ),

          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.border)),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Text('Bank Account Details',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          CustomTextField(
            controller: _accountHolderCtrl,
            hintText: 'Account Holder Name',
            prefixIcon: Icon(Icons.person_outline,
                color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _bankNameCtrl,
            hintText: 'Bank Name',
            prefixIcon: Icon(Icons.account_balance_outlined,
                color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),

          // Account Number with masking toggle
          TextFormField(
            controller: _accountNoCtrl,
            obscureText: !_isAccountNoVisible,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Account Number',
              prefixIcon: Icon(Icons.credit_card,
                  color: AppColors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  _isAccountNoVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _isAccountNoVisible = !_isAccountNoVisible),
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _ifscCtrl,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(11),
            ],
            validator: _validateIfsc,
            decoration: InputDecoration(
              hintText: 'IFSC Code',
              prefixIcon: Icon(Icons.code,
                  color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.lgRadius,
                borderSide:
                    BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStatsSection() {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Account Statistics', Icons.bar_chart),
          // 2Ã—2 grid
          Row(
            children: [
              Expanded(
                  child: _statTile('Bottles Recycled', '124')),
              Expanded(
                  child: _statTile('Lifetime Rewards', 'â‚¹1,250')),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                  child: _statTile('Wallet Balance', 'â‚¹450')),
              Expanded(
                  child: _statTile('Member Since', 'Jan 2024')),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.border),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.military_tech,
                  color: AppColors.accent, size: 28),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level 3 â€“ Eco Warrior',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                            fontSize: 15)),
                    Text('Next level at 200 bottles',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.xlRadius,
            child: LinearProgressIndicator(
              value: 0.62,
              backgroundColor: AppColors.border,
              color: AppColors.accent,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneSection() {
    return PremiumCard(
      padding: EdgeInsets.zero,
      hasShadow: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _sectionHeader('Danger Zone', Icons.warning_amber_outlined),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_forever, color: AppColors.error),
              ),
              title: Text('Delete Account',
                  style: TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.bold)),
              subtitle: Text('Permanently delete your account and data',
                  style: TextStyle(fontSize: 12)),
              trailing: Icon(Icons.chevron_right,
                  color: AppColors.textSecondary),
              onTap: () => context.push('/delete-account'),
            ),
          ],
        ),
      ),
    );
  }
}
