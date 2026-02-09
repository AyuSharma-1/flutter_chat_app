import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_chat_app/core/feature/chat/presentation/pages/chat_page.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/bloc/conversaation_event.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/bloc/conversation_state.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/bloc/coonversation_bloc.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  Future<void> storageToken() async {
    final strorage = FlutterSecureStorage();
    final list = await strorage.readAll();
  }

  @override
  void initState() {
    super.initState();
    storageToken();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversation',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: const Color(0xff47526d)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Recent',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Container(
              height: 100,
              padding: EdgeInsets.all(5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecentContact("Ayush", context),
                  _buildRecentContact("Ayush1", context),
                  _buildRecentContact("Ayush2", context),
                  _buildRecentContact("Ayush3", context),
                  _buildRecentContact("Ayush4", context),
                  _buildRecentContact("Ayush5", context),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff292F3F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ConversationLoaded) {
                      return ListView.builder(
                        itemCount: state.conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = state.conversations[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    conversationId: conversation.id,
                                    mate: conversation
                                        .participants
                                        .first
                                        .username,
                                  ),
                                ),
                              );
                            },
                            child: _buildMessageTile(
                              conversation.participants.first.username,
                              conversation.lastMessage.content,
                              conversation.updatedAt.toString(),
                            ),
                          );
                        },
                      );
                    } else if (state is ConversationError) {
                      return Center(child: Text(state.message));
                    }
                    return Center(child: Text("No Conversations found"));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(String name, String message, String time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildRecentContact(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(height: 5),
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
