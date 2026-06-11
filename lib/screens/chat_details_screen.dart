import 'package:flutter/material.dart';
import 'package:whats_app_clone/models/chat_data_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({super.key, required this.chatData});
  final ChatDataModel chatData;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  // المحادثة الجديدة والمبتكرة المتناسقة مع التكليف البرمجي
final List<Map<String, dynamic>> _messages = [
  {"text": "مرحباً 👋 كيف كان يومك؟", "isMe": false, "time": "09:10 ص"},
  {"text": "كان جميل الحمدلله، اشتغلت على المشروع شوي.", "isMe": true, "time": "09:12 ص"},
  {"text": "حلو 👌 أي مشروع تشتغل عليه؟", "isMe": false, "time": "09:13 ص"},
  {"text": "تطبيق فلاتر بسيط، أتعلم فيه الـ UI أكثر.", "isMe": true, "time": "09:15 ص"},
  {"text": "ممتاز! واضح إنك تتقدم بسرعة 🚀", "isMe": false, "time": "09:16 ص"},
  {"text": "شكراً 🙏 أحاول أطور نفسي خطوة خطوة.", "isMe": true, "time": "09:18 ص"},
];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'م' : 'ص';
    final String currentTime = "$hour:$minute $period";

    setState(() {
      _messages.add({
        "text": _messageController.text.trim(),
        "isMe": true,
        "time": currentTime,
      });
      _messageController.clear();
      _isTyping = false;
    });
  }

  void _showFeatureSnackBar(String featureName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم فتح ميزة: $featureName بنجاح (جاري التطوير...)",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00A884),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            shrinkWrap: true,
            children: [
              _buildAttachmentItem(Icons.insert_drive_file, Colors.indigo, "مستند"),
              _buildAttachmentItem(Icons.camera_alt, Colors.pink, "كاميرا"),
              _buildAttachmentItem(Icons.image, Colors.purple, "المعرض"),
              _buildAttachmentItem(Icons.headset, Colors.orange, "صوت"),
              _buildAttachmentItem(Icons.location_on, Colors.green, "الموقع"),
              _buildAttachmentItem(Icons.person, Colors.blue, "جهة اتصال"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentItem(IconData icon, Color color, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showFeatureSnackBar(title);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            title, 
            style: const TextStyle(
              color: Colors.white70, 
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B141A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(widget.chatData.imagePath),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatData.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    "متصل الآن",
                    style: TextStyle(color: Color(0xFF00A884), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () => _showFeatureSnackBar("مكالمة فيديو مع ${widget.chatData.name}"),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () => _showFeatureSnackBar("مكالمة صوتية مع ${widget.chatData.name}"),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF1F2C34),
            onSelected: (value) => _showFeatureSnackBar(value),
            itemBuilder: (BuildContext context) {
              return {'عرض جهة الاتصال', 'الوسائط والمستندات', 'بحث', 'كتم الإشعارات', 'خلفية الشاشة'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice, style: const TextStyle(color: Colors.white)),
                );
              }).toList();
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isMe = message["isMe"];

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF005C4B) : const Color(0xFF1F2C34),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                        bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message["text"],
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message["time"],
                          style: const TextStyle(color: Colors.white60, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2C34),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white60),
                          onPressed: () => _showFeatureSnackBar("لوحة الإيموجي"),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (text) {
                              setState(() {
                                _isTyping = text.trim().isNotEmpty;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "مراسلة",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file, color: Colors.white60),
                          onPressed: _showAttachmentBottomSheet,
                        ),
                        if (!_isTyping) ...[
                          IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white60),
                            onPressed: () => _showFeatureSnackBar("كاميرا التصوير"),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: _isTyping ? _sendMessage : () => _showFeatureSnackBar("تسجيل الصوت الحالي"),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF00A884),
                    child: Icon(
                      _isTyping ? Icons.send : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}