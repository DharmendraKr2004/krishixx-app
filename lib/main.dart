import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  try {
    print('Initializing Firebase...');
    await initFirebase();
    print('✓ Firebase initialized');

    print('Initializing Supabase...');
    await SupaFlow.initialize();
    print('✓ Supabase initialized');

    print('Initializing FlutterFlowTheme...');
    await FlutterFlowTheme.initialize();
    print('✓ FlutterFlowTheme initialized');

    print('Initializing FFLocalizations...');
    await FFLocalizations.initialize();
    print('✓ FFLocalizations initialized');

    print('Starting app...');
    runApp(MyApp());
  } catch (e, stackTrace) {
    print('❌ ERROR DURING INITIALIZATION: $e');
    print('Stack trace: $stackTrace');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 20),
                Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Error: $e',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = FFLocalizations.getStoredLocale();

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = krishiSakhi2SupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
    FFLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'krishi Sakhi 2',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ml'),
        Locale('hi'),
        Locale('ta'),
        Locale('te'),
        Locale('gu'),
        Locale('mr'),
        Locale('ja'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': HomePageWidget(),
      'farmersconnect': FarmersconnectWidget(fromBottomNav: true),
      'TreatmentGuide': TreatmentGuideWidget(),
      'chatpageAIassigstant': ChatpageAIassigstantWidget(),
      'Profile13Responsive': Profile13ResponsiveWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    final MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: MediaQuery(
          data: queryData
              .removeViewInsets(removeBottom: true)
              .removeViewPadding(removeBottom: true),
          child: _currentPage ?? tabs[_currentPageName]!),
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: Color(0xFF0C7B6D),
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        selectedBackgroundColor: Color(0x00000000),
        borderRadius: 14.0,
        itemBorderRadius: 8.0,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(4.0),
        width: double.infinity,
        elevation: 2.0,
        items: [
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.home,
                  color: currentIndex == 0
                      ? Color(0xFF0C7B6D)
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    '34f6q1ow' /* Home */,
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 0
                        ? Color(0xFF0C7B6D)
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.co_present,
                  color: currentIndex == 1
                      ? Color(0xFF0C7B6D)
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    'qc47ul3x' /* connect */,
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 1
                        ? Color(0xFF0C7B6D)
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.briefcaseMedical,
                  color: currentIndex == 2
                      ? Color(0xFF0C7B6D)
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 22.0,
                ),
                Text(
                  'Treatment',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 2
                        ? Color(0xFF0C7B6D)
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.robot,
                  color: currentIndex == 3
                      ? Color(0xFF0C7B6D)
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    'f540c3bu' /* Home */,
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 3
                        ? Color(0xFF0C7B6D)
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  currentIndex == 4 ? Icons.person : Icons.person_outline,
                  color: currentIndex == 4
                      ? Color(0xFF0C7B6D)
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: currentIndex == 4 ? 24.0 : 24.0,
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    'ebbqnh0u' /* profile */,
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 4
                        ? Color(0xFF0C7B6D)
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
