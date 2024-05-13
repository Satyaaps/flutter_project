import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(17, 17, 17, 1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => onTap(0),
            icon: Icon(Icons.people,
                color: currentIndex == 0 ? Colors.white : Colors.grey),
          ),
          IconButton(
            onPressed: () => onTap(1),
            icon: Icon(Icons.person_2,
                color: currentIndex == 1 ? Colors.white : Colors.grey),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// class BottomNavBar extends StatelessWidget {
//   void Function(int)? onTabchange;
//   BottomNavBar({super.key, required this.onTabchange, required List items});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: GNav(
//         color: Colors.grey,
//         activeColor: Colors.black,
//         backgroundColor: Colors.black,
//         mainAxisAlignment: MainAxisAlignment.center,
//         tabBackgroundColor: Color.fromARGB(255, 9, 9, 7),
//         tabBorderRadius: 16,
//         onTabChange: (value) => onTabchange!(value),
//         tabs: const [
//           GButton(icon: Icons.people, text: 'Anggota'),
//           GButton(icon: Icons.person_2, text: 'Profile')
//         ],
//       ),
//     );
//   }
// }

