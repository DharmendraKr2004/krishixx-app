import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'farmersconnect_model.dart';
export 'farmersconnect_model.dart';

class FarmersconnectWidget extends StatefulWidget {
  const FarmersconnectWidget({super.key, this.fromBottomNav = false});

  static String routeName = 'farmersconnect';
  static String routePath = '/farmersconnect';

  final bool fromBottomNav;

  @override
  State<FarmersconnectWidget> createState() => _FarmersconnectWidgetState();
}

class _FarmersconnectWidgetState extends State<FarmersconnectWidget> {
  late FarmersconnectModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FarmersconnectModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'farmersconnect'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        // Only show AppBar when NOT accessed from bottom navigation
        appBar: widget.fromBottomNav
            ? null
            : AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    logFirebaseEvent(
                        'FARMERSCONNECT_arrow_back_rounded_ICN_ON');
                    logFirebaseEvent('IconButton_navigate_back');
                    context.pop();
                  },
                ),
                title: Text(
                  FFLocalizations.of(context).getText(
                    'q80mcujh' /* connections */,
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
                        color: Colors.white,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                ),
                actions: [],
                centerTitle: false,
                elevation: 2.0,
              ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.construction,
                          size: 64,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Farmers Connect',
                          style: FlutterFlowTheme.of(context).headlineMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Feature temporarily under maintenance',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // TEMPORARILY DISABLED - FarmerNetworkWidget has compilation errors
                  // child: custom_widgets.FarmerNetworkWidget(
                  //   width: MediaQuery.sizeOf(context).width * 1.0,
                  //   height: MediaQuery.sizeOf(context).height * 1.0,
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
