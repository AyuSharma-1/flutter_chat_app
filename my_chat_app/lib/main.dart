import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/core/feature/chat/data/datasource/message_remote_data_source.dart';
import 'package:my_chat_app/core/feature/chat/data/repository/message_repository_impl.dart';
import 'package:my_chat_app/core/feature/chat/domain/usecase/fetch_message_use_case.dart';
import 'package:my_chat_app/core/feature/chat/presentation/bloc/chat_bloc.dart';
import 'package:my_chat_app/core/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:my_chat_app/core/feature/auth/data/repositiories/auth_repository_impl.dart';
import 'package:my_chat_app/core/feature/auth/domain/usecases/login_use_cases.dart';
import 'package:my_chat_app/core/feature/auth/domain/usecases/register_use_cases.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_chat_app/core/feature/conversation/data/datasource/conversation_remote_data_source.dart';
import 'package:my_chat_app/core/feature/conversation/data/repositories/conversation_repositoy_impl.dart';
import 'package:my_chat_app/core/feature/conversation/domain/usecases/fetch_conversation.use_case.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/bloc/coonversation_bloc.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/page/conversation_page.dart';
import 'package:my_chat_app/core/theme.dart';
import 'package:my_chat_app/core/feature/auth/presentation/pages/login_page.dart';
import 'package:my_chat_app/core/feature/auth/presentation/pages/register_page.dart';

void main() {
  final authRepository = AuthRepositoryImpl(
    authRemoteDataSource: AuthRemoteDataSource(),
  );
  final conversationRepository = ConversationRepositoryImpl(
    conversationRemoteDataSource: ConversationRemoteDataSource(),
  );
  final messageRepository = MessageRepositoryImpl(
    remoteDataSource: MessageRemoteDataSource(),
  );
  runApp(
    MyApp(
      authRepository: authRepository,
      conversationRepository: conversationRepository,
      messageRepository: messageRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationRepositoryImpl conversationRepository;
  final MessageRepositoryImpl messageRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.conversationRepository,
    required this.messageRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: RegisterUseCases(repository: authRepository),
            loginUseCase: LoginUseCases(repository: authRepository),
          ),
        ),
        BlocProvider(
          create: (_) => ConversationBloc(
            fetchConversationUseCase: FetchConversationUseCase(
              conversationRepository,
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            fetchMessageUseCase: FetchMessageUseCase(
              messageRepository: messageRepository,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo Ayush',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/conversationPage': (context) => ConversationPage(),
        },
      ),
    );
  }
}
