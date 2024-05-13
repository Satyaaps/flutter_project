import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/profile_page.dart';
import 'package:flutter_project/pages/team_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logger = Logger();
  final myStorage = GetStorage();
  int _selectedIndex = 0;

  void onLogOut() {
    Navigator.pushNamed(context, '/signIn');
  }

  Future<void> goLogOut() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://mobileapis.manpits.xyz/api/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      logger.i(response);
      if (response.statusCode == 200 || response.statusCode == 406) {
        Navigator.pushNamed(context, '/signIn');
        myStorage.remove('token');
      }
    } on DioError catch (e) {
      logger.e(e);
      Navigator.pushNamed(context, '/signIn');
      myStorage.remove('token');
    }
  }

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const TeamPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 17, 17, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: navigateBottomBar,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Firstore',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(17, 17, 17, 1),
        child: Column(
          children: [
            const DrawerHeader(
              child: Text(
                'Firstore',
                style: TextStyle(
                  color: Color.fromRGBO(215, 252, 112, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Home',
            ),
            _buildDrawerItem(
              icon: Icons.search,
              text: 'Search',
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
            ),
            GestureDetector(
              onTap: goLogOut,
              child: _buildDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        iconColor: Colors.white,
        textColor: Colors.white,
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}
