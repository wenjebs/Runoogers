import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_generation_page.dart';

class RoutesView extends StatelessWidget {
  const RoutesView({super.key});

  // Example list of saved routes. Replace this with your actual data source.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Routes'),
      ),
      body: FutureBuilder(
        future: Repository.getSavedRoutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<RouteModel> routes = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(routes[index].distance),
                  onTap: () {
                    // Route to route details page
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const RoutesDetailsPage()));
                  },
                );
              },
            );
          }
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
