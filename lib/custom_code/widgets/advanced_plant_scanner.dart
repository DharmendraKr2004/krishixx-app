// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ADD THESE DEPENDENCIES to your pubspec.yaml file:
//   image_picker: ^1.0.7
//   http: ^1.2.1
//   mime: ^1.0.4

import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class AdvancedPlantScanner extends StatefulWidget {
  const AdvancedPlantScanner({
    Key? key,
    this.width,
    this.height,
    required this.geminiApiKey,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String geminiApiKey;

  @override
  _AdvancedPlantScannerState createState() => _AdvancedPlantScannerState();
}

class _AdvancedPlantScannerState extends State<AdvancedPlantScanner>
    with TickerProviderStateMixin {
  XFile? _imageFile;
  Uint8List? _imageBytes;
  bool _isScanning = false;
  bool _showResults = false;

  // Analysis Results
  String? _cropName;
  String? _disease;
  String? _diseaseDescription;
  double? _confidencePercentage;
  String? _severity;
  List<String>? _symptoms;
  List<String>? _causes;
  List<String>? _treatments;
  List<String>? _preventiveMeasures;

  final ImagePicker _picker = ImagePicker();
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
        ),
      ),
      child: _showResults ? _buildResultsDashboard() : _buildScannerView(),
    );
  }

  // ==================== SCANNER VIEW ====================
  Widget _buildScannerView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildScannerHeader(),
          SizedBox(height: 20),
          _buildCameraSection(),
          if (_isScanning) _buildScanningAnimation(),
        ],
      ),
    );
  }

  Widget _buildScannerHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.camera_enhance,
              size: 48,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '🌱 AI Plant Disease Scanner',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Real-time camera scanning with AI',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraSection() {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            _buildImagePreviewSection(),
            _buildCameraControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviewSection() {
    if (_imageBytes != null) {
      return Container(
        height: 400,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
            ),
            // Scanning grid overlay
            if (_isScanning)
              CustomPaint(
                painter: ScanGridPainter(_scanAnimation.value),
              ),
          ],
        ),
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF1F8E9), Color(0xFFDCEDC8)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 80,
            color: Color(0xFF4CAF50),
          ),
          SizedBox(height: 20),
          Text(
            'Ready to Scan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Tap button below to open camera and scan your plant. Analysis starts automatically!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraControls() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // CAMERA SCAN BUTTON - Full Width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _isScanning ? null : () => _captureImage(ImageSource.camera),
              icon: Icon(
                  _isScanning ? Icons.hourglass_empty : Icons.camera_enhance,
                  size: 28),
              label: Text(
                _isScanning ? 'Scanning Plant...' : 'Scan Plant with Camera',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isScanning ? Colors.grey : Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),
          if (_imageBytes != null) ...[
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _startAnalysis,
                icon: Icon(Icons.refresh, size: 24),
                label: Text(
                  _isScanning ? 'Analyzing...' : 'Re-Scan Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA000),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              ),
              Icon(
                Icons.blur_on,
                size: 40,
                color: Color(0xFF4CAF50),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'AI Analysis in Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(height: 12),
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              int step = (_scanAnimation.value * 3).floor();
              List<String> steps = [
                '🌿 Identifying crop type...',
                '🔍 Detecting diseases...',
                '💊 Preparing treatment plan...',
              ];
              return Text(
                steps[step.clamp(0, 2)],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==================== RESULTS DASHBOARD ====================
  Widget _buildResultsDashboard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F9F5), Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDashboardHeader(),
            _buildImageSummaryCard(),
            _buildConfidenceCard(),
            _buildCropIdentificationCard(),
            _buildDiseaseInfoCard(),
            _buildSymptomsCard(),
            _buildCausesCard(),
            _buildTreatmentCard(),
            _buildPreventionCard(),
            _buildActionButtons(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _resetScanner,
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  '📊 Analysis Results',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Complete diagnostic report',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSummaryCard() {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: _imageBytes != null
                  ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[300]),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat(
                    icon: Icons.check_circle,
                    label: 'Scanned',
                    value: DateTime.now().toString().split('.')[0],
                    color: Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildConfidenceCard() {
    final percentage = _confidencePercentage ?? 0.0;
    Color confidenceColor = percentage >= 80
        ? Color(0xFF4CAF50)
        : percentage >= 60
            ? Color(0xFFFFA000)
            : Color(0xFFE53935);

    return _buildDashboardCard(
      title: 'Confidence Score',
      icon: Icons.analytics,
      iconColor: confidenceColor,
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(confidenceColor),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: confidenceColor,
                    ),
                  ),
                  Text(
                    percentage >= 80
                        ? 'High Confidence'
                        : percentage >= 60
                            ? 'Medium Confidence'
                            : 'Low Confidence',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: confidenceColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: confidenceColor, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    percentage >= 80
                        ? 'Very reliable results. Safe to proceed with recommendations.'
                        : percentage >= 60
                            ? 'Moderately reliable. Consider additional verification.'
                            : 'Low reliability. Recommend expert consultation.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropIdentificationCard() {
    return _buildDashboardCard(
      title: 'Crop Identification',
      icon: Icons.grass,
      iconColor: Color(0xFF4CAF50),
      child: Column(
        children: [
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF4CAF50), width: 2),
            ),
            child: Column(
              children: [
                Icon(Icons.eco, size: 48, color: Color(0xFF2E7D32)),
                SizedBox(height: 12),
                Text(
                  _cropName ?? 'Identifying...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Detected Plant Species',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseInfoCard() {
    Color severityColor = _severity == 'High'
        ? Color(0xFFE53935)
        : _severity == 'Medium'
            ? Color(0xFFFFA000)
            : Color(0xFF4CAF50);

    return _buildDashboardCard(
      title: 'Disease Detection',
      icon: Icons.bug_report,
      iconColor: severityColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: severityColor, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: severityColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _disease ?? 'No disease detected',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: severityColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Severity: ${_severity ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_diseaseDescription != null) ...[
            SizedBox(height: 16),
            Text(
              'About this Disease:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              _diseaseDescription!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomsCard() {
    if (_symptoms == null || _symptoms!.isEmpty) return SizedBox.shrink();

    return _buildDashboardCard(
      title: 'Symptoms Detected',
      icon: Icons.visibility,
      iconColor: Color(0xFF1976D2),
      child: Column(
        children: [
          SizedBox(height: 12),
          ..._symptoms!.asMap().entries.map((entry) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF1976D2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCausesCard() {
    if (_causes == null || _causes!.isEmpty) return SizedBox.shrink();

    return _buildDashboardCard(
      title: 'Causes & Risk Factors',
      icon: Icons.science,
      iconColor: Color(0xFFFF6F00),
      child: Column(
        children: [
          SizedBox(height: 12),
          ..._causes!.map((cause) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_right, color: Color(0xFFFF6F00), size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cause,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard() {
    if (_treatments == null || _treatments!.isEmpty) return SizedBox.shrink();

    return _buildDashboardCard(
      title: '💊 Treatment Plan',
      icon: Icons.medical_services,
      iconColor: Color(0xFFE91E63),
      child: Column(
        children: [
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE91E63), width: 2),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFE91E63)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Follow these steps in order for best results',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ..._treatments!.asMap().entries.map((entry) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE91E63).withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPreventionCard() {
    if (_preventiveMeasures == null || _preventiveMeasures!.isEmpty)
      return SizedBox.shrink();

    return _buildDashboardCard(
      title: '🛡️ Prevention Tips',
      icon: Icons.shield,
      iconColor: Color(0xFF7B1FA2),
      child: Column(
        children: [
          SizedBox(height: 12),
          ..._preventiveMeasures!.map((measure) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF7B1FA2), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      measure,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _resetScanner,
              icon: Icon(Icons.camera_alt, size: 24),
              label: Text(
                'Scan Another Plant',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Share functionality
                    _showInfo('Share feature coming soon!');
                  },
                  icon: Icon(Icons.share, size: 20),
                  label: Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Save functionality
                    _showInfo('Save feature coming soon!');
                  },
                  icon: Icon(Icons.bookmark, size: 20),
                  label: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }

  // ==================== FUNCTIONALITY ====================

  Future<void> _captureImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _imageBytes = bytes;
          _showResults = false;
        });

        // Show success message
        _showInfo('Image captured! Tap "Start AI Analysis" to scan.');

        // Auto-start analysis after image capture
        await Future.delayed(Duration(milliseconds: 500));
        _startAnalysis();
      }
    } catch (e) {
      _showError('Failed to capture image: $e');
    }
  }

  Future<void> _startAnalysis() async {
    // DEBUG: Print API key info at analysis start
    print('\n========== ADVANCED PLANT SCANNER DEBUG ==========');
    print('API Key received: ${widget.geminiApiKey}');
    print('API Key length: ${widget.geminiApiKey.length}');
    print('API Key is empty: ${widget.geminiApiKey.isEmpty}');
    print('Image bytes null: ${_imageBytes == null}');
    print('Image bytes length: ${_imageBytes?.length ?? 0}');
    print('==================================================\n');
    
    // Detailed validation
    if (_imageBytes == null) {
      _showError('❌ No image captured. Please take a photo first.');
      print('ERROR: No image bytes available');
      return;
    }
    
    if (widget.geminiApiKey.isEmpty) {
      _showError('❌ API Key missing. Please configure Gemini API in settings.');
      print('ERROR: API key is empty!');
      return;
    }
    
    _showInfo('🔍 Analyzing plant... This may take 5-10 seconds.');
    print('✓ Validation passed, starting API call...');
    setState(() {
      _isScanning = true;
    });

    _scanAnimationController.repeat();

    try {
      String base64Image = base64Encode(_imageBytes!);
      final mimeType =
          lookupMimeType(_imageFile!.path, headerBytes: _imageBytes) ??
              'image/jpeg';

      // Use gemini-1.5-flash-latest (most stable for vision tasks)
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${widget.geminiApiKey}');

      final prompt = '''
You are an expert agricultural AI system. Analyze this plant image and provide a COMPLETE diagnostic report in JSON format.

Your response MUST be a valid JSON object with these exact fields:
{
  "crop_name": "Exact name of the crop/plant species",
  "disease": "Name of disease or 'Healthy' if no disease detected",
  "disease_description": "Detailed description of the disease (2-3 sentences)",
  "confidence_percentage": 85.5,
  "severity": "Low/Medium/High",
  "symptoms": ["Symptom 1", "Symptom 2", "Symptom 3"],
  "causes": ["Cause 1", "Cause 2", "Cause 3"],
  "treatments": ["Treatment step 1", "Treatment step 2", "Treatment step 3", "Treatment step 4"],
  "preventive_measures": ["Prevention tip 1", "Prevention tip 2", "Prevention tip 3"]
}

CRITICAL RULES:
1. confidence_percentage must be a number between 0-100
2. Include AT LEAST 3 symptoms, 3 causes, 4 treatments, and 3 preventive measures
3. Be specific and actionable in all recommendations
4. Use proper agricultural terminology
5. Return ONLY the JSON object, no markdown, no explanations

Analyze thoroughly and provide professional-grade results.
''';

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image}
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 2048,
        }
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('✅ API Response received');
        print('Response: ${response.body}');

        if (responseBody['candidates'] != null &&
            responseBody['candidates'].isNotEmpty) {
          final content =
              responseBody['candidates'][0]['content']['parts'][0]['text'];
          print('📝 AI Content: $content');

          final result = _parseAdvancedResponse(content);

          setState(() {
            _cropName = result['crop_name'];
            _disease = result['disease'];
            _diseaseDescription = result['disease_description'];
            _confidencePercentage = result['confidence_percentage'];
            _severity = result['severity'];
            _symptoms = result['symptoms'];
            _causes = result['causes'];
            _treatments = result['treatments'];
            _preventiveMeasures = result['preventive_measures'];
            _showResults = true;
          });

          _showInfo('✅ Analysis complete!');
        } else {
          _showError('❌ No response from AI. Please try again.');
        }
      } else {
        print('❌ API Error ${response.statusCode}: ${response.body}');
        _showError(
            'API Error ${response.statusCode}: ${response.body}. Check your API key.');
      }
    } catch (e) {
      _showError('Analysis failed: $e');
    } finally {
      setState(() {
        _isScanning = false;
      });
      _scanAnimationController.stop();
    }
  }

  Map<String, dynamic> _parseAdvancedResponse(String content) {
    try {
      // Clean response
      String cleaned = content.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7);
      }
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }
      cleaned = cleaned.trim();

      final parsed = jsonDecode(cleaned);

      return {
        'crop_name': parsed['crop_name'] ?? 'Unknown Plant',
        'disease': parsed['disease'] ?? 'Unknown Disease',
        'disease_description':
            parsed['disease_description'] ?? 'No description available',
        'confidence_percentage':
            (parsed['confidence_percentage'] ?? 75.0).toDouble(),
        'severity': parsed['severity'] ?? 'Medium',
        'symptoms': List<String>.from(parsed['symptoms'] ?? []),
        'causes': List<String>.from(parsed['causes'] ?? []),
        'treatments': List<String>.from(parsed['treatments'] ?? []),
        'preventive_measures':
            List<String>.from(parsed['preventive_measures'] ?? []),
      };
    } catch (e) {
      print('Parsing error: $e');
      return {
        'crop_name': 'Unknown Plant',
        'disease': 'Analysis Incomplete',
        'disease_description':
            'Unable to complete full analysis. Please try again.',
        'confidence_percentage': 50.0,
        'severity': 'Unknown',
        'symptoms': ['Unable to detect symptoms'],
        'causes': ['Analysis incomplete'],
        'treatments': ['Please rescan the plant for better results'],
        'preventive_measures': ['Consult an agricultural expert'],
      };
    }
  }

  void _resetScanner() {
    setState(() {
      _imageFile = null;
      _imageBytes = null;
      _isScanning = false;
      _showResults = false;
      _cropName = null;
      _disease = null;
      _diseaseDescription = null;
      _confidencePercentage = null;
      _severity = null;
      _symptoms = null;
      _causes = null;
      _treatments = null;
      _preventiveMeasures = null;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Custom Painter for scanning grid animation
class ScanGridPainter extends CustomPainter {
  final double progress;

  ScanGridPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Animate scanning line from top to bottom
    final lineY = size.height * progress;
    canvas.drawLine(
      Offset(0, lineY),
      Offset(size.width, lineY),
      paint..strokeWidth = 3,
    );

    // Grid overlay
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width * i / 4, 0),
        Offset(size.width * i / 4, size.height),
        paint
          ..strokeWidth = 1
          ..color = Colors.green.withOpacity(0.3),
      );
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        paint
          ..strokeWidth = 1
          ..color = Colors.green.withOpacity(0.3),
      );
    }
  }

  @override
  bool shouldRepaint(ScanGridPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
