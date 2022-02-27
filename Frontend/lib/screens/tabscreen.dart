import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackathon_app/Widget/app_drawer.dart';
import 'package:hackathon_app/screens/chatscreen.dart';
import 'package:hackathon_app/screens/main_screen.dart';
import 'package:hackathon_app/screens/news.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as Location;
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class TabScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TabScreen> {
  void _voiceNavigation(BuildContext context, String route) {
    // route_List.add(route);
    // print('length ${route_List.length}');

    // Navigator.of(context).popUntil(
    //     (route) => route.isFirst); //so that after pushing many pages we
    // // should not keep the record of previous page, and go to home directly
    Navigator.of(context).pushNamed('$route');
  }

  void _StateNavigation(BuildContext context, String route) {
    print("inside state navigation");
    // String str = "1-/mandi_detail-ANDHRA PRADESH";
    List<String> components = route.split("-");

    Navigator.of(context).pushNamed(
      components[1],
      arguments: {'state': components[2], 'index': components[0]},
    );
  }

  void _homeNavigation(BuildContext context, String route) {
    // print("voice");
    // route_List.clear();
    // print("route lenght: ${route_List.length}");

    Navigator.of(context).pushReplacementNamed('$route');
    Navigator.of(context).popUntil(
        (route) => route.isFirst); //so that after pushing many pages we
    // // should not keep the record of previous page, and go to home directly
  }

  // void _goBack(BuildContext context) {
  //   if (route_List.length != 0) {
  //     Navigator.of(context).pop();
  //   }

  //   print("routeleng: ${route_List.length}");
  //   if (route_List.length > 0) route_List = route_List.removeLast();
  //   print("route list");
  //   print(route_List);
  //   // print("voice");
  //   // print("route ${ModalRoute.of(context)?.settings.name}");
  // }

  void _handleCommand(Map<String, dynamic> command) {
    print("inside uipn ${ModalRoute.of(context)?.settings.name}");
    String toCompare = command["command"];
    print(toCompare);
    switch (toCompare) {
      case "0-/mandi_detail-ANDHRA PRADESH":
        _StateNavigation(context, toCompare);
        break;
      case "1-/mandi_detail-CHANDIGARH":
        _StateNavigation(context, toCompare);
        break;
      case "3-/mandi_detail-GUJARAT":
        _StateNavigation(context, toCompare);
        break;
      case "8-/mandi_detail-KARNATAKA":
        _StateNavigation(context, toCompare);
        break;
      case "11-/mandi_detail-MAHARASHTRA":
        _StateNavigation(context, toCompare);
        break;
      case "18-/mandi_detail-UTTAR PRADESH":
        _StateNavigation(context, toCompare);
        break;
      case "15-/mandi_detail-RAJASTHAN":
        _StateNavigation(context, toCompare);
        break;

      case "/contract_tab":
        _voiceNavigation(context, toCompare);
        break;
      case "/":
        _homeNavigation(context, toCompare);
        break;
      case "/mandi_prices":
        _voiceNavigation(context, toCompare);
        break;
      case "/marketplace":
        _voiceNavigation(context, toCompare);
        break;
      case "/gov_policies":
        _voiceNavigation(context, toCompare);
        break;
      default:
        print('Unkown Command');
    }
  }

  Future<void> getCord() async {
    final locData = await Location.Location().getLocation();
  }

  _HomePageState() {
    getCord();

    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
        "2e870022dcf118da4e44517598e3b6722e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;
  bool _showOnlyFav = false;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void initState() {
    _pages = [
      {
        //String: //Object
        'page': MainScreen(),
        'title': 'Dashboard',
      },
      {
        //String: //Object
        'page': News(),
        'title': 'Agro Feed',
      },
      {
        //String: //Object
        'page': ChatScreen(),
        'title': 'Chat with us',
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    // auth.getUser();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          _pages[_selectedPageIndex]['title'] as String,
          style: GoogleFonts.antic(fontSize: 23),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Logout Alert '),
                        content: Text('Do you wish to logout? '),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shadowColor: Colors.black),
                            onPressed: () {
                              auth.logout();
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal[800]),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          )
                        ],
                      ));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: AppDrawer(auth.username, auth.userEmail),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        // onTap: (index) {
        //   print(index);
        // }, //will automatically provide index
        onTap: _selectPage,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType
            .shifting, //adds slight animation to navigation bar

        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.lightGreen[700],
              icon: Icon(Icons.home_filled),
              title: Text(
                'Home',
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue[500],
              icon: Icon(Icons.fact_check_rounded),
              title: Text(
                'News',
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.red,
              icon: Icon(Icons.chat_bubble_outlined),
              title: Text('Chat')),
        ],
      ),
    );
  }
}
