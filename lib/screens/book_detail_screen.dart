import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';
import 'book_form_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Detail Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookFormScreen(book: book)),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _headerSection(),
            const SizedBox(height: 20),
            _detailCard(),
            const SizedBox(height: 24),
            _actionButtons(), // ✅ FITUR INOVATIF
          ],
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(Icons.menu_book_rounded, size: 80, color: Color(0xFF1E3C72)),
          SizedBox(height: 12),
          Text(
            'Informasi Buku',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// ================= DETAIL CARD =================
  Widget _detailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _detailItem(
            icon: Icons.book_outlined,
            label: 'Judul',
            value: book.title,
          ),
          const Divider(height: 30),
          _detailItem(
            icon: Icons.person_outline,
            label: 'Penulis',
            value: book.author,
          ),
          const Divider(height: 30),
          _detailItem(
            icon: Icons.calendar_today_outlined,
            label: 'Tahun Terbit',
            value: book.year.toString(),
          ),
        ],
      ),
    );
  }

  /// ================= ACTION BUTTONS =================
  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.chat_rounded),
            label: const Text('Whatsapp'),
            onPressed: () async {
              final uri = Uri.parse(
                'https://wa.me/6281806057610?text=Halo,%20saya%20ingin%20menanyakan%20tentang%20buku%20${book.title}',
              );
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.email),
            label: const Text('Email'),
            onPressed: () async {
              final uri = Uri.parse(
                'mailto:lursenucen@gmail.com?subject=Informasi Buku&body=Saya tertarik dengan buku ${book.title}',
              );
              await launchUrl(uri);
            },
          ),
        ),
      ],
    );
  }

  /// ================= DETAIL ITEM =================
  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1E3C72)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
