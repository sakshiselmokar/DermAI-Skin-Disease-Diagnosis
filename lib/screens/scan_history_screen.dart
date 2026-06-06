import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermai/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({Key? key}) : super(key: key);

  static const Map<String, String> _emojiMap = {
    'acne': '🔴', 'rosacea': '🔴',
    'eczema': '🌿',
    'melanoma': '⚠️', 'nevi': '⚠️', 'moles': '⚠️',
    'nail': '💅', 'fungus': '💅',
    'psoriasis': '🧴', 'lichen': '🧴',
  };

  String _emoji(String label) {
    final lower = label.toLowerCase();
    for (final key in _emojiMap.keys) {
      if (lower.contains(key)) return _emojiMap[key]!;
    }
    return '🔬';
  }

  Color _confidenceColor(double conf) {
    if (conf >= 0.7) return Colors.green.shade600;
    if (conf >= 0.45) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  String _timeAgo(Timestamp? ts) {
    if (ts == null) return 'Just now';
    final dt = ts.toDate();
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scan History',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: uid == null
          ? const Center(child: Text('Please sign in to view history.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('scan_history')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: c));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('No scans yet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
                        const SizedBox(height: 8),
                        Text('Your diagnosis history will appear here.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final label = data['label'] as String? ?? 'Unknown';
                    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;
                    final timestamp = data['timestamp'] as Timestamp?;
                    final percent = '${(confidence * 100).toStringAsFixed(1)}%';

                    return Dismissible(
                      key: Key(docs[i].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      ),
                      onDismissed: (_) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('scan_history')
                            .doc(docs[i].id)
                            .delete();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))
                          ],
                        ),
                        child: Row(children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: const Color(0xFFF0FFF6), borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text(_emoji(label), style: const TextStyle(fontSize: 24))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(label,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                                    maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: confidence.clamp(0.0, 1.0),
                                    minHeight: 4,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(_confidenceColor(confidence)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(percent,
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                                      color: _confidenceColor(confidence))),
                              const SizedBox(height: 4),
                              Text(_timeAgo(timestamp),
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                            ],
                          ),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
