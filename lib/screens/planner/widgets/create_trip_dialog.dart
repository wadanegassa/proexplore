import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../providers/destinations_provider.dart';
import '../../../../data/models/models.dart';
import '../../../../widgets/common/smart_image.dart';

class CreateTripDialog extends StatefulWidget {
  final Destination? initialDestination;

  const CreateTripDialog({super.key, this.initialDestination});

  @override
  State<CreateTripDialog> createState() => _CreateTripDialogState();
}

class _CreateTripDialogState extends State<CreateTripDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  Destination? _selectedDestination;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDestination = widget.initialDestination;
    if (_selectedDestination != null) {
      _nameController.text = _selectedDestination!.name;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart 
        ? DateTime.now() 
        : (_startDate ?? DateTime.now());
    
    final firstDate = isStart 
        ? DateTime.now().subtract(const Duration(days: 1))
        : (_startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF009639),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Consumer<DestinationsProvider>(
      builder: (context, destinationsProvider, child) {
        final destinations = destinationsProvider.destinations;
        
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 500,
                  maxHeight: size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Material(
                    color: theme.scaffoldBackgroundColor,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Animated Header with destination image
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: _selectedDestination != null ? 180 : 100,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Background image or gradient
                                  if (_selectedDestination != null)
                                    SmartImage(
                                      imageUrl: _selectedDestination!.imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF009639),
                                            Color(0xFFFEDB00),
                                            Color(0xFFDA121A),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Overlay gradient
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.5),
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Header content
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.flight_takeoff,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                'Plan Your Adventure',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: -0.5,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(0, 2),
                                                      blurRadius: 8.0,
                                                      color: Colors.black45,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_selectedDestination != null)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _selectedDestination!.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 4.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.25),
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                        color: Colors.white.withOpacity(0.4),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Icon(Icons.location_on, color: Colors.white, size: 16),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          _selectedDestination!.country,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Form content
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Destination selector
                                  _buildSectionLabel('Where to?', Icons.explore),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _selectedDestination != null 
                                            ? const Color(0xFF009639)
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                      gradient: _selectedDestination != null
                                          ? LinearGradient(
                                              colors: [
                                                const Color(0xFF009639).withOpacity(0.05),
                                                const Color(0xFF009639).withOpacity(0.02),
                                              ],
                                            )
                                          : null,
                                    ),
                                    child: DropdownButtonFormField<Destination>(
                                      initialValue: _selectedDestination,
                                      decoration: InputDecoration(
                                        hintText: 'Destination',
                                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        errorStyle: const TextStyle(height: 0),
                                      ),
                                      dropdownColor: theme.cardColor,
                                      items: destinations.map((dest) {
                                        return DropdownMenuItem(
                                          value: dest,
                                          child: Text(
                                            dest.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDestination = value;
                                          if (_nameController.text.isEmpty && value != null) {
                                            _nameController.text = 'Trip to ${value.name}';
                                          }
                                        });
                                      },
                                      validator: (value) => value == null ? 'Please select a destination' : null,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Trip name
                                  _buildSectionLabel('Trip Name', Icons.edit_note_rounded),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., Ethiopian Adventure 2025',
                                      prefixIcon: const Icon(Icons.label_outline),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(color: Color(0xFF009639), width: 2),
                                      ),
                                      filled: true,
                                      fillColor: theme.cardColor,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a trip name';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Dates
                                  _buildSectionLabel('When?', Icons.calendar_month_rounded),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDateButton(
                                          context,
                                          'Start Date',
                                          _startDate,
                                          Icons.flight_takeoff,
                                          () => _selectDate(context, true),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildDateButton(
                                          context,
                                          'End Date',
                                          _endDate,
                                          Icons.flight_land,
                                          _startDate == null ? null : () => _selectDate(context, false),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  // Trip duration info
                                  if (_startDate != null && _endDate != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFFEDB00).withOpacity(0.15),
                                              const Color(0xFFFEDB00).withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(0xFFFEDB00).withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFEDB00).withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.access_time_rounded,
                                                size: 20,
                                                color: Color(0xFF009639),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Trip Duration',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.grey,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${_endDate!.difference(_startDate!).inDays + 1} days',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF009639),
                                                    ),
                                                  ),
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
                            
                            // Action buttons
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                border: Border(
                                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        side: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: FilledButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() && 
                                            _startDate != null && 
                                            _endDate != null &&
                                            _selectedDestination != null) {
                                          Navigator.pop(context, {
                                            'name': _nameController.text,
                                            'startDate': _startDate,
                                            'endDate': _endDate,
                                            'destinationId': _selectedDestination!.id,
                                            'destinationName': _selectedDestination!.name,
                                            'destinationImage': _selectedDestination!.imageUrl,
                                          });
                                        }
                                      },
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        backgroundColor: const Color(0xFF009639),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 4,
                                        shadowColor: const Color(0xFF009639).withOpacity(0.4),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle_rounded, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Create Trip',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF009639)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton(
    BuildContext context,
    String label,
    DateTime? date,
    IconData icon,
    VoidCallback? onTap,
  ) {
    final isSelected = date != null;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF009639) : Colors.grey.shade300,
            width: 2,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFF009639).withValues(alpha: 0.1),
                    const Color(0xFF009639).withValues(alpha: 0.05),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? const Color(0xFF009639) : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              date == null ? 'Select' : DateFormat('MMM d, y').format(date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF009639) : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
