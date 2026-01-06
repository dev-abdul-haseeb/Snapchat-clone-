import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snapchat_copy/CameraScreen.dart';
import 'package:snapchat_copy/Data/Local/database_helper.dart';
import 'package:snapchat_copy/HomePage.dart';
import 'package:snapchat_copy/LoginPage.dart';
import 'package:snapchat_copy/MessagePage.dart';

class cameraPage extends StatefulWidget {
  final String username;

  cameraPage({required this.username});

  @override
  State<cameraPage> createState() => _cameraPageState();
}

class _cameraPageState extends State<cameraPage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [];

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> nonFriends = [];
  List<Map<String, dynamic>> sentRequests = [];
  List<Map<String, dynamic>> receivedRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() async {
    final db = DBManager.getInstance();
    final username = widget.username;
    friends = await db.getFriendsOf(username);
    nonFriends = await db.getNonFriendsOf(username);
    sentRequests = await db.getSentFriendRequests(username);
    receivedRequests = await db.getReceivedFriendRequests(username);

    setState(() {
      _pages.clear();
      _pages.addAll([
        getLocationScreen(),
        getMessageScreen(widget.username, friends),
        getCameraScreen(),
        getPeopleScreen(),
        getPlayScreen(),
      ]);
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: _selectedIndex == 1 || _selectedIndex==2
          ? showBar(context, widget.username, nonFriends, receivedRequests,sentRequests,loadInitialData)
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.yellow.shade600,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: ''),
        ],
      ),
    );
  }
}

AppBar showBar(
  BuildContext context,
  String username,
  List<Map<String, dynamic>> nonFriends,
  List<Map<String, dynamic>> receivedRequests,
    List<Map<String, dynamic>> sentRequests,
  VoidCallback onFriendUpdate,
) {
  return AppBar(
    leadingWidth: 90,
    leading: Row(
      children: [
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homePage()),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.person, color: Colors.black),
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.search, color: Colors.black),
      ],
    ),

    title: Text(
      'Chat',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.person_add, color: Colors.black),
        onPressed: () {
          showAddFriendSheet(context, username, nonFriends, receivedRequests,sentRequests,onFriendUpdate);
        },
      ),
      IconButton(
        icon: Icon(Icons.message, color: Colors.black),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>loginPage()));
        },
      ),
    ],
  );
}

Widget getMessageScreen(
    String currentUsername,
    List<Map<String, dynamic>> friends,
    ) {
  if (friends.isEmpty) {
    return Center(
      child: Text(
        "No friends yet.",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
  return ListView.builder(
    itemCount: friends.length,
    itemBuilder: (context, index) {
      final friend = friends[index];
      final firstName = friend['firstName'] ?? '';
      final lastName = friend['lastName'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      final iconLetter = firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';

      return Container(
        height: 70,
        child: Center(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.yellow.shade600,
              child: Text(
                iconLetter,
                style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              fullName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.message, size: 30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => messagePage(
                    user1: currentUsername,
                    user2: friend['username'],
                    firstName: friend['firstName'],
                    lastName: friend['lastName'] ?? '',
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}


Widget getPeopleScreen() {
  return Center(child: Text('People Page', style: TextStyle(fontSize: 24)));
}

Widget getCameraScreen() {
  return CameraScreen();
}

Widget getLocationScreen() {
  return Center(child: Text('Location Page', style: TextStyle(fontSize: 24)));
}

Widget getPlayScreen() {
  return Center(child: Text('Play Page', style: TextStyle(fontSize: 24)));
}

void showAddFriendSheet(
    BuildContext context,
    String currentUsername,
    List<Map<String, dynamic>> nonFriends,
    List<Map<String, dynamic>> receivedRequests,
    List<Map<String, dynamic>> sentRequests,
    VoidCallback onFriendUpdate,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:
        Colors.transparent, // Transparent to show rounded container
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.keyboard_arrow_down,
                                  size: 32, color: Colors.black54),
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Add Friends',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Requested',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, -4), // Top shadow
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 4), // Bottom shadow
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: sentRequests.length,
                          itemBuilder: (context, index) {
                            final user = sentRequests[index];
                            final firstName = user['firstName'] ?? '';
                            final lastName = user['lastName'] ?? '';
                            final iconLetter = firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : '?';
                            final fullName = '$firstName $lastName'.trim();

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: getRandomColor(),
                                  child: Text(
                                    iconLetter,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  fullName,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(user['username']),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    await DBManager.getInstance().acceptFriendRequest(
                                      sender: user['username'],    // the one who sent the request
                                      receiver: currentUsername,   // the one accepting it
                                    );
                                    Navigator.pop(context);
                                    onFriendUpdate(); // <-- refresh the lists
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(Icons.person_add, size: 24),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Added me',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, -4), // Top shadow
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 4), // Bottom shadow
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: receivedRequests.length,
                          itemBuilder: (context, index) {
                            final user = receivedRequests[index];
                            final firstName = user['firstName'] ?? '';
                            final lastName = user['lastName'] ?? '';
                            final iconLetter = firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : '?';
                            final fullName = '$firstName $lastName'.trim();

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: getRandomColor(),
                                  child: Text(
                                    iconLetter,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  fullName,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(user['username']),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    await DBManager.getInstance().acceptFriendRequest(
                                      sender: user['username'],    // the one who sent the request
                                      receiver: currentUsername,   // the one accepting it
                                    );
                                    Navigator.pop(context);
                                    onFriendUpdate(); // <-- refresh the lists
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(Icons.person_add, size: 24),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Find Friends',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, -4), // Top shadow
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 4), // Bottom shadow
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: nonFriends.length,
                          itemBuilder: (context, index) {
                            final user = nonFriends[index];
                            final firstName = user['firstName'] ?? '';
                            final lastName = user['lastName'] ?? '';
                            final iconLetter = firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : '?';
                            final fullName = '$firstName $lastName'.trim();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: getRandomColor(),
                                  child: Text(
                                    iconLetter,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  fullName,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(user['username']),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    await DBManager.getInstance().createFriend(
                                      user1: currentUsername,
                                      user2: user['username'],
                                    );
                                    Navigator.pop(context);
                                    onFriendUpdate();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(Icons.person_add, size: 24),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ]

            ),
          );
        },
      );
    },
  );
}

Color getRandomColor() {
  final List<Color> colors = [
    Colors.green.shade200,
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.yellow.shade200,
    Colors.brown.shade200,
  ];
  final random = Random();
  return colors[random.nextInt(colors.length)];
}
