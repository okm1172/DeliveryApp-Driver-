import 'package:flutter/material.dart';
import 'package:driverapp/global/global.dart';
import 'package:driverapp/splashScreen/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
//vsync는 애니메이션 최적화 및 언제 재생할지 시간을 세어주는 등의 기능을 위해 필요하다
//vsync를 사용해주기 위해 with Single..어쩌구저쩌구를 사용해줘야한다.
class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  TabController? tabController;
  int selectedIndex=0;

  onItemClicked(int index){
    setState(() {
      selectedIndex =index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return Scaffold(
      body: TabBarView(
          children: [],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Earnings"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Ratings"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label:"Account"),
          ],
          unselectedItemColor: darkTheme ? Colors.black54 : Colors.white54,
          selectedItemColor: darkTheme ? Colors.black : Colors.white,
          backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
