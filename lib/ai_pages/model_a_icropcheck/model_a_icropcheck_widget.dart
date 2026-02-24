import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model_a_icropcheck_model.dart';
export 'model_a_icropcheck_model.dart';

class ModelAIcropcheckWidget extends StatefulWidget {
  const ModelAIcropcheckWidget({super.key});

  static String routeName = 'modelAIcropcheck';
  static String routePath = '/modelAIcropcheck';

  @override
  State<ModelAIcropcheckWidget> createState() => _ModelAIcropcheckWidgetState();
}

class _ModelAIcropcheckWidgetState extends State<ModelAIcropcheckWidget> {
  late ModelAIcropcheckModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModelAIcropcheckModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'modelAIcropcheck'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ApisRecord>>(
      stream: queryApisRecord(
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ApisRecord> modelAIcropcheckApisRecordList = snapshot.data!;
        
        // DEBUG: Print API key info
        print('DEBUG: Number of API records found: ${modelAIcropcheckApisRecordList.length}');
        
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          print('DEBUG: No API records found in Firebase!');
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'API Configuration Missing',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No API keys found in Firebase Firestore.\n\nPlease add a document to the "apis" collection with field "cropmodelAPI"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final modelAIcropcheckApisRecord =
            modelAIcropcheckApisRecordList.isNotEmpty
                ? modelAIcropcheckApisRecordList.first
                : null;
        
        // DEBUG: Print the actual API key value
        print('DEBUG: API Key value: ${modelAIcropcheckApisRecord?.cropmodelAPI ?? "NULL"}');
        print('DEBUG: API Key length: ${modelAIcropcheckApisRecord?.cropmodelAPI.length ?? 0}');

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('MODEL_A_ICROPCHECK_arrow_back_rounded_IC');
                  logFirebaseEvent('IconButton_navigate_back');
                  context.pop();
                },
              ),
              title: Text(
                FFLocalizations.of(context).getText(
                  'c4mpnb5b' /* Your crop only doctor */,
                ),
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.85,
                    child: custom_widgets.AdvancedPlantScanner(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: MediaQuery.sizeOf(context).height * 0.85,
                      geminiApiKey: modelAIcropcheckApisRecord!.cropmodelAPI,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
