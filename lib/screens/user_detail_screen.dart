import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  final String currentStatus;

  const UserDetailScreen({
    Key? key,
    required this.userId,
    required this.currentStatus,
  }) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userDetails;
  bool _isLoading = true;
  bool _isUpdating = false;
  String _errorMessage = '';
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _selectedStatus = widget.currentStatus;
  }

  Future<void> _fetchUserDetails() async {
    try {
      final userDetails = await _apiService.getUserById(widget.userId);
      setState(() {
        _userDetails = userDetails;
        _selectedStatus = userDetails['status'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserStatus() async {
    if (_selectedStatus == widget.currentStatus) {
      // No change
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      await _apiService.updateUserStatus(widget.userId, _selectedStatus!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User status updated to $_selectedStatus successfully',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Return true to indicate status was updated
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading user details...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = '';
                  _fetchUserDetails();
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_userDetails == null) {
      return const Center(child: Text('No user data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar Section
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _getRoleColor(_userDetails!['roleCode']),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_userDetails!['firstName']} ${_userDetails!['lastName']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${_userDetails!['username']}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // User Information Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('User ID', _userDetails!['userId'].toString()),
                  const Divider(),
                  _buildInfoRow('Username', '@${_userDetails!['username']}'),
                  const Divider(),
                  _buildInfoRow(
                    'Full Name',
                    '${_userDetails!['firstName']} ${_userDetails!['lastName']}',
                  ),
                  const Divider(),
                  _buildInfoRow('Role', _userDetails!['roleCode']),
                  const Divider(),
                  _buildInfoRow('Created', _userDetails!['createdDateTime']),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Status Update Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Status:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(widget.currentStatus),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.currentStatus,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'New Status:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedStatus,
                                  hint: const Text('Select status'),
                                  isExpanded: true,
                                  items: ['ACTIVE', 'INACTIVE'].map((status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(status),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(status),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStatus = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (_isUpdating ||
                              _selectedStatus == widget.currentStatus)
                          ? null
                          : _updateUserStatus,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: _selectedStatus == widget.currentStatus
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: _isUpdating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _selectedStatus == widget.currentStatus
                                  ? 'No Changes'
                                  : 'Update to $_selectedStatus',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  String _getInitials() {
    final firstName = _userDetails!['firstName'] as String;
    final lastName = _userDetails!['lastName'] as String;
    return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
  }

  Color _getRoleColor(String roleCode) {
    switch (roleCode) {
      case 'ADMIN':
        return Colors.red.shade700;
      case 'USER':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
