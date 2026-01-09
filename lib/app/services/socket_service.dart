import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import '../config/environment.dart';
import '../helpers/shared_preferences.dart';
import '../helpers/console_print.dart';

class SocketService extends GetxService {
  late IO.Socket socket;

  // Reactive callbacks for events
  Rx<Map<String, dynamic>?> bookingCreatedEvent = Rx(null);
  Rx<Map<String, dynamic>?> bookingAcceptedEvent = Rx(null);
  Rx<Map<String, dynamic>?> bookingArrivedEvent = Rx(null);
  Rx<Map<String, dynamic>?> bookingStartedEvent = Rx(null);
  Rx<Map<String, dynamic>?> bookingCompletedEvent = Rx(null);

  RxBool isConnected = false.obs;

  /// Initialize and connect to Socket.IO server
  Future<void> connect() async {
    try {
      final technicianId = await SharedPrefsHelper.getString("employeeId");

      if (technicianId.isEmpty) {
        consolePrint("Socket: No technician ID found");
        return;
      }

      consolePrint("Socket: Connecting to ${Environment.baseUrl}");

      socket = IO.io(
        Environment.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      // Connection listeners
      socket.onConnect((_) {
        consolePrint("Socket: Connected");
        isConnected.value = true;

        // Join technician room
        _joinTechnicianRoom(technicianId);
      });

      socket.onDisconnect((_) {
        consolePrint("Socket: Disconnected");
        isConnected.value = false;
      });

      socket.onError((error) {
        consolePrint("Socket Error: $error");
      });

      socket.onReconnect((_) {
        consolePrint("Socket: Reconnected");
        isConnected.value = true;
        _joinTechnicianRoom(technicianId);
      });

      // ==================== EVENT LISTENERS ====================

      /// New booking created
      socket.on('booking_created', (data) {
        consolePrint("Socket: booking_created received: $data");
        bookingCreatedEvent.value = Map<String, dynamic>.from(data as Map);
      });

      /// Booking accepted (technician or system accepted)
      socket.on('booking_accepted', (data) {
        consolePrint("Socket: booking_accepted received: $data");
        bookingAcceptedEvent.value = Map<String, dynamic>.from(data as Map);
      });

      /// Technician arrived at location
      socket.on('booking_arrived', (data) {
        consolePrint("Socket: booking_arrived received: $data");
        bookingArrivedEvent.value = Map<String, dynamic>.from(data as Map);
      });

      /// Service started
      socket.on('booking_started', (data) {
        consolePrint("Socket: booking_started received: $data");
        bookingStartedEvent.value = Map<String, dynamic>.from(data as Map);
      });

      /// Service completed
      socket.on('booking_completed', (data) {
        consolePrint("Socket: booking_completed received: $data");
        bookingCompletedEvent.value = Map<String, dynamic>.from(data as Map);
      });

      // Now connect
      socket.connect();
    } catch (e) {
      consolePrint("Socket Connection Error: $e");
    }
  }

  /// Join technician-specific room
  void _joinTechnicianRoom(String technicianId) {
    try {
      socket.emit('join_room', {
        'userType': 'technician',
        'userId': technicianId,
      });
      consolePrint("Socket: Joined technician room for user: $technicianId");
    } catch (e) {
      consolePrint("Socket: Error joining room: $e");
    }
  }

  /// Check if socket is connected
  bool get connected => socket.connected;

  /// Disconnect socket
  void disconnect() {
    try {
      if (socket.connected) {
        socket.disconnect();
        isConnected.value = false;
        consolePrint("Socket: Manually disconnected");
      }
    } catch (e) {
      consolePrint("Socket Disconnect Error: $e");
    }
  }

  /// Cleanup
  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
