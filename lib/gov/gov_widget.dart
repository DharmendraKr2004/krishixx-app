import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gov_model.dart';
export 'gov_model.dart';

/// Comprehensive Government & Private Schemes with Funding Information
/// Professional farming-themed UI with state-wise organization
class GovWidget extends StatefulWidget {
  const GovWidget({super.key});

  static String routeName = 'gov';
  static String routePath = '/gov';

  @override
  State<GovWidget> createState() => _GovWidgetState();
}

class _GovWidgetState extends State<GovWidget>
    with SingleTickerProviderStateMixin {
  late GovModel _model;
  late TabController _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GovModel());
    _tabController = TabController(length: 3, vsync: this);
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'gov'});
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
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
        backgroundColor: Color(0xFFF5F9F5),
        appBar: AppBar(
          backgroundColor: Color(0xFF2E7D32),
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
              logFirebaseEvent('GOV_PAGE_arrow_back_rounded_ICN_ON_TAP');
              logFirebaseEvent('IconButton_navigate_back');
              context.safePop();
            },
          ),
          title: Row(
            children: [
              Icon(Icons.agriculture, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Schemes & Funding',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color(0xFFFDD835),
            indicatorWeight: 3.0,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFB3E5B3),
            labelStyle:
                GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: [
              Tab(
                  icon: Icon(Icons.account_balance, size: 20),
                  text: 'Government'),
              Tab(icon: Icon(Icons.business, size: 20), text: 'Private'),
              Tab(icon: Icon(Icons.money, size: 20), text: 'Funding'),
            ],
          ),
          centerTitle: false,
          elevation: 4.0,
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: TextField(
                controller: _model.textController,
                onChanged: (value) =>
                    setState(() => searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search schemes...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF2E7D32)),
                  filled: true,
                  fillColor: Color(0xFFF5F9F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: Color(0xFF81C784), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: Color(0xFF2E7D32), width: 2.0),
                  ),
                ),
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGovernmentSchemesTab(),
                  _buildPrivateSchemesTab(),
                  _buildFundingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Government Schemes Tab
  Widget _buildGovernmentSchemesTab() {
    final schemes = _getGovernmentSchemes();
    final filtered = schemes
        .where((s) =>
            s['name']!.toLowerCase().contains(searchQuery) ||
            s['state']!.toLowerCase().contains(searchQuery) ||
            s['description']!.toLowerCase().contains(searchQuery))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _buildSchemeCard(filtered[index], true),
    );
  }

  // Private Schemes Tab
  Widget _buildPrivateSchemesTab() {
    final schemes = _getPrivateSchemes();
    final filtered = schemes
        .where((s) =>
            s['name']!.toLowerCase().contains(searchQuery) ||
            s['company']!.toLowerCase().contains(searchQuery) ||
            s['description']!.toLowerCase().contains(searchQuery))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _buildSchemeCard(filtered[index], false),
    );
  }

  // Funding Tab
  Widget _buildFundingTab() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader('Government Funding', Icons.account_balance),
        ..._getGovernmentFunding().map((f) => _buildFundingCard(f)),
        SizedBox(height: 24),
        _buildSectionHeader('Private Funding', Icons.business_center),
        ..._getPrivateFunding().map((f) => _buildFundingCard(f)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(Map<String, String> scheme, bool isGovernment) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF1F8F4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Color(0xFF4CAF50), width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child: Icon(
                      isGovernment ? Icons.account_balance : Icons.business,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme['name']!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFDD835),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isGovernment
                                ? scheme['state']!
                                : scheme['company']!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Description
              Text(
                scheme['description']!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Color(0xFF424242),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              // Eligibility
              _buildInfoRow(
                  Icons.verified_user, 'Eligibility', scheme['eligibility']!),
              SizedBox(height: 12),
              // Benefits
              _buildInfoRow(Icons.stars, 'Benefits', scheme['benefits']!),
              if (scheme['amount'] != null && scheme['amount']!.isNotEmpty) ...[
                SizedBox(height: 12),
                _buildInfoRow(
                    Icons.currency_rupee, 'Amount', scheme['amount']!),
              ],
              SizedBox(height: 16),
              // Apply Button
              ElevatedButton.icon(
                onPressed: () {
                  if (scheme['link'] != null) launchURL(scheme['link']!);
                },
                icon: Icon(Icons.open_in_new, size: 18),
                label: Text('Learn More & Apply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFundingCard(Map<String, String> funding) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Color(0xFFFDD835), width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.monetization_on,
                      color: Color(0xFF1B5E20), size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      funding['name']!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                funding['description']!,
                style: GoogleFonts.inter(
                    fontSize: 14, color: Color(0xFF424242), height: 1.5),
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                  Icons.account_balance_wallet, 'Amount', funding['amount']!),
              SizedBox(height: 8),
              _buildInfoRow(Icons.category, 'Type', funding['type']!),
              SizedBox(height: 8),
              _buildInfoRow(Icons.people, 'Target', funding['target']!),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (funding['link'] != null) launchURL(funding['link']!);
                },
                icon: Icon(Icons.open_in_new, size: 18),
                label: Text('Apply for Funding'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6F00),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF2E7D32), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== DATA SECTION ====================

  List<Map<String, String>> _getGovernmentSchemes() {
    return [
      // NATIONAL SCHEMES
      {
        'name': 'PM-KISAN (Pradhan Mantri Kisan Samman Nidhi)',
        'state': 'All India',
        'description':
            'Direct income support of ₹6,000 per year to all farmer families across the country in three equal 4-monthly installments of ₹2,000 each.',
        'eligibility': 'All landholding farmer families',
        'benefits': '₹6,000/year in 3 installments directly to bank account',
        'amount': '₹2,000 per installment (3 times/year)',
        'link': 'https://pmkisan.gov.in/',
      },
      {
        'name': 'PM Fasal Bima Yojana (PMFBY)',
        'state': 'All India',
        'description':
            'Crop insurance scheme providing financial support to farmers suffering crop loss/damage arising out of unforeseen events.',
        'eligibility': 'All farmers growing notified crops in notified areas',
        'benefits':
            'Up to 90% premium subsidy, cover against all non-preventable risks',
        'amount': '2% for Kharif, 1.5% for Rabi crops',
        'link': 'https://pmfby.gov.in/',
      },
      {
        'name': 'PM-KUSUM (Kisan Urja Suraksha)',
        'state': 'All India',
        'description':
            'Aims to provide financial and water security to farmers. Supports installation of solar pumps and grid-connected solar power plants.',
        'eligibility': 'Individual farmers, cooperatives, panchayats',
        'benefits':
            'Solar pump subsidies, extra income from selling surplus power',
        'amount': 'Up to 60% subsidy on solar pumps',
        'link': 'https://mnre.gov.in/pm-kusum/',
      },
      {
        'name': 'Kisan Credit Card (KCC)',
        'state': 'All India',
        'description':
            'Provides timely and adequate credit support to farmers for cultivation and related activities with simple procedures and attractive interest rates.',
        'eligibility': 'Farmers, tenant farmers, sharecroppers, SHGs',
        'benefits': 'Credit up to ₹3 lakh at 4% interest, accident insurance',
        'amount': 'Up to ₹3 lakh credit limit',
        'link': 'https://pmkisan.gov.in/kccforms.aspx',
      },
      {
        'name': 'Soil Health Card Scheme',
        'state': 'All India',
        'description':
            'Provides soil health cards to farmers carrying crop-wise recommendations of nutrients and fertilizers required for individual farms.',
        'eligibility': 'All farmers',
        'benefits': 'Free soil testing, customized fertilizer recommendations',
        'amount': 'Free service',
        'link': 'https://soilhealth.dac.gov.in/',
      },

      // MAHARASHTRA
      {
        'name': 'Mahatma Jyotiba Phule Shetkari Karjmukti Yojana',
        'state': 'Maharashtra',
        'description':
            'Loan waiver scheme for farmers with outstanding crop loans. Provides relief to small and marginal farmers.',
        'eligibility': 'Farmers with crop loans up to ₹2 lakh',
        'benefits': 'Complete loan waiver for eligible farmers',
        'amount': 'Up to ₹2 lakh loan waiver',
        'link': 'https://mahakarz.maharashtra.gov.in/',
      },
      {
        'name': 'Mukhyamantri Krishi Pump Bijali Connection Yojana',
        'state': 'Maharashtra',
        'description':
            'Provides electricity connections for agricultural water pumps to enhance irrigation facilities.',
        'eligibility': 'Farmers requiring new agriculture pump connections',
        'benefits': 'Subsidized electricity connection, lower tariffs',
        'amount': '50% subsidy on connection costs',
        'link': 'https://www.mahadiscom.in/',
      },

      // PUNJAB
      {
        'name': 'Punjab Crop Diversification Programme',
        'state': 'Punjab',
        'description':
            'Encourages farmers to shift from water-intensive paddy to alternative crops like maize, pulses, oilseeds, and vegetables.',
        'eligibility': 'Farmers cultivating paddy in non-basmati areas',
        'benefits': 'Financial incentives, MSP support, free seeds',
        'amount': '₹1,500 per acre incentive',
        'link': 'https://agripb.punjab.gov.in/',
      },
      {
        'name': 'Interest-free Crop Loan Scheme',
        'state': 'Punjab',
        'description':
            'Provides interest-free short-term crop loans up to ₹3 lakh to farmers who repay on time.',
        'eligibility': 'All farmers with KCC',
        'benefits': 'Zero interest on timely repayment',
        'amount': 'Up to ₹3 lakh',
        'link': 'https://pbagri.punjab.gov.in/',
      },

      // UTTAR PRADESH
      {
        'name': 'Mukhyamantri Kisan evam Sarvhit Bima Yojana',
        'state': 'Uttar Pradesh',
        'description':
            'Insurance scheme providing accident and life cover to farmers between 18-70 years.',
        'eligibility': 'Farmers aged 18-70 years',
        'benefits': 'Accidental death cover ₹5 lakh, disability cover ₹2 lakh',
        'amount': 'Premium paid by government',
        'link': 'https://balrampur.nic.in/scheme/',
      },
      {
        'name': 'Free Boring Scheme',
        'state': 'Uttar Pradesh',
        'description':
            'Provides financial assistance for installation of borings to small and marginal farmers.',
        'eligibility': 'Small and marginal farmers',
        'benefits': 'Grant for boring installation',
        'amount': '₹10,000 for general, ₹12,000 for SC/ST',
        'link': 'https://upagripardarshi.gov.in/',
      },

      // GUJARAT
      {
        'name': 'Mukhyamantri Kisan Sahay Yojana',
        'state': 'Gujarat',
        'description':
            'Provides financial assistance to farmers affected by natural calamities like excess rain, drought, or untimely rain.',
        'eligibility':
            'All farmers suffering crop loss due to natural calamities',
        'benefits': 'Compensation of ₹20,000 to ₹25,000 per hectare',
        'amount': '₹20,000-25,000/hectare depending on damage',
        'link': 'https://agri.gujarat.gov.in/',
      },
      {
        'name': 'Solar Pump Yojana',
        'state': 'Gujarat',
        'description':
            'Encourages installation of solar-powered water pumps for sustainable and cost-effective irrigation.',
        'eligibility': 'Farmers with agricultural land',
        'benefits': '90% subsidy on solar pump installation',
        'amount': '90% subsidy',
        'link': 'https://suryagujarat.gujarat.gov.in/',
      },

      // KARNATAKA
      {
        'name': 'Raitha Shakti Scheme',
        'state': 'Karnataka',
        'description':
            'Provides subsidized agricultural equipment and technology to farmers for modern farming practices.',
        'eligibility': 'Individual farmers and FPOs',
        'benefits': '50-80% subsidy on farm equipment',
        'amount': '₹50,000 to ₹10 lakh subsidy',
        'link': 'https://raitamitra.karnataka.gov.in/',
      },
      {
        'name': 'Krishi Bhagya Scheme',
        'state': 'Karnataka',
        'description':
            'Aims to provide assured irrigation to rain-fed areas through construction of farm ponds, bore wells, and micro-irrigation.',
        'eligibility': 'Farmers in rain-fed areas',
        'benefits': 'Subsidy for farm ponds and drip irrigation',
        'amount': '80% subsidy for SC/ST, 50% for others',
        'link': 'https://raitamitra.karnataka.gov.in/',
      },

      // TAMIL NADU
      {
        'name': 'Uzhavar Sandhai (Farmers Market)',
        'state': 'Tamil Nadu',
        'description':
            'Direct marketing platform where farmers can sell their produce directly to consumers, eliminating middlemen.',
        'eligibility': 'All farmers',
        'benefits': 'Better price realization, direct market access',
        'amount': 'No fees, free market space',
        'link': 'https://www.tn.gov.in/scheme/data_view/23817',
      },
      {
        'name': 'Free Colour TV and Mixer Grinder Scheme',
        'state': 'Tamil Nadu',
        'description':
            'Provides free household appliances to farmer families to improve quality of life.',
        'eligibility': 'Farmer families with less than 2.5 acres',
        'benefits': 'Free TV and mixer grinder',
        'amount': 'Free appliances',
        'link': 'https://www.tn.gov.in/',
      },

      // ANDHRA PRADESH
      {
        'name': 'YSR Rythu Bharosa',
        'state': 'Andhra Pradesh',
        'description':
            'Financial assistance scheme providing direct income support to all landholding farmers.',
        'eligibility': 'Landowning farmers',
        'benefits': '₹13,500 per year in 1-5 acre holdings',
        'amount': '₹13,500/year',
        'link': 'https://ysrrythubharosa.ap.gov.in/',
      },
      {
        'name': 'YSR Free Crop Insurance Scheme',
        'state': 'Andhra Pradesh',
        'description':
            'Comprehensive crop insurance covering all risks with zero premium for farmers.',
        'eligibility': 'All cultivating farmers',
        'benefits': 'Full crop insurance without any premium',
        'amount': 'Government pays premium',
        'link': 'https://gsws.ap.gov.in/',
      },

      // TELANGANA
      {
        'name': 'Rythu Bandhu Scheme',
        'state': 'Telangana',
        'description':
            'Investment support for agriculture providing cash assistance per acre for both crop seasons.',
        'eligibility': 'All landowning farmers',
        'benefits': '₹10,000 per acre per year',
        'amount': '₹5,000 per acre per season',
        'link': 'https://rythubandhu.telangana.gov.in/',
      },
      {
        'name': 'Rythu Bima Scheme',
        'state': 'Telangana',
        'description':
            'Life insurance scheme for farmers between 18-59 years providing death and disability coverage.',
        'eligibility': 'Farmers aged 18-59 years',
        'benefits': '₹5 lakh death cover, ₹2.5 lakh disability',
        'amount': 'Government pays premium',
        'link': 'https://epds.telangana.gov.in/',
      },

      // RAJASTHAN
      {
        'name': 'Mukhyamantri Laghu Udhyog Protsahan Yojana',
        'state': 'Rajasthan',
        'description':
            'Provides subsidy and loans to farmers for setting up agro-processing and allied business units.',
        'eligibility': 'Farmers and rural entrepreneurs',
        'benefits': 'Loans up to ₹25 lakh with subsidy',
        'amount': '25% subsidy on capital expenditure',
        'link': 'https://sso.rajasthan.gov.in/',
      },
      {
        'name': 'Mukhyamantri Kisan Mitra Urja Yojana',
        'state': 'Rajasthan',
        'description':
            'Provides financial assistance to farmers for electricity bills for agricultural purposes.',
        'eligibility': 'Farmers with metered agriculture connections',
        'benefits': '₹1,000 per month subsidy on electricity bills',
        'amount': 'Up to ₹12,000/year',
        'link': 'https://energy.rajasthan.gov.in/',
      },

      // MADHYA PRADESH
      {
        'name': 'Mukhyamantri Kisan Kalyan Yojana',
        'state': 'Madhya Pradesh',
        'description':
            'Provides financial assistance to farmers for crop production and enhancement of agricultural income.',
        'eligibility': 'All farmers',
        'benefits': '₹4,000 per year per farmer',
        'amount': '₹2,000 per season',
        'link': 'https://pmkisan.gov.in/',
      },
      {
        'name': 'Bhavantar Bhugtan Yojana',
        'state': 'Madhya Pradesh',
        'description':
            'Price deficiency payment scheme protecting farmers from price fluctuations by compensating the difference.',
        'eligibility': 'Farmers cultivating notified crops',
        'benefits': 'Compensation for price difference',
        'amount': 'MSP - Market Price compensation',
        'link': 'https://mpeuparjan.nic.in/',
      },

      // WEST BENGAL
      {
        'name': 'Krishak Bandhu Scheme',
        'state': 'West Bengal',
        'description':
            'Bi-annual financial assistance to farmers for farming activities and life insurance coverage.',
        'eligibility': 'All farmers cultivating land',
        'benefits': '₹10,000/year + ₹2 lakh life insurance',
        'amount': '₹5,000 per season',
        'link': 'https://krishakbandhu.net/',
      },
      {
        'name': 'Bangla Shasya Bima',
        'state': 'West Bengal',
        'description':
            'Crop insurance scheme equivalent to PMFBY with additional state support.',
        'eligibility': 'All cultivating farmers',
        'benefits': 'Comprehensive crop insurance coverage',
        'amount': 'Low premium with high coverage',
        'link': 'https://banglashasyabima.net/',
      },

      // BIHAR
      {
        'name': 'Bihar Krishi Investment Promotion Scheme',
        'state': 'Bihar',
        'description':
            'Provides subsidy on farm mechanization and modern agricultural equipment.',
        'eligibility': 'Individual farmers and groups',
        'benefits': '40-80% subsidy on agri-equipment',
        'amount': 'Up to 80% subsidy',
        'link': 'https://farmech.bih.nic.in/',
      },
      {
        'name': 'Mukhyamantri Krishi Ashirwad Yojana',
        'state': 'Bihar',
        'description':
            'Financial assistance for smallholder farmers for crop cultivation.',
        'eligibility': 'Farmers with up to 5 acres',
        'benefits': '₹6,000 per season',
        'amount': '₹6,000 per hectare per season',
        'link': 'https://dbtagriculture.bihar.gov.in/',
      },

      // ODISHA
      {
        'name':
            'KALIA (Krushak Assistance for Livelihood and Income Augmentation)',
        'state': 'Odisha',
        'description':
            'Multi-pronged scheme providing financial assistance for cultivation, livelihoods, and life insurance.',
        'eligibility': 'Small/marginal farmers and landless laborers',
        'benefits': '₹10,000 per year + ₹2 lakh life insurance',
        'amount': '₹5,000 per season for cultivation',
        'link': 'https://kalia.odisha.gov.in/',
      },
      {
        'name': 'Balaram Yojana',
        'state': 'Odisha',
        'description':
            'Provides agricultural implements like power tillers, weeders, and sprayers at subsidized rates.',
        'eligibility': 'Small and marginal farmers',
        'benefits': '50-80% subsidy on farm equipment',
        'amount': 'Varies by equipment',
        'link': 'https://agriodisha.nic.in/',
      },

      // HARYANA
      {
        'name': 'Meri Fasal Mera Byora',
        'state': 'Haryana',
        'description':
            'Online portal for farmer registration, crop procurement, and access to various agricultural services.',
        'eligibility': 'All farmers in Haryana',
        'benefits': 'MSP procurement, insurance, disaster relief',
        'amount': 'Multiple benefits',
        'link': 'https://fasal.haryana.gov.in/',
      },
      {
        'name': 'Bhavantar Bharpai Yojana',
        'state': 'Haryana',
        'description':
            'Compensates farmers for the difference between MSP and actual market price of horticultural crops.',
        'eligibility': 'Farmers growing vegetables and fruits',
        'benefits': 'Price protection, compensation',
        'amount': 'MSP difference paid',
        'link': 'https://hsamb.org/',
      },
    ];
  }

  List<Map<String, String>> _getPrivateSchemes() {
    return [
      {
        'name': 'ITC e-Choupal Initiative',
        'company': 'ITC Limited',
        'description':
            'Digital platform connecting farmers directly to markets, providing real-time information on weather, prices, and best farming practices.',
        'eligibility': 'Farmers associated with ITC through e-Choupals',
        'benefits':
            'Better price realization, market access, quality inputs, expert advice',
        'amount': 'Free service + market linkage',
        'link':
            'https://www.itcportal.com/businesses/agri-business/e-choupal.aspx',
      },
      {
        'name': 'Jivit Water Saver Program',
        'company': 'Jain Irrigation',
        'description':
            'Micro-irrigation solutions with affordable payment options to help farmers conserve water and increase productivity.',
        'eligibility': 'All farmers',
        'benefits': 'Drip and sprinkler systems, 40-70% water saving',
        'amount': 'Subsidy + flexible payment plans',
        'link': 'https://www.jains.com/',
      },
      {
        'name': 'Mahindra Samriddhi Agri Solutions',
        'company': 'Mahindra & Mahindra',
        'description':
            'Comprehensive farming solutions including equipment financing, crop advisory, and market linkages.',
        'eligibility': 'Farmers and FPOs',
        'benefits': 'Tractor financing, crop solutions, buyback guarantee',
        'amount': 'Low-interest loans + subsidies',
        'link': 'https://www.mahindra.com/agriculture',
      },
      {
        'name': 'DeHaat Farmer Service Platform',
        'company': 'DeHaat Pvt Ltd',
        'description':
            'End-to-end agricultural services including advisory, input supply, credit, and market linkage through digital platform.',
        'eligibility': 'All farmers',
        'benefits': 'Free advisory, quality inputs, assured buyback',
        'amount': 'Free service + competitive pricing',
        'link': 'https://www.dehaat.in/',
      },
      {
        'name': 'Reliance Foundation Farmer Connect',
        'company': 'Reliance Foundation',
        'description':
            'Training and technology platform offering crop advisory, soil testing, and direct market access.',
        'eligibility': 'Small and marginal farmers',
        'benefits': 'Free training, soil health cards, market linkage',
        'amount': 'Free services',
        'link': 'https://www.reliancefoundation.org/',
      },
      {
        'name': 'BigHaat Agri Input Portal',
        'company': 'BigHaat',
        'description':
            'Online marketplace for agricultural inputs with expert advisory and doorstep delivery.',
        'eligibility': 'All farmers',
        'benefits': 'Quality inputs, free advisory, discounts',
        'amount': '10-30% discount on inputs',
        'link': 'https://www.bighaat.com/',
      },
      {
        'name': 'AgroStar Farmer Platform',
        'company': 'AgroStar',
        'description':
            'Mobile app providing personalized agronomy advice, quality input supply, and market information.',
        'eligibility': 'All farmers with smartphones',
        'benefits': 'Free expert advice, genuine products, credit facility',
        'amount': 'Free app + product discounts',
        'link': 'https://agrostar.in/',
      },
      {
        'name': 'Ninjacart Farm-to-Business Platform',
        'company': 'Ninjacart',
        'description':
            'Tech-enabled supply chain connecting farmers directly to retailers and businesses.',
        'eligibility': 'Fruit and vegetable farmers',
        'benefits': 'Assured offtake, fair pricing, digital payments',
        'amount': 'No commission for farmers',
        'link': 'https://www.ninjacart.com/',
      },
      {
        'name': 'CropIn SmartFarm Solutions',
        'company': 'CropIn Technology',
        'description':
            'AI-powered farm management platform offering crop monitoring, yield prediction, and risk assessment.',
        'eligibility': 'Progressive farmers and FPOs',
        'benefits': 'Precision agriculture, data-driven decisions',
        'amount': 'Subscription-based + free trial',
        'link': 'https://www.cropin.com/',
      },
      {
        'name': 'Farmtaaza Direct Procurement',
        'company': 'Farmtaaza',
        'description':
            'Direct procurement model connecting vegetable farmers with urban consumers and retailers.',
        'eligibility': 'Vegetable growers',
        'benefits': 'Price transparency, assured market, quick payment',
        'amount': 'Better than mandi rates',
        'link': 'https://www.farmtaaza.com/',
      },
      {
        'name': 'Tata Kisan Sansar',
        'company': 'Tata Chemicals',
        'description':
            'Rural business hub providing agricultural inputs, advisory services, and farmer training.',
        'eligibility': 'All farmers',
        'benefits': 'Quality inputs, training, soil testing',
        'amount': 'Competitive pricing + free services',
        'link': 'https://www.tatachemicals.com/',
      },
      {
        'name': 'Shubh Life Farmer Welfare',
        'company': 'Piramal Foundation',
        'description':
            'Integrated program providing farming techniques training, market linkage, and financial literacy.',
        'eligibility': 'Smallholder farmers',
        'benefits': 'Training, inputs, health checkups',
        'amount': 'Subsidized inputs + free services',
        'link': 'https://www.piramalfoundation.org/',
      },
      {
        'name': 'Godrej Agrovet Dairy Program',
        'company': 'Godrej Agrovet',
        'description':
            'Integrated dairy farming support including cattle feed, veterinary services, and milk procurement.',
        'eligibility': 'Dairy farmers',
        'benefits': 'Quality feed, vet services, assured buyback',
        'amount': 'Competitive milk prices + input credit',
        'link': 'https://www.godrejagrovet.com/',
      },
      {
        'name': 'Cargill Farmer Hub',
        'company': 'Cargill India',
        'description':
            'Training platform for sustainable farming practices, crop diversification, and market access.',
        'eligibility': 'Contract farmers and FPOs',
        'benefits': 'Technical training, quality inputs, buyback',
        'amount': 'Assured price + premium for quality',
        'link': 'https://www.cargill.co.in/',
      },
      {
        'name': 'Waycool Fresh Produce Platform',
        'company': 'Waycool Foods',
        'description':
            'Farm-to-fork supply chain connecting farmers with bulk buyers and providing cold chain facilities.',
        'eligibility': 'Produce farmers',
        'benefits': 'Cold storage, logistics, fair pricing',
        'amount': 'No middleman costs',
        'link': 'https://www.waycool.in/',
      },
    ];
  }

  List<Map<String, String>> _getGovernmentFunding() {
    return [
      {
        'name': 'NABARD Agri-Business Loans',
        'description':
            'Financial support for setting up agri-processing units, cold storage, warehousing, and market infrastructure.',
        'amount': '₹10 lakh to ₹10 crore',
        'type': 'Term Loan + Working Capital',
        'target': 'Farmers, FPOs, Agro-entrepreneurs',
        'link': 'https://www.nabard.org/',
      },
      {
        'name': 'PMFME (PM Formalization of Micro Food Processing Enterprises)',
        'description':
            'Credit-linked capital subsidy for upgrading and establishing micro food processing units.',
        'amount': '₹10 lakh credit + 35% subsidy',
        'type': 'Capital Subsidy',
        'target': 'Individual entrepreneurs, FPOs, SHGs, cooperatives',
        'link': 'https://pmfme.mofpi.gov.in/',
      },
      {
        'name': 'Agriculture Infrastructure Fund',
        'description':
            '₹1 lakh crore financing facility for farm-gate and aggregation infrastructure including cold rooms, warehouses, sorting and processing units.',
        'amount': 'Up to ₹2 crore per project',
        'type': 'Low-interest loan + 3% interest subvention',
        'target':
            'Primary Agricultural Cooperatives, FPOs, individual entrepreneurs',
        'link': 'https://agriinfra.dac.gov.in/',
      },
      {
        'name': 'MIDH (Mission for Integrated Development of Horticulture)',
        'description':
            'Funding for horticulture development including protected cultivation, precision farming, and post-harvest management.',
        'amount': '₹5 lakh to ₹50 lakh',
        'type': 'Capital subsidy 40-50%',
        'target': 'Horticulture farmers, FPOs',
        'link': 'http://midh.gov.in/',
      },
      {
        'name': 'National Livestock Mission',
        'description':
            'Financial assistance for entrepreneurship development, breed improvement, and risk coverage in livestock sector.',
        'amount': '₹2 lakh to ₹25 lakh',
        'type': 'Subsidy 25-33%',
        'target': 'Livestock farmers, entrepreneurs',
        'link': 'http://dahd.nic.in/nlm',
      },
      {
        'name':
            'SFURTI (Scheme of Fund for Regeneration of Traditional Industries)',
        'description':
            'Supports traditional industries and artisans including food processing clusters.',
        'amount': 'Up to ₹8 crore per cluster',
        'type': 'Grant-in-aid',
        'target': 'Clusters of traditional industries, artisans',
        'link': 'https://sfurti.msme.gov.in/',
      },
      {
        'name': 'Dairy Processing & Infrastructure Development Fund',
        'description':
            'Provides low-interest loans for creation and modernization of dairy processing infrastructure.',
        'amount': '₹10,000 crore corpus',
        'type': 'Low-interest loan (6.5%)',
        'target': 'Milk cooperatives, dairy farmers',
        'link': 'http://www.nddb.coop/',
      },
      {
        'name': 'NABARD Start-up Village Entrepreneurship Programme (SVEP)',
        'description':
            'Supports rural entrepreneurs through enterprise development, credit linkage, and business incubation.',
        'amount': '₹2 lakh to ₹10 lakh',
        'type': 'Subsidized loan + mentoring',
        'target': 'Rural youth, women entrepreneurs',
        'link': 'https://www.nabard.org/content1.aspx?id=539',
      },
      {
        'name': 'Paramparagat Krishi Vikas Yojana (PKVY)',
        'description':
            'Promotes organic farming through cluster approach, certification support, and market linkages.',
        'amount': '₹50,000 per hectare for 3 years',
        'type': 'Direct financial assistance',
        'target': 'Organic farmers forming clusters',
        'link': 'https://pgsindia-ncof.gov.in/',
      },
      {
        'name': 'Central Sector Scheme on Agricultural Mechanization',
        'description':
            'Financial assistance for procurement of agricultural machinery and establishment of Farm Machinery Banks.',
        'amount': '₹10 lakh to ₹1 crore',
        'type': 'Subsidy 40-80%',
        'target': 'Farmers, Custom Hiring Centers, FPOs',
        'link': 'https://farmech.dac.gov.in/',
      },
    ];
  }

  List<Map<String, String>> _getPrivateFunding() {
    return [
      {
        'name': 'Samunnati Agri Supply Chain Financing',
        'description':
            'Working capital and term loans for farmer collectives, agri-businesses, and processors with flexible repayment.',
        'amount': '₹10 lakh to ₹50 crore',
        'type': 'Debt financing',
        'target': 'FPOs, agri-businesses, processors',
        'link': 'https://www.samunnati.com/',
      },
      {
        'name': 'Omnivore AgriTech Fund',
        'description':
            'Venture capital for agritech startups working on farm productivity, supply chain, and market access solutions.',
        'amount': '\$500K to \$5 million',
        'type': 'Equity investment',
        'target': 'Agritech startups, early to growth stage',
        'link': 'http://www.omnivore.vc/',
      },
      {
        'name': 'Ankur Capital Agri Investments',
        'description':
            'Early-stage venture capital for startups in agriculture, rural enterprises, and food systems.',
        'amount': '\$250K to \$2 million',
        'type': 'Seed to Series A equity',
        'target': 'Agri-tech startups, rural innovation',
        'link': 'https://www.ankurcapital.com/',
      },
      {
        'name': 'Accion Venture Lab Agri-Fintech',
        'description':
            'Seed investment for fintech solutions serving smallholder farmers and rural entrepreneurs.',
        'amount': '\$500K to \$3 million',
        'type': 'Equity + strategic support',
        'target': 'Fintech startups in agriculture',
        'link': 'https://www.accion.org/venturelab',
      },
      {
        'name': 'Caspian Impact Investment Agricultural Fund',
        'description':
            'Impact investment for sustainable agriculture, agribusiness, and rural livelihoods.',
        'amount': '₹5 crore to ₹50 crore',
        'type': 'Debt + quasi-equity',
        'target': 'Established agribusinesses, social enterprises',
        'link': 'https://caspianimpact.com/',
      },
      {
        'name': 'Aavishkaar Capital Agriculture Investments',
        'description':
            'Growth-stage funding for businesses improving farmer livelihoods and agricultural productivity.',
        'amount': '\$2 million to \$10 million',
        'type': 'Growth equity',
        'target': 'High-impact agri businesses',
        'link': 'https://www.aavishkaar.in/',
      },
      {
        'name': 'Mahindra Finance Samriddhi Loans',
        'description':
            'Flexible financing solutions for farm equipment, land development, and allied agricultural activities.',
        'amount': '₹1 lakh to ₹25 lakh',
        'type': 'Asset-backed loans',
        'target': 'Individual farmers, farmer groups',
        'link': 'https://www.mahindrafinance.com/sme-loans',
      },
      {
        'name': 'HDFC Bank Agri Loans',
        'description':
            'Comprehensive loan products for crop cultivation, land purchase, farm mechanization, and agri-allied activities.',
        'amount': '₹25,000 to ₹100 lakh',
        'type': 'Term loan + working capital',
        'target': 'Farmers, agri-entrepreneurs, dealers',
        'link':
            'https://www.hdfcbank.com/personal/borrow/popular-loans/loans-for-agriculturists',
      },
      {
        'name': 'ICICI Bank Agri Business Loans',
        'description':
            'Customized financing for agro-processing, cold storage, dairy, poultry, and horticulture ventures.',
        'amount': '₹5 lakh to ₹200 crore',
        'type': 'Project finance + working capital',
        'target': 'Agro-processors, exporters, traders',
        'link': 'https://www.icicibank.com/business-banking/agri-and-rural',
      },
      {
        'name': 'Axis Bank Kisan Credit Card Plus',
        'description':
            'Enhanced credit facility with insurance coverage, overdraft facility, and competitive interest rates.',
        'amount': 'Up to ₹3 lakh',
        'type': 'Revolving credit + insurance',
        'target': 'All categories of farmers',
        'link':
            'https://www.axisbank.com/retail/loans/agricultural-loan/kisan-credit-card',
      },
      {
        'name': 'Kotak Mahindra Agri Finance',
        'description':
            'Financing for purchase of tractors, farm equipment, and development of agricultural land.',
        'amount': '₹50,000 to ₹50 lakh',
        'type': 'Secured term loans',
        'target': 'Farmers and farm equipment dealers',
        'link':
            'https://www.kotak.com/en/personal-banking/loans/agri-loan.html',
      },
      {
        'name': 'Tata Capital Agri Loans',
        'description':
            'Affordable financing solutions for agricultural needs including crop loans, equipment finance, and land purchase.',
        'amount': '₹1 lakh to ₹75 lakh',
        'type': 'Flexible loan products',
        'target': 'Farmers across crop cycles',
        'link': 'https://www.tatacapital.com/',
      },
      {
        'name': 'Agrowave Farmer Producer Financing',
        'description':
            'Specialized financing for FPOs including working capital, infrastructure development, and commodity financing.',
        'amount': '₹10 lakh to ₹10 crore',
        'type': 'Structured debt',
        'target': 'Farmer Producer Organizations',
        'link': 'https://www.agrowave.in/',
      },
      {
        'name': 'Village Capital AgTech Accelerator',
        'description':
            'Peer-selected investment program for early-stage agtech entrepreneurs with mentorship and funding.',
        'amount': '\$25K to \$100K',
        'type': 'Convertible note + acceleration',
        'target': 'Early-stage agtech startups',
        'link': 'https://www.vilcap.com/',
      },
      {
        'name': 'Rabobank India Agri Financing',
        'description':
            'Comprehensive financial solutions for food and agribusiness sector covering entire value chain.',
        'amount': '₹10 crore to ₹500 crore',
        'type': 'Corporate lending',
        'target': 'Large agri-businesses and food companies',
        'link': 'https://www.rabobank.com/en/rabobank-in-india.html',
      },
    ];
  }
}
