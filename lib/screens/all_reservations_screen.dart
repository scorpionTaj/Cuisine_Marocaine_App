import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';
import '../services/database_service.dart';

class AllReservationsScreen extends StatefulWidget {
  @override
  _AllReservationsScreenState createState() => _AllReservationsScreenState();
}

class _AllReservationsScreenState extends State<AllReservationsScreen> {
  List<Reservation> _allReservations = [];
  bool _isLoading = true;
  String? _filterDate;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoading = true);

    try {
      final reservationsData = await DatabaseService.getAllReservations();
      setState(() {
        _allReservations = reservationsData.map((data) => Reservation.fromMap(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading all reservations: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Reservation> get _filteredReservations {
    if (_filterDate == null) {
      return _allReservations;
    } else {
      return _allReservations.where((res) => res.date == _filterDate).toList();
    }
  }

  List<String> get _availableDates {
    final dates = _allReservations.map((res) => res.date).toSet().toList();
    dates.sort();
    return dates;
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toutes les Réservations'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadReservations,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDateFilter(),
                ),
                Expanded(
                  child: _filteredReservations.isEmpty
                      ? Center(
                          child: Text(
                            'Aucune réservation trouvée',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredReservations.length,
                          itemBuilder: (context, index) {
                            return _buildReservationCard(_filteredReservations[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildDateFilter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrer par date',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: _availableDates.isEmpty
                  ? Text('Aucune date disponible')
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text('Toutes'),
                            selected: _filterDate == null,
                            onSelected: (_) {
                              setState(() {
                                _filterDate = null;
                              });
                            },
                          ),
                        ),
                        ..._availableDates.map(
                          (date) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(_formatDate(date)),
                              selected: _filterDate == date,
                              onSelected: (_) {
                                setState(() {
                                  _filterDate = date;
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
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _formatDate(reservation.date),
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time,
                  color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  reservation.time,
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Icon(Icons.person,
                  color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Réservé par: ${reservation.username}',
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant,
                  color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Expanded(child: Text(reservation.dish)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people,
                  color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text('${reservation.guests} personnes'),
                const SizedBox(width: 16),
                Icon(Icons.table_bar,
                  color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text('Table ${reservation.tableNumber}'),
              ],
            ),
            if (reservation.notes != null && reservation.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${reservation.notes}',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
