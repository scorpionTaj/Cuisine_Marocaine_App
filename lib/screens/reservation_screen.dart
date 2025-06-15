import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/reservation.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'all_reservations_screen.dart';

class ReservationScreen extends StatefulWidget {
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final Map<String, List<String>> _dishCategories = {
    'Plats principaux': ['Tajine de poulet', 'Couscous royal', 'Mechoui'],
    'Entrées': ['Harira', 'Zaalouk', 'Briouates'],
    'Desserts & Boissons': ['Cornes de gazelle', 'Chebakia', 'Thé à la menthe', 'Jus d\'orange'],
  };
  final Set<String> _selectedDishes = {};
  int _guests = 2;
  int _selectedTable = 1;
  final _notesController = TextEditingController();
  bool _isLoading = false;
  bool _isCheckingReservations = true;
  List<Reservation> _userReservations = [];
  String _username = '';
  bool _isLoggedIn = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  // Available time slots
  final List<String> _timeSlots = [
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00'
  ];

  Set<int> _unavailableTables = {};

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    setState(() {
      _isLoggedIn = isLoggedIn;
      _username = username;
    });

    if (isLoggedIn) {
      _loadReservations();
    } else {
      setState(() => _isCheckingReservations = false);
    }
  }

  Future<void> _loadReservations() async {
    setState(() => _isCheckingReservations = true);

    try {
      final reservations = await DatabaseService.getUserReservations(_username);
      setState(() {
        _userReservations = reservations.map((res) => Reservation.fromMap(res)).toList();
        _isCheckingReservations = false;
      });
    } catch (e) {
      print('Error loading reservations: $e');
      setState(() => _isCheckingReservations = false);
    }
  }

  List<Reservation> _getReservationsForDay(DateTime day) {
    final date = DateFormat('yyyy-MM-dd').format(day);
    return _userReservations.where((res) => res.date == date).toList();
  }

  void _updateUnavailableTables() {
    if (_selectedTime != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final taken = _userReservations
          .where((r) => r.date == dateStr && r.time == _selectedTime)
          .map((r) => r.tableNumber)
          .toSet();
      setState(() => _unavailableTables = taken);
    } else {
      setState(() => _unavailableTables = {});
    }
  }

  Future<void> _submitReservation() async {
    if (!_isLoggedIn) {
      _showLoginDialog();
      return;
    }

    if (!_formKey.currentState!.validate() || _selectedTime == null || _selectedDishes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs requis')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final resId = await DatabaseService.createReservation(
        username: _username,
        date: date,
        time: _selectedTime!,
        guests: _guests,
        dish: _selectedDishes.join(', '),
        tableNumber: _selectedTable,
        notes: _notesController.text,
      );

      if (resId > 0) {
        _showSuccessDialog();
        _resetForm();
        _loadReservations();
      } else {
        _showErrorDialog('Une erreur est survenue lors de la réservation.');
      }
    } catch (e) {
      _showErrorDialog('Erreur: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Connexion nécessaire'),
        content: Text('Vous devez être connecté pour effectuer une réservation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Réservation confirmée'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Votre réservation a été confirmée pour:'),
            SizedBox(height: 8),
            Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
            Text('Heure: $_selectedTime'),
            Text('Plat: ${_selectedDishes.join(', ')}'),
            Text('Nombre de personnes: $_guests'),
            Text('Table: $_selectedTable'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedDate = DateTime.now();
      _selectedTime = null;
      _selectedDishes.clear();
      _guests = 2;
      _selectedTable = 1;
      _notesController.clear();
    });
  }

  void _cancelReservation(Reservation reservation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la réservation'),
        content: Text('Êtes-vous sûr de vouloir annuler cette réservation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Oui'),
          ),
        ],
      ),
    );

    if (confirmed == true && reservation.id != null) {
      setState(() => _isLoading = true);

      try {
        final success = await DatabaseService.deleteReservation(reservation.id!);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Réservation annulée avec succès')),
          );
          _loadReservations();
        } else {
          _showErrorDialog('Une erreur est survenue lors de l\'annulation.');
        }
      } catch (e) {
        _showErrorDialog('Erreur: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isCheckingReservations
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Réserver une table',
                          style: GoogleFonts.cairo(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        if (_isLoggedIn)
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AllReservationsScreen()),
                              );
                            },
                            icon: Icon(Icons.list_alt),
                            label: Text('Toutes les réservations'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Calendar section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calendrier des réservations',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 12),
                            TableCalendar(
                              firstDay: DateTime.now(),
                              lastDay: DateTime.now().add(Duration(days: 90)),
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              availableCalendarFormats: const {
                                CalendarFormat.month: 'Mois',
                                CalendarFormat.twoWeeks: '2 semaines',
                                CalendarFormat.week: 'Semaine',
                              },
                              onFormatChanged: (format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              },
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDate, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDate = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                                _updateUnavailableTables();
                              },
                              eventLoader: (day) {
                                return _getReservationsForDay(day);
                              },
                              calendarStyle: CalendarStyle(
                                markersMaxCount: 3,
                                markerDecoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Show reservations for selected day
                            if (_isLoggedIn) ...[
                              Divider(),
                              Text(
                                'Vos réservations pour ${DateFormat('dd/MM/yyyy').format(_selectedDate)}:',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              _buildReservationsList(),
                            ],
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Reservation form
                    Form(
                      key: _formKey,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nouvelle réservation',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 16),

                              // Selected date display
                              Text(
                                'Date sélectionnée: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),

                              // Time selection
                              Text('Heure',
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 60,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: _timeSlots.map((time) {
                                    final isSelected = _selectedTime == time;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() => _selectedTime = time);
                                          _updateUnavailableTables();
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.surface,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).dividerColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              time,
                                              style: TextStyle(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: 16),

                              // Number of guests
                              Row(
                                children: [
                                  Text('Nombre de personnes: ',
                                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: _guests > 1
                                        ? () => setState(() => _guests--)
                                        : null,
                                  ),
                                  Text('$_guests'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: _guests < 10
                                        ? () => setState(() => _guests++)
                                        : null,
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),

                              // Multi-dish selection
                              Text('Sélection des plats',
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              // list of categories with checkboxes
                              ..._dishCategories.entries.map((entry) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.key,
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                                    ...entry.value.map((dish) {
                                      final selected = _selectedDishes.contains(dish);
                                      return CheckboxListTile(
                                        value: selected,
                                        title: Text(dish),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              _selectedDishes.add(dish);
                                            } else {
                                              _selectedDishes.remove(dish);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                              // Validator: ensure at least one dish selected
                              if (_selectedDishes.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Veuillez sélectionner au moins un plat',
                                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                                  ),
                                ),

                              SizedBox(height: 16),

                              // Table selection
                              Text('Table',
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(8, (index) {
                                  final tableNumber = index + 1;
                                  final isSelected = _selectedTable == tableNumber;
                                  final isTaken = _unavailableTables.contains(tableNumber);
                                  return InkWell(
                                    onTap: isTaken ? null : () {
                                      setState(() => _selectedTable = tableNumber);
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isTaken
                                            ? Colors.grey.shade400
                                            : (isSelected
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.surface),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isTaken
                                              ? Colors.grey
                                              : (isSelected
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).dividerColor),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$tableNumber',
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            color: isTaken
                                                ? Colors.grey.shade700
                                                : (isSelected
                                                    ? Colors.white
                                                    : Theme.of(context).colorScheme.onSurface),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              SizedBox(height: 16),

                              // Notes
                              Text('Notes (optionnel)',
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _notesController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Spécifications alimentaires, allergies, etc.',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              SizedBox(height: 24),

                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submitReservation,
                                  child: _isLoading
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text('Confirmer la réservation'),
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
            ),
    );
  }

  Widget _buildReservationsList() {
    final reservationsForDay = _getReservationsForDay(_selectedDate);

    if (reservationsForDay.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Aucune réservation pour ce jour'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reservationsForDay.length,
      itemBuilder: (context, index) {
        final reservation = reservationsForDay[index];
        return ListTile(
          leading: Icon(Icons.restaurant),
          title: Text('${reservation.time} - Table ${reservation.tableNumber}'),
          subtitle: Text('${reservation.guests} personnes - ${reservation.dish}'),
          trailing: IconButton(
            icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
            onPressed: () => _cancelReservation(reservation),
          ),
        );
      },
    );
  }
}
