class Reservation {
  final int? id;
  final String username;
  final String date;
  final String time;
  final int guests;
  final String dish;
  final int tableNumber;
  final String? notes;

  Reservation({
    this.id,
    required this.username,
    required this.date,
    required this.time,
    required this.guests,
    required this.dish,
    required this.tableNumber,
    this.notes,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      username: map['username'],
      date: map['date'],
      time: map['time'],
      guests: map['guests'],
      dish: map['dish'],
      tableNumber: map['table_number'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'date': date,
      'time': time,
      'guests': guests,
      'dish': dish,
      'table_number': tableNumber,
      'notes': notes,
    };
  }

  String get formattedInfo {
    return '$time - $guests personnes - $dish';
  }
}
