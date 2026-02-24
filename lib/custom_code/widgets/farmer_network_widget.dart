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

import 'package:supabase_flutter/supabase_flutter.dart';

class FarmerNetworkWidget extends StatefulWidget {
  const FarmerNetworkWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FarmerNetworkWidgetState createState() => _FarmerNetworkWidgetState();
}

class _FarmerNetworkWidgetState extends State<FarmerNetworkWidget>
    with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  User? _currentUser;

  // --- STATE ---
  bool _isLoading = true;
  bool _hasProfile = false;
  bool _isCreatingProfile = false;
  late TabController _tabController;

  // --- NAVIGATION ---
  bool _isChatOpen = false;
  Map<String, dynamic>? _activeChatProfile;

  // --- DATA ---
  List<Map<String, dynamic>> _allProfiles = [];
  List<Map<String, dynamic>> _myConnections = [];
  List<Map<String, dynamic>> _filteredProfiles = [];

  // --- CONTROLLERS ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // --- VALIDATION ---
  String? _nameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentUser = _supabase.auth.currentUser;
    _checkProfileStatus();
  }

  @override
  void didUpdateWidget(FarmerNetworkWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recheck profile status when widget is updated/rebuilt
    print('🔄 FarmerNetworkWidget updated - rechecking profile status');
    _checkProfileStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ==========================================
  //           DATA LOGIC
  // ==========================================

  Future<void> _checkProfileStatus() async {
    if (_currentUser == null) {
      print('⚠️ No current user found');
      setState(() {
        _hasProfile = false;
        _isLoading = false;
      });
      return;
    }

    print('🔍 Checking profile status for user: ${_currentUser!.id}');

    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', _currentUser!.id)
          .maybeSingle();

      if (data != null) {
        print('✅ Profile found: ${data['name']}');
        if (mounted) {
          setState(() {
            _hasProfile = true;
            _isLoading = true; // Will be set to false by _fetchNetworkData
          });
          await _fetchNetworkData();
        }
      } else {
        print('❌ No profile found - showing creation screen');
        if (mounted) {
          setState(() {
            _hasProfile = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('❌ Error checking profile: $e');
      if (mounted) {
        setState(() {
          _hasProfile = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createProfile() async {
    // Prevent double-tap
    if (_isCreatingProfile) return;

    // Ensure we have a valid user
    if (_currentUser == null) {
      print('❌ No current user - cannot create profile');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to create a profile'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    });

    bool hasError = false;

    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Name is required');
      hasError = true;
    } else if (_nameController.text.trim().length < 3) {
      setState(() => _nameError = 'Name must be at least 3 characters');
      hasError = true;
    }

    if (_phoneController.text.trim().isEmpty) {
      setState(() => _phoneError = 'Phone number is required');
      hasError = true;
    } else if (_phoneController.text.trim().length < 10) {
      setState(() => _phoneError = 'Invalid phone number');
      hasError = true;
    }

    if (hasError) return;

    setState(() {
      _isCreatingProfile = true;
      _isLoading = true;
    });

    try {
      print('🔄 Creating profile for user: ${_currentUser!.id}');
      print('📧 User email: ${_currentUser!.email ?? "NO EMAIL"}');
      print('📛 Name: ${_nameController.text.trim()}');
      print('📞 Phone: ${_phoneController.text.trim()}');

      // Use upsert to handle both create and update cases
      final profileData = {
        'id': _currentUser!.id,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      };
      
      // Only add email if it exists
      if (_currentUser!.email != null && _currentUser!.email!.isNotEmpty) {
        profileData['email'] = _currentUser!.email;
      }

      print('📦 Profile data: $profileData');

      // Upsert will create if doesn't exist, update if exists
      final response = await _supabase
          .from('profiles')
          .upsert(profileData, onConflict: 'id')
          .select();

      print('✅ Profile saved successfully: $response');

      print('🎉 Profile operation completed successfully');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child:
                      Text('Welcome to the network! Start connecting now 🎉'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 3),
          ),
        );

        // Wait a bit for the message to show
        await Future.delayed(Duration(milliseconds: 500));

        print('🔄 Setting _hasProfile = true');
        if (mounted) {
          setState(() {
            _hasProfile = true;
            _isCreatingProfile = false;
          });

          // Fetch network data
          print('🔄 Fetching network data after profile creation...');
          await _fetchNetworkData();
          print('✅ Profile creation complete - showing network view');
        }
      }
    } catch (e) {
      print('❌ Error creating profile: $e');
      print('❌ Error type: ${e.runtimeType}');
      
      // Extract detailed error message for PostgrestException
      String errorMessage = 'Failed to create profile. Please try again.';
      if (e.toString().contains('PostgrestException')) {
        // Extract the actual error message from the exception
        final errorStr = e.toString();
        if (errorStr.contains('message:')) {
          final msgStart = errorStr.indexOf('message:') + 8;
          final msgEnd = errorStr.indexOf(',', msgStart);
          if (msgEnd > msgStart) {
            errorMessage = errorStr.substring(msgStart, msgEnd).trim();
          }
        }
        print('📝 PostgrestException details: $errorStr');
      }
      
      setState(() {
        _isLoading = false;
        _isCreatingProfile = false;
      });

      // Show detailed error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Database Error',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _createProfile,
            ),
          ),
        );
      }
    }
  }

  Future<void> _fetchNetworkData() async {
    print('🔄 Fetching network data...');
    // Don't set _isLoading here - let the caller manage it

    try {
      print('📡 Loading profiles...');
      final profilesData =
          await _supabase.from('profiles').select().neq('id', _currentUser!.id);
      print('✅ Loaded ${profilesData.length} profiles');

      print('📡 Loading connections...');
      List<Map<String, dynamic>> connectionsData = [];
      try {
        final data = await _supabase.from('connections').select().or(
            'sender_id.eq.${_currentUser!.id},receiver_id.eq.${_currentUser!.id}');
        connectionsData = List<Map<String, dynamic>>.from(data);
        print('✅ Loaded ${connectionsData.length} connections');
      } catch (connectionError) {
        print('⚠️ Connections table error (might not exist): $connectionError');
        // Continue with empty connections if table doesn't exist
      }

      if (mounted) {
        setState(() {
          _allProfiles = List<Map<String, dynamic>>.from(profilesData);
          _filteredProfiles = _allProfiles; // Initialize filtered list
          _myConnections = connectionsData;
          _isLoading = false;
        });
        print(
            '✅ Network data state updated - _isLoading = false, profiles: ${_allProfiles.length}');
      }
    } catch (e) {
      print('❌ Error fetching network data: $e');
      if (mounted) {
        setState(() {
          _allProfiles = [];
          _filteredProfiles = [];
          _myConnections = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load network data: ${e.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  // Search and filter functionality
  void _filterProfiles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProfiles = _allProfiles;
      } else {
        _filteredProfiles = _allProfiles.where((profile) {
          final name = profile['name']?.toString().toLowerCase() ?? '';
          final location = profile['location']?.toString().toLowerCase() ?? '';
          final crops = profile['crops']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              location.contains(searchLower) ||
              crops.contains(searchLower);
        }).toList();
      }
    });
  }

  // ==========================================
  //           CONNECTION ACTIONS
  // ==========================================

  Future<void> _sendRequest(String receiverId) async {
    try {
      await _supabase.from('connections').insert({
        'sender_id': _currentUser!.id,
        'receiver_id': receiverId,
        'status': 'pending',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection request sent!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
      _fetchNetworkData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send request. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _acceptRequest(int connectionId) async {
    try {
      await _supabase
          .from('connections')
          .update({'status': 'accepted'}).eq('id', connectionId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection accepted! Start chatting now.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
      _fetchNetworkData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeConnection(int connectionId) async {
    bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Disconnect?"),
            content: Text(
                "Are you sure you want to remove this connection? Chat history will be hidden."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey))),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text("Remove", style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    try {
      await _supabase.from('connections').delete().eq('id', connectionId);
      if (_isChatOpen && _activeChatProfile != null) {
        _closeChat();
      }
      _fetchNetworkData();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing connection')));
    }
  }

  // ==========================================
  //           CHAT LOGIC
  // ==========================================

  void _openChat(Map<String, dynamic> profile) {
    setState(() {
      _activeChatProfile = profile;
      _isChatOpen = true;
    });
  }

  void _closeChat() {
    setState(() {
      _isChatOpen = false;
      _activeChatProfile = null;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _activeChatProfile == null) return;
    _messageController.clear();
    try {
      await _supabase.from('messages').insert({
        'sender_id': _currentUser!.id,
        'receiver_id': _activeChatProfile!['id'],
        'content': text,
      });
    } catch (e) {}
  }

  Stream<List<Map<String, dynamic>>> get _chatStream {
    if (_activeChatProfile == null) return Stream.value([]);
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((messages) {
          final otherId = _activeChatProfile!['id'];
          final myId = _currentUser!.id;
          return messages.where((m) {
            final sender = m['sender_id'];
            final receiver = m['receiver_id'];
            return (sender == myId && receiver == otherId) ||
                (sender == otherId && receiver == myId);
          }).toList();
        });
  }

  Map<String, dynamic> _getStatus(String otherUserId) {
    final sent = _myConnections.firstWhere(
        (c) =>
            c['sender_id'] == _currentUser!.id &&
            c['receiver_id'] == otherUserId,
        orElse: () => {});
    if (sent.isNotEmpty)
      return {
        'status': sent['status'] == 'accepted' ? 'accepted' : 'sent',
        'data': sent
      };

    final received = _myConnections.firstWhere(
        (c) =>
            c['receiver_id'] == _currentUser!.id &&
            c['sender_id'] == otherUserId,
        orElse: () => {});
    if (received.isNotEmpty)
      return {
        'status': received['status'] == 'accepted' ? 'accepted' : 'received',
        'data': received
      };

    return {'status': 'none', 'data': null};
  }

  // ==========================================
  //           UI BUILDER
  // ==========================================

  @override
  Widget build(BuildContext context) {
    print(
        '🏗️ Building widget - _isLoading: $_isLoading, _hasProfile: $_hasProfile, _isChatOpen: $_isChatOpen');

    if (_isLoading) {
      print('⏳ Showing loading spinner');
      return Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary));
    }

    if (!_hasProfile) {
      print('📝 Showing profile creation view');
      return _buildCreateProfileView(context);
    }

    print('🌐 Showing network view');

    if (_isChatOpen && _activeChatProfile != null) {
      return _buildChatScreen(context);
    }

    final incomingRequests = _allProfiles.where((p) {
      final status = _getStatus(p['id']);
      return status['status'] == 'received';
    }).toList();

    final connectedCount =
        _myConnections.where((c) => c['status'] == 'accepted').length;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        children: [
          // --- HEADER & TABS ---
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                // Header with Title and Refresh
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AgriConnect',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.bold,
                                  )),
                          Text(
                            'Connect & Grow Together',
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(() => _isLoading = true);
                          _fetchNetworkData();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.refresh_rounded,
                              size: 20,
                              color: FlutterFlowTheme.of(context).primary),
                        ),
                      )
                    ],
                  ),
                ),

                // Stats Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade50,
                                Colors.green.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                connectedCount.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              Text(
                                'Connections',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade50,
                                Colors.orange.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                incomingRequests.length.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              Text(
                                'Requests',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade50,
                                Colors.blue.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _allProfiles.length.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              Text(
                                'Network',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // --- SEARCH BAR ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProfiles,
                    decoration: InputDecoration(
                      hintText: "Search by name, location, or crops...",
                      hintStyle: FlutterFlowTheme.of(context).labelMedium,
                      prefixIcon: Icon(Icons.search_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _filterProfiles('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).secondaryText,
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Discover"),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Requests"),
                              if (incomingRequests.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    incomingRequests.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- TAB VIEW CONTENT ---
          Expanded(
            child: Container(
              color: FlutterFlowTheme.of(context).primaryBackground,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _filteredProfiles.isEmpty && _searchController.text.isNotEmpty
                      ? _buildEmptyState(
                          context,
                          "No farmers found matching '${_searchController.text}'",
                          Icons.search_off_rounded)
                      : _buildProfileList(context, _filteredProfiles,
                          showIncoming: false),
                  incomingRequests.isEmpty
                      ? _buildEmptyState(
                          context, "No pending requests", Icons.inbox_rounded)
                      : _buildProfileList(context, incomingRequests,
                          showIncoming: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: CHAT SCREEN (Modern) ---
  Widget _buildChatScreen(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Color(0xFFEFEFEF), // Light gray background for chat
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: _closeChat,
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  radius: 20,
                  child: Text(
                    (_activeChatProfile!['name'] ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _activeChatProfile!['name'] ?? 'Unknown',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _activeChatProfile!['phone'] ?? '',
                        style: FlutterFlowTheme.of(context)
                            .labelSmall
                            .override(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return _buildEmptyState(context, "Start the conversation!",
                      Icons.chat_bubble_outline);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['sender_id'] == _currentUser!.id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? FlutterFlowTheme.of(context).primary
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft:
                                isMe ? Radius.circular(16) : Radius.circular(4),
                            bottomRight:
                                isMe ? Radius.circular(4) : Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ],
                        ),
                        child: Text(
                          msg['content'] ?? '',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(12),
            color: FlutterFlowTheme.of(context).secondaryBackground,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: FlutterFlowTheme.of(context).labelMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: ONBOARDING ---
  Widget _buildCreateProfileView(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withOpacity(0.05),
            FlutterFlowTheme.of(context).secondaryBackground,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),

            // Animated Icon
            Container(
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).primary.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(Icons.groups_rounded, size: 70, color: Colors.white),
            ),
            SizedBox(height: 32),

            Text(
              "Create Farmer ID",
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              "Join thousands of farmers. Share knowledge, connect with peers, and grow together! 🌾",
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 15,
                    height: 1.5,
                  ),
            ),
            SizedBox(height: 48),

            // Name Field (Required)
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _nameController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Full Name *",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: Icon(Icons.person_outline,
                      color: FlutterFlowTheme.of(context).primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _nameError,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                onChanged: (value) {
                  if (_nameError != null) {
                    setState(() => _nameError = null);
                  }
                },
              ),
            ),
            SizedBox(height: 18),

            // Phone Field (Required)
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Phone Number *",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: FlutterFlowTheme.of(context).primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _phoneError,
                  counterText: '',
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                onChanged: (value) {
                  if (_phoneError != null) {
                    setState(() => _phoneError = null);
                  }
                },
              ),
            ),

            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "* Required fields",
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
              ),
            ),

            SizedBox(height: 32),

            // Create Profile Button with Loading State
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).primary.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isCreatingProfile ? null : _createProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isCreatingProfile
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            "Creating Profile...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Create Profile & Connect",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: 20),

            // Info Banner
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Connect with farmers across the country. Share knowledge, find support, and grow together! 🌱",
                      style: TextStyle(
                        fontSize: 13,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- SUB-WIDGET: EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: FlutterFlowTheme.of(context).alternate),
          SizedBox(height: 16),
          Text(
            message,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: LIST BUILDER ---
  Widget _buildProfileList(
      BuildContext context, List<Map<String, dynamic>> profiles,
      {required bool showIncoming}) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final rel = _getStatus(profile['id']);
        final status = rel['status'];
        final data = rel['data'];

        if (!showIncoming && status == 'received') return SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              // Avatar with Role Badge
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: status == 'accepted'
                            ? [Colors.green.shade400, Colors.green.shade600]
                            : [
                                FlutterFlowTheme.of(context).primary,
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withOpacity(0.7),
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (status == 'accepted'
                                  ? Colors.green
                                  : FlutterFlowTheme.of(context).primary)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (profile['name'] ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  // Role Badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: profile['role'] == 'Retailer'
                            ? Colors.orange
                            : Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        profile['role'] == 'Retailer'
                            ? Icons.store
                            : Icons.agriculture,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile['name'] ?? 'Unknown',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6),
                        // Role Badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: profile['role'] == 'Retailer'
                                ? Colors.orange.withOpacity(0.15)
                                : Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            profile['role'] ?? 'Farmer',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: profile['role'] == 'Retailer'
                                  ? Colors.orange.shade700
                                  : Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),

                    // Location
                    if (profile['location'] != null &&
                        profile['location'].toString().isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 12,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              profile['location'],
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontSize: 11,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    // Crops
                    if (profile['crops'] != null &&
                        profile['crops'].toString().isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.grass, size: 12, color: Colors.green),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              profile['crops'],
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontSize: 11,
                                    color: Colors.green,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 4),

                    // Status
                    if (status == 'accepted')
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "Connected",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    else if (status == 'received')
                      Text(
                        'Sent you a request',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    else if (status == 'sent')
                      Text(
                        'Request Pending',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      Text(
                        'Farmer',
                        style: FlutterFlowTheme.of(context).labelSmall,
                      ),
                  ],
                ),
              ),

              // Action Buttons
              if (status == 'none')
                ElevatedButton(
                  onPressed: () => _sendRequest(profile['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    shape: StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text('Connect',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              else if (status == 'sent')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: Icon(Icons.access_time_rounded,
                      size: 20, color: Colors.grey),
                )
              else if (status == 'received')
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _acceptRequest(data['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: StadiumBorder(),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child:
                          Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              else if (status == 'accepted')
                // --- CONNECTED ACTIONS ---
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _openChat(profile),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chat_bubble_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20),
                      ),
                    ),
                    SizedBox(width: 4),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'remove') {
                          _removeConnection(data['id']);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.person_remove,
                                  color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Disconnect',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      icon: Icon(Icons.more_vert_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
