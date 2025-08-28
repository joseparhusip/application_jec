// lib/pages/konsultasi_page.dart (LENGKAP DAN DIPERBAIKI)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import ini akan digunakan oleh ChatBubble
import 'package:skeletonizer/skeletonizer.dart';
import '../models/chat_message_models.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  State<KonsultasiPage> createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages = [
            ChatMessage(
              text:
                  "Halo! Selamat datang di layanan konsultasi kami. Ada yang bisa saya bantu?",
              isFromUser: false,
              timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            ),
          ];
          _isLoading = false;
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text.trim(),
        isFromUser: true,
        timestamp: DateTime.now(),
      ));
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text:
              "Terima kasih atas pertanyaan Anda. Tim konsultan kami akan segera merespons.",
          isFromUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _makePhoneCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memulai panggilan suara...')),
    );
  }

  void _makeVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memulai video call...')),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informasi Konsultasi'),
          content: const Text(
            'Layanan konsultasi tersedia 24/7.\n\n'
            'Tim konsultan profesional kami siap membantu Anda dengan berbagai pertanyaan dan kebutuhan.\n\n'
            'Waktu respons rata-rata: 5-10 menit.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Konsultasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: _makePhoneCall,
            tooltip: 'Panggilan Suara',
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: _makeVideoCall,
            tooltip: 'Video Call',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? colorScheme.surfaceContainerHighest
                  // --- DIPERBAIKI: Menggunakan .withAlpha() ---
                  : colorScheme.primary.withAlpha(26),
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Tim Konsultan Online',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Skeletonizer(
              enabled: _isLoading,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _isLoading ? 5 : _messages.length,
                itemBuilder: (context, index) {
                  final message =
                      _isLoading ? ChatMessage.skeleton() : _messages[index];
                  if (_isLoading && index.isEven) {
                    return ChatBubble(
                        message: ChatMessage(
                            text: 'user message',
                            isFromUser: true,
                            timestamp: DateTime.now()));
                  }
                  return ChatBubble(message: message);
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  // --- DIPERBAIKI: Menggunakan .withAlpha() ---
                  color: Colors.black.withAlpha(13),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan Anda...',
                          hintStyle: TextStyle(
                              color: colorScheme.onSurface.withAlpha(128)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(color: colorScheme.onSurface),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: colorScheme.onPrimary),
                      onPressed: _sendMessage,
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// --- WIDGET YANG HILANG DITAMBAHKAN KEMBALI ---
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.secondaryContainer,
              child: Icon(
                Icons.support_agent,
                size: 16,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isFromUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isFromUser
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: message.isFromUser
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: message.isFromUser
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13), // Juga diperbaiki di sini
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isFromUser
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // Penggunaan DateFormat dari package intl
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(153),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.tertiaryContainer,
              child: Icon(
                Icons.person,
                size: 16,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}