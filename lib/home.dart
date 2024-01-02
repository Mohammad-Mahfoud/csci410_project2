import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _cityController = TextEditingController();
  Map<String, dynamic> weatherData = {};
  String username = '';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final apiUrl = 'https://skypulse.000webhostapp.com/retrieveUsername.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ensure that the 'username' key exists in the response data
        if (responseData.containsKey('username')) {
          setState(() {
            username = responseData['username'];
          });
        } else {
          print('Username not found in the response data.');
        }
      } else {
        print('Failed to fetch username. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildWeatherIcon(String description) {
    IconData iconData;
    Color iconColor;

    switch (description.toLowerCase()) {
      case 'clear sky':
        iconData = Icons.wb_sunny;
        iconColor = Colors.yellow;
        break;
      case 'few clouds':
      case 'scattered clouds':
        iconData = Icons.cloud;
        iconColor = Colors.grey;
        break;
      case 'broken clouds':
      case 'overcast clouds':
        iconData = Icons.cloud_queue;
        iconColor = Colors.grey;
        break;
      case 'light rain':
      case 'moderate rain':
      case 'heavy intensity rain':
        iconData = Icons.beach_access;
        iconColor = Colors.teal;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.yellow;
    }

    return Icon(iconData, size: 48, color: iconColor);
  }

  Future<void> _fetchWeather() async {
    final apiUrl = 'https://skypulse.000webhostapp.com/apiCode.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'city': _cityController.text.trim()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('error')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('City not found. Please enter a valid city name.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          setState(() {
            weatherData = responseData;
          });
        }
      } else {
        print(
            'Failed to fetch weather data. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App - $username'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: 'Enter City',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _fetchWeather();
                        },
                        child: Text('Search'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (weatherData.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        _buildWeatherIcon(weatherData['description']),
                        SizedBox(height: 8),
                        Text(
                          'Temperature: ${weatherData['temperature'].toStringAsFixed(2)} °C',
                        ),
                        SizedBox(height: 8),
                        Text('Humidity: ${weatherData['humidity']}%'),
                        SizedBox(height: 8),
                        Text('Description: ${weatherData['description']}'),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Sidebar Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Username: $username'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
