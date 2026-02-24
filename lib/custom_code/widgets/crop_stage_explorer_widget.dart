// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class CropStageExplorerWidget extends StatefulWidget {
  const CropStageExplorerWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CropStageExplorerWidgetState createState() =>
      _CropStageExplorerWidgetState();
}

class _CropStageExplorerWidgetState extends State<CropStageExplorerWidget> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<CropdataRow> _allCropData = [];
  List<String> _cropNames = [];
  String? _selectedCrop;
  List<CropdataRow> _selectedCropStages = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCropData();
  }

  Future<void> _loadCropData() async {
    print('🔄 _loadCropData called, setting loading to true');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🌾 Loading crop data from Supabase...');
      // print('🔗 Supabase URL: ${_supabase.supabaseUrl}'); // Property not available in Supabase 2.7

      final data = await _supabase
          .from('cropdata')
          .select()
          .timeout(Duration(seconds: 10));

      print('✅ Raw data received');
      print('📊 Data type: ${data.runtimeType}');
      print('📊 Data: $data');

      if (data == null || (data is List && data.isEmpty)) {
        print('⚠️ No data returned from database');
        setState(() {
          _isLoading = false;
          _allCropData = [];
          _cropNames = [];
          _errorMessage =
              'No crop data found in database. Please add crops using SQL.';
        });
        return;
      }

      final List<dynamic> dataList = data is List ? data : [data];
      print('📝 Processing ${dataList.length} records...');

      final List<CropdataRow> cropDataList = dataList
          .map((json) {
            try {
              return CropdataRow(json as Map<String, dynamic>);
            } catch (e) {
              print('⚠️ Error parsing row: $json - Error: $e');
              return null;
            }
          })
          .whereType<CropdataRow>()
          .toList();

      print('✅ Parsed ${cropDataList.length} crop data rows');

      // Extract unique crop names
      final Set<String> uniqueCrops = {};
      for (var cropData in cropDataList) {
        if (cropData.crop != null && cropData.crop!.isNotEmpty) {
          uniqueCrops.add(cropData.crop!);
          print('  - Found crop: ${cropData.crop}');
        }
      }

      final List<String> sortedCropNames = uniqueCrops.toList()..sort();
      print('📋 Unique crops (${sortedCropNames.length}): $sortedCropNames');

      setState(() {
        _allCropData = cropDataList;
        _cropNames = sortedCropNames;
        _isLoading = false;
        _errorMessage = null;
      });

      print(
          '✅ State updated - isLoading: $_isLoading, crops: ${_cropNames.length}');
    } catch (e, stackTrace) {
      print('❌ Error loading crop data: $e');
      print('📍 Stack trace: $stackTrace');

      setState(() {
        _isLoading = false;
        _allCropData = [];
        _cropNames = [];
        _errorMessage = 'Database error: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 6),
          ),
        );
      }
    }
  }

  void _onCropSelected(String? cropName) {
    if (cropName == null) return;

    setState(() {
      _selectedCrop = cropName;
      _selectedCropStages = _allCropData
          .where((data) => data.crop == cropName)
          .toList()
        ..sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    });

    print(
        '🎯 Selected crop: $cropName with ${_selectedCropStages.length} stages');
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🏗️ Building CropStageExplorerWidget - isLoading: $_isLoading, cropNames: ${_cropNames.length}, error: $_errorMessage');

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading crops...',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check browser console (F12) for details',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? _buildErrorState()
              : _cropNames.isEmpty
                  ? _buildNoCropsState()
                  : _buildContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Error Loading Data',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Outfit',
                    color: Colors.red,
                  ),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Unknown error',
              style: FlutterFlowTheme.of(context).bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCropData,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCropsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: 16),
            Text(
              'No Crops Found',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            SizedBox(height: 12),
            Text(
              'The cropdata table is empty.\nPlease add crop data through Supabase.',
              style: FlutterFlowTheme.of(context).bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCropData,
              icon: Icon(Icons.refresh),
              label: Text('Reload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        _buildCropDropdown(),
        Expanded(
          child:
              _selectedCrop == null ? _buildEmptyState() : _buildStagesList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crop Stage Explorer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Explore crop stages and cultivation practices',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCropDropdown() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCrop,
          hint: Row(
            children: [
              Icon(Icons.search, color: FlutterFlowTheme.of(context).primary),
              SizedBox(width: 12),
              Text(
                'Select a Crop',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
          icon: Icon(Icons.keyboard_arrow_down,
              color: FlutterFlowTheme.of(context).primary),
          items: _cropNames.map((String cropName) {
            return DropdownMenuItem<String>(
              value: cropName,
              child: Row(
                children: [
                  Icon(Icons.agriculture,
                      color: FlutterFlowTheme.of(context).primary, size: 20),
                  SizedBox(width: 12),
                  Text(
                    cropName,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: _onCropSelected,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.agriculture_outlined,
            size: 80,
            color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'Select a crop to explore',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'View cultivation stages, practices, and subsidies',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStagesList() {
    if (_selectedCropStages.isEmpty) {
      return Center(
        child: Text(
          'No stage data available for this crop',
          style: FlutterFlowTheme.of(context).bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _selectedCropStages.length,
      itemBuilder: (context, index) {
        final stage = _selectedCropStages[index];
        return _buildStageCard(stage, index);
      },
    );
  }

  Widget _buildStageCard(CropdataRow stage, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              FlutterFlowTheme.of(context).primary.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with stage number
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      stage.stage ?? 'Stage ${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stage.timing != null && stage.timing!.isNotEmpty) ...[
                    _buildInfoRow(
                      Icons.schedule,
                      'Timing',
                      stage.timing!,
                      Colors.orange,
                    ),
                    SizedBox(height: 12),
                  ],
                  if (stage.practice != null && stage.practice!.isNotEmpty) ...[
                    _buildInfoRow(
                      Icons.spa,
                      'Practice',
                      stage.practice!,
                      Colors.green,
                    ),
                    SizedBox(height: 12),
                  ],
                  if (stage.notes != null && stage.notes!.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on,
                              color: Colors.amber[700], size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Subsidy Available',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[900],
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  stage.notes!,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
