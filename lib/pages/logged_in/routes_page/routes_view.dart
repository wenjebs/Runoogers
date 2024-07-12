import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_generation_page.dart';

final List<String> savedRoutes = [
  'Route 1',
  'Route 2',
  'Route 3',
  // Add more routes as needed
];

class RoutesView extends StatelessWidget {
  const RoutesView({super.key});

  // Example list of saved routes. Replace this with your actual data source.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Routes'),
      ),
      body: ListView.builder(
        itemCount: savedRoutes.length,
        itemBuilder: (context, index) {
          // For each saved route, create a card.
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(savedRoutes[index]),
              // Add more details here, such as subtitle, leading, trailing, etc.
              onTap: () {
                // Handle the tap event. For example, navigate to the route's details page.
                print('Tapped on ${savedRoutes[index]}');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Route to route generation page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RoutesGenerationPage()));
        },
        label: const Text("Generate Route"),
      ),
    );
  }
}
