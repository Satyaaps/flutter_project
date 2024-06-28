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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'ANGGOTA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFIL',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 255, 255, 0),
        onTap: navigateBottomBar,
        backgroundColor: Color.fromARGB(86, 0, 0, 0),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'MANPITSSS',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 0),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(17, 17, 17, 1),
        child: Column(
          children: [
            const DrawerHeader(
              child: Text(
                'MANPITSSS',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 0),
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
              icon: Icons.file_copy,
              text: 'Transaksi',
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
        iconColor: Color.fromARGB(255, 255, 255, 0),
        textColor: Color.fromARGB(255, 255, 255, 0),
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}
