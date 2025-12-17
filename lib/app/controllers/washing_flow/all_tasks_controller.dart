import 'package:get/get.dart';

class AllTasksController extends GetxController {
  var tasks = <Map<String, dynamic>>[
    {
      "time": "10:00 AM - 11:30 AM",
      "status": "IN PROGRESS",
      "name": "John Doe",
      "subtitle": "Tesla Model 3 · Grey",
      "service": "Premium Interior Detail",
      "address": "4582 Elm Street, CA",
      "btn": "Open Job",
      "btn_color": 0xFF2ECC71,
      "image": "https://i.imgur.com/51XWQDU.png",
    },
    {
      "time": "Today, 01:00 PM",
      "status": "PENDING",
      "name": "Sarah Smith",
      "subtitle": "BMW X5 · Black",
      "service": "Exterior Wash",
      "address": "102 Ocean Dr, Miami",
      "btn": "Start Travel",
      "btn_color": 0xFF2980B9,
      "image": "https://i.imgur.com/Wv2Qz4g.png",
    },
    {
      "time": "Tomorrow, 09:00 AM",
      "status": "SCHEDULED",
      "name": "Mike Johnson",
      "subtitle": "Ford F–150 · White",
      "service": "Full Detail",
      "address": "88 Sunset Blvd",
      "btn": "View Details",
      "btn_color": 0xFF8E44AD,
      "image": "https://i.imgur.com/ZIYkM5r.png",
    },
  ].obs;
}
