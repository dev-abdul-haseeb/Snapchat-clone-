import 'package:flutter/material.dart';
import 'package:snapchat_copy/Data/Local/database_helper.dart';

class messagePage extends StatefulWidget {
  final String user1;
  final String user2;
  final String firstName;
  final String? lastName; // <-- make this nullable
  

  const messagePage({
    required this.user1,
    required this.user2,
    required this.firstName,
    this.lastName,
    Key? key,
  }) : super(key: key);

  @override
  State<messagePage> createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 20,
              child: Text(
                widget.firstName.isNotEmpty
                    ? widget.firstName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.firstName} ${widget.lastName ?? ''}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),

            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.black, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call_rounded, color: Colors.black, size: 35),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          getMessages(widget.user1,widget.user2),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.yellow.shade600,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.black),
                      onPressed: () async {
                        final db = DBManager.getInstance();
                        final text = _messageController.text.trim();
                        if (text.isNotEmpty) {
                          await db.createMessage(
                            sender: widget.user1,
                            receiver: widget.user2,
                            message: text,
                          );
                          _messageController.clear(); // clear the input after sending
                          setState(() {}); // refresh the UI (reloads FutureBuilder)
                        }
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }
}

Widget getMessages(String user1, String user2) {
  return Expanded(
    child: FutureBuilder<List<Map<String, dynamic>>>(
      future: DBManager.getInstance().getMessagesBetweenUsers(user1, user2),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }

        final messages = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isSender = message['sender'] == user1;
            final text = message['message'] ?? '';

            return Align(
              alignment:
              isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSender
                      ? Colors.yellow.shade600
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSender ? Colors.black : Colors.black87,
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
