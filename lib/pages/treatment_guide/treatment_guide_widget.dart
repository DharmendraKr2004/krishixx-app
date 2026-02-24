import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'treatment_guide_model.dart';
export 'treatment_guide_model.dart';

class TreatmentGuideWidget extends StatefulWidget {
  const TreatmentGuideWidget({super.key});

  static String routeName = 'TreatmentGuide';
  static String routePath = '/treatmentGuide';

  @override
  State<TreatmentGuideWidget> createState() => _TreatmentGuideWidgetState();
}

class _TreatmentGuideWidgetState extends State<TreatmentGuideWidget> {
  late TreatmentGuideModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Crop disease/issue database with treatment recommendations
  final Map<String, Map<String, dynamic>> treatmentDatabase = {
    'Leaf Spot Disease': {
      'description': 'Brown or black spots on leaves, often with yellow halos',
      'homeRemedies': [
        'Remove and destroy infected leaves immediately',
        'Apply neem oil spray (2-3 tablespoons per gallon)',
        'Improve air circulation between plants',
        'Water at base, avoid wetting foliage',
      ],
      'medicines': [
        'Mancozeb 75% WP - ₹350-500',
        'Copper Oxychloride 50% WP - ₹250-400',
        'Chlorothalonil 75% WP - ₹450-650',
      ],
      'buyLinks': [
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {
          'name': 'Amazon Agri',
          'url': 'https://www.amazon.in/b?node=3704982031'
        },
      ],
    },
    'Powdery Mildew': {
      'description': 'White powdery coating on leaves and stems',
      'homeRemedies': [
        'Mix 1 tablespoon baking soda + 1 tablespoon vegetable oil in 1 gallon water, spray weekly',
        'Milk spray: Mix 40% milk with 60% water',
        'Prune infected areas',
        'Ensure proper spacing for air flow',
      ],
      'medicines': [
        'Sulfur 80% WP - ₹300-450',
        'Hexaconazole 5% SC - ₹400-600',
        'Propiconazole 25% EC - ₹500-750',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
      ],
    },
    'Root Rot': {
      'description': 'Yellowing leaves, wilting, mushy brown roots',
      'homeRemedies': [
        'Improve drainage immediately',
        'Reduce watering frequency',
        'Add compost to improve soil structure',
        'Apply cinnamon powder to soil surface (natural fungicide)',
      ],
      'medicines': [
        'Metalaxyl 35% WS - ₹550-800',
        'Carbendazim 50% WP - ₹300-500',
        'Trichoderma viride (Bio-fungicide) - ₹200-350',
      ],
      'buyLinks': [
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Seedsandmore', 'url': 'https://seedsandmore.com/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
      ],
    },
    'Aphid Infestation': {
      'description': 'Tiny green/black insects clustering on new growth',
      'homeRemedies': [
        'Spray strong water jet to dislodge aphids',
        'Neem oil spray: 2% solution',
        'Soap spray: 2 tablespoons dish soap per gallon water',
        'Introduce ladybugs (natural predators)',
      ],
      'medicines': [
        'Imidacloprid 17.8% SL - ₹400-600',
        'Acetamiprid 20% SP - ₹350-550',
        'Thiamethoxam 25% WG - ₹450-700',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Agrikheti', 'url': 'https://www.agrikheti.com/'},
        {
          'name': 'Amazon Agri',
          'url': 'https://www.amazon.in/b?node=3704982031'
        },
      ],
    },
    'Whitefly Attack': {
      'description': 'Tiny white flying insects on leaf undersides',
      'homeRemedies': [
        'Yellow sticky traps',
        'Neem oil spray (weekly application)',
        'Garlic spray: Blend 2 cloves with water, strain and spray',
        'Vacuum whiteflies off plants gently',
      ],
      'medicines': [
        'Spiromesifen 22.9% SC - ₹600-900',
        'Diafenthiuron 50% WP - ₹400-650',
        'Pyriproxyfen 10% EC - ₹500-750',
      ],
      'buyLinks': [
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
      ],
    },
    'Bacterial Wilt': {
      'description': 'Sudden wilting, yellowing, plant collapse',
      'homeRemedies': [
        'Remove and destroy infected plants immediately',
        'Rotate crops - don\'t plant same family for 3-4 years',
        'Sterilize tools with bleach solution',
        'Use resistant varieties',
      ],
      'medicines': [
        'Streptocycline 9% + Tetracycline 1% - ₹450-650',
        'Copper Hydroxide 77% WP - ₹350-550',
        'Pseudomonas fluorescens (Bio-control) - ₹250-400',
      ],
      'buyLinks': [
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Seedsandmore', 'url': 'https://seedsandmore.com/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
      ],
    },
    'Caterpillar Damage': {
      'description': 'Chewed leaves, visible caterpillars, droppings',
      'homeRemedies': [
        'Hand-pick caterpillars early morning',
        'Bacillus thuringiensis (Bt) spray (organic)',
        'Garlic-chili spray',
        'Plant marigolds as companion plants',
      ],
      'medicines': [
        'Chlorantraniliprole 18.5% SC - ₹700-1000',
        'Emamectin Benzoate 5% SG - ₹500-800',
        'Spinosad 45% SC (organic) - ₹600-900',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
        {
          'name': 'Amazon Agri',
          'url': 'https://www.amazon.in/b?node=3704982031'
        },
      ],
    },
    'Fruit Borer': {
      'description': 'Holes in fruits, larvae inside fruits',
      'homeRemedies': [
        'Install pheromone traps',
        'Remove and destroy infested fruits',
        'Till soil after harvest to expose pupae',
        'Use bird netting',
      ],
      'medicines': [
        'Flubendiamide 20% WG - ₹800-1200',
        'Indoxacarb 14.5% SC - ₹600-900',
        'Spinosad 45% SC - ₹600-900',
      ],
      'buyLinks': [
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Agrikheti', 'url': 'https://www.agrikheti.com/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
      ],
    },
    'Nitrogen Deficiency': {
      'description': 'Pale yellow leaves, stunted growth, weak stems',
      'homeRemedies': [
        'Add compost or well-rotted manure',
        'Plant legumes (nitrogen-fixing plants)',
        'Apply coffee grounds to soil',
        'Mulch with grass clippings',
      ],
      'medicines': [
        'Urea 46% N - ₹300-400 per 50kg',
        'Ammonium Sulfate 21% N - ₹350-500 per 50kg',
        'NPK 20:20:20 - ₹450-650 per kg',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {'name': 'Iffco Bazar', 'url': 'https://www.iffcobazar.in/'},
      ],
    },
    'Iron Deficiency (Chlorosis)': {
      'description': 'Yellow leaves with green veins, new growth affected',
      'homeRemedies': [
        'Lower soil pH with sulfur or vinegar solution',
        'Add iron-rich compost',
        'Avoid overwatering',
        'Mulch with acidic materials (pine needles)',
      ],
      'medicines': [
        'Ferrous Sulfate - ₹150-250 per kg',
        'Iron Chelate (EDTA) - ₹400-600 per kg',
        'Micronutrient Mix - ₹300-500 per kg',
      ],
      'buyLinks': [
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Seedsandmore', 'url': 'https://seedsandmore.com/'},
      ],
    },
    'Blossom End Rot': {
      'description':
          'Dark, sunken spots on bottom of fruits (tomatoes, peppers)',
      'homeRemedies': [
        'Maintain consistent soil moisture',
        'Add crushed eggshells to soil (calcium)',
        'Mulch heavily to retain moisture',
        'Avoid over-fertilizing with nitrogen',
      ],
      'medicines': [
        'Calcium Chloride - ₹200-350 per kg',
        'Calcium Nitrate - ₹300-450 per kg',
        'Cal-Mag supplement - ₹400-600 per liter',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
      ],
    },
    'Spider Mites': {
      'description': 'Fine webbing on plants, stippled yellow leaves',
      'homeRemedies': [
        'Spray plants with strong water jet',
        'Neem oil spray 2% solution',
        'Introduce predatory mites',
        'Increase humidity around plants',
      ],
      'medicines': [
        'Propargite 57% EC - ₹500-750',
        'Spiromesifen 22.9% SC - ₹600-900',
        'Fenpyroximate 5% EC - ₹450-700',
      ],
      'buyLinks': [
        {'name': 'Agrikheti', 'url': 'https://www.agrikheti.com/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
      ],
    },
    'Thrips Damage': {
      'description': 'Silver streaks on leaves, distorted growth',
      'homeRemedies': [
        'Blue sticky traps',
        'Neem oil spray',
        'Remove weeds around crops',
        'Spray with soap solution',
      ],
      'medicines': [
        'Fipronil 5% SC - ₹400-600',
        'Dimethoate 30% EC - ₹300-500',
        'Spinosad 45% SC - ₹600-900',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {
          'name': 'Amazon Agri',
          'url': 'https://www.amazon.in/b?node=3704982031'
        },
      ],
    },
    'Mosaic Virus': {
      'description': 'Mottled yellow-green patterns on leaves',
      'homeRemedies': [
        'Remove infected plants immediately',
        'Control aphids (virus vectors)',
        'Disinfect tools between plants',
        'Use resistant varieties',
      ],
      'medicines': [
        'No direct cure - focus on aphid control',
        'Imidacloprid for aphids - ₹400-600',
        'Neem oil spray',
      ],
      'buyLinks': [
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Seedsandmore', 'url': 'https://seedsandmore.com/'},
      ],
    },
    'Damping Off': {
      'description': 'Seedlings collapse at soil line, stem rot',
      'homeRemedies': [
        'Use sterilized seed starting mix',
        'Avoid overwatering seedlings',
        'Provide good air circulation',
        'Apply cinnamon powder to soil',
      ],
      'medicines': [
        'Captan 75% WP - ₹300-500',
        'Thiram 75% WS - ₹250-400',
        'Trichoderma viride - ₹200-350',
      ],
      'buyLinks': [
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
      ],
    },
    'Rust Disease': {
      'description': 'Orange-brown pustules on leaf undersides',
      'homeRemedies': [
        'Remove infected leaves',
        'Improve air circulation',
        'Avoid overhead watering',
        'Apply sulfur spray',
      ],
      'medicines': [
        'Propiconazole 25% EC - ₹500-750',
        'Mancozeb 75% WP - ₹350-500',
        'Sulfur 80% WP - ₹300-450',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Agrikheti', 'url': 'https://www.agrikheti.com/'},
      ],
    },
    'Fungus Gnats': {
      'description': 'Small flying insects around soil, larvae in soil',
      'homeRemedies': [
        'Let soil dry between waterings',
        'Yellow sticky traps',
        'Add sand layer on top of soil',
        'Hydrogen peroxide soil drench (1:4 with water)',
      ],
      'medicines': [
        'Mosquito Bits (Bacillus thuringiensis) - ₹350-500',
        'Neem cake powder - ₹150-300 per kg',
        'Diatomaceous earth - ₹200-400 per kg',
      ],
      'buyLinks': [
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {
          'name': 'Amazon Agri',
          'url': 'https://www.amazon.in/b?node=3704982031'
        },
      ],
    },
    'Mealybugs': {
      'description': 'White cottony masses on stems and leaf joints',
      'homeRemedies': [
        'Remove with cotton swab dipped in rubbing alcohol',
        'Neem oil spray',
        'Soap spray (2 tbsp per gallon)',
        'Introduce lacewings (natural predators)',
      ],
      'medicines': [
        'Buprofezin 25% SC - ₹500-750',
        'Imidacloprid 17.8% SL - ₹400-600',
        'Spiromesifen 22.9% SC - ₹600-900',
      ],
      'buyLinks': [
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
      ],
    },
    'Scale Insects': {
      'description': 'Brown/white bumps on stems and leaves',
      'homeRemedies': [
        'Scrape off manually',
        'Apply horticultural oil',
        'Neem oil spray',
        'Alcohol wipe (70% isopropyl)',
      ],
      'medicines': [
        'Buprofezin 25% SC - ₹500-750',
        'Thiamethoxam 25% WG - ₹450-700',
        'Chlorpyrifos 20% EC - ₹350-550',
      ],
      'buyLinks': [
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Agrikheti', 'url': 'https://www.agrikheti.com/'},
        {'name': 'Seedsandmore', 'url': 'https://seedsandmore.com/'},
      ],
    },
    'Anthracnose': {
      'description': 'Dark, sunken lesions on fruits and leaves',
      'homeRemedies': [
        'Remove and destroy infected parts',
        'Avoid overhead watering',
        'Improve air circulation',
        'Copper spray',
      ],
      'medicines': [
        'Carbendazim 50% WP - ₹300-500',
        'Azoxystrobin 25% SC - ₹600-900',
        'Copper Oxychloride 50% WP - ₹250-400',
      ],
      'buyLinks': [
        {'name': 'AgroStar', 'url': 'https://www.agrostar.in/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
      ],
    },
    'Nematode Infestation': {
      'description': 'Stunted growth, root galls, yellowing',
      'homeRemedies': [
        'Rotate with marigolds',
        'Solarize soil (clear plastic in summer)',
        'Add organic matter',
        'Plant neem as trap crop',
      ],
      'medicines': [
        'Carbofuran 3% CG - ₹400-600',
        'Paecilomyces lilacinus (Bio-control) - ₹350-550',
        'Neem cake powder - ₹150-300 per kg',
      ],
      'buyLinks': [
        {'name': 'Kisanshop', 'url': 'https://kisanshop.in/'},
        {'name': 'Agribegri', 'url': 'https://www.agribegri.com/'},
        {'name': 'Bighaat', 'url': 'https://www.bighaat.com/'},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreatmentGuideModel());

    _model.searchFieldTextController ??= TextEditingController();
    _model.searchFieldFocusNode ??= FocusNode();

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'TreatmentGuide'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF5F9F0),
        appBar: AppBar(
          backgroundColor: Color(0xFF4CAF50),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 48.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 28.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Treatment Guide',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: Icon(
                FontAwesomeIcons.solidHospital,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ],
          centerTitle: true,
          elevation: 4.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF66BB6A), Color(0xFF388E3C)],
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          FontAwesomeIcons.briefcaseMedical,
                          color: Colors.white,
                          size: 48.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 8.0),
                          child: Text(
                            'Crop Health Treatment Guide',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Text(
                          'Select or search for your crop issue to get instant treatment recommendations',
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color(0x20000000),
                          offset: Offset(0.0, 4.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                      child: TextFormField(
                        controller: _model.searchFieldTextController,
                        focusNode: _model.searchFieldFocusNode,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Search crop problem...',
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF4CAF50),
                            size: 24.0,
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                              letterSpacing: 0.0,
                            ),
                        validator: _model.searchFieldTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),

                // Dropdown Selection
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
                  child: FlutterFlowDropDown<String>(
                    controller: _model.issueDropDownValueController ??=
                        FormFieldController<String>(null),
                    options: treatmentDatabase.keys.toList(),
                    onChanged: (val) =>
                        safeSetState(() => _model.issueDropDownValue = val),
                    width: double.infinity,
                    height: 56.0,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          letterSpacing: 0.0,
                        ),
                    hintText: 'Select crop issue from list...',
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                    fillColor: Colors.white,
                    elevation: 2.0,
                    borderColor: Color(0xFF66BB6A),
                    borderWidth: 2.0,
                    borderRadius: 16.0,
                    margin:
                        EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                    hidesUnderline: true,
                    isOverButton: true,
                    isSearchable: false,
                    isMultiSelect: false,
                  ),
                ),

                // Treatment Display
                if (_model.issueDropDownValue != null)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Problem Description
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFEBEE), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Color(0xFFEF5350),
                              width: 3.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x30000000),
                                offset: Offset(0.0, 4.0),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.warning_rounded,
                                      color: Color(0xFFEF5350),
                                      size: 28.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        _model.issueDropDownValue!,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                color: Color(0xFFEF5350),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Text(
                                    treatmentDatabase[_model
                                        .issueDropDownValue]!['description'],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: Color(0xFF6D4C41),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Home Remedies Section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFF1F8E9), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Color(0xFF9CCC65),
                                width: 3.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8.0,
                                  color: Color(0x30000000),
                                  offset: Offset(0.0, 4.0),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.spa_rounded,
                                        color: Color(0xFF558B2F),
                                        size: 28.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Home Remedies',
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  color: Color(0xFF558B2F),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (treatmentDatabase[
                                                  _model.issueDropDownValue]![
                                              'homeRemedies'] as List<String>)
                                          .map((remedy) => Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            Color(0xFF66BB6A),
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        remedy,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .inter(),
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Medicines Section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE3F2FD), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Color(0xFF42A5F5),
                                width: 3.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8.0,
                                  color: Color(0x30000000),
                                  offset: Offset(0.0, 4.0),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.pills,
                                        color: Color(0xFF1976D2),
                                        size: 24.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Recommended Medicines',
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  color: Color(0xFF1976D2),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (treatmentDatabase[
                                                  _model.issueDropDownValue]![
                                              'medicines'] as List<String>)
                                          .map((medicine) => Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.medication,
                                                        color:
                                                            Color(0xFF42A5F5),
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        medicine,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .inter(),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Buy Links Section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFF3E0), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Color(0xFFFF9800),
                                width: 3.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8.0,
                                  color: Color(0x30000000),
                                  offset: Offset(0.0, 4.0),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_rounded,
                                        color: Color(0xFFE65100),
                                        size: 28.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Where to Buy',
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  color: Color(0xFFE65100),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: (treatmentDatabase[_model
                                                      .issueDropDownValue]![
                                                  'buyLinks']
                                              as List<Map<String, String>>)
                                          .map((link) => Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await launchURL(
                                                        link['url']!);
                                                  },
                                                  text: '🛒 ${link['name']}',
                                                  options: FFButtonOptions(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFFFB74D),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          letterSpacing: 0.0,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Disclaimer
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF9C4),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Color(0xFFFFCA28),
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xFFF57F17),
                                    size: 24.0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Disclaimer: Always consult with agricultural experts before applying chemical treatments. Follow safety guidelines and local regulations.',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.inter(),
                                              color: Color(0xFF6D4C41),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // No Selection Placeholder
                if (_model.issueDropDownValue == null)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 40.0, 16.0, 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          FontAwesomeIcons.seedling,
                          color: Color(0xFF9CCC65),
                          size: 80.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 12.0),
                          child: Text(
                            'Select a Crop Issue',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Text(
                          'Choose from the dropdown above or search to get detailed treatment recommendations',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
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
    );
  }
}
