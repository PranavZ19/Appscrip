import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'user_provider.dart';
import 'user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(apiService: apiService),
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: UserListScreen(),
      ),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (userProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${userProvider.errorMessage}'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => userProvider.fetchUsers(),
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }

          final filteredUsers = userProvider.searchUsers(_searchQuery);

          return RefreshIndicator(
            onRefresh: () => userProvider.fetchUsers(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserDetailScreen(user: user),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final User user;
  const UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: ${user.phone}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Website: ${user.website}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
