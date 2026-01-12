import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';
import 'book_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGrid = false;

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Future<void> _openWhatsApp() async {
    final url = Uri.parse(
      'https://wa.me/6281806057610?text=Halo%20admin%20perpustakaan',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEmail() async {
    final email = Uri(
      scheme: 'mailto',
      path: 'lursenucen@gmail.com',
      query: 'subject=Pertanyaan Aplikasi Perpustakaan',
    );
    await launchUrl(email);
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Book>('books');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Perpustakaan'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.chat), onPressed: _openWhatsApp),
          IconButton(icon: const Icon(Icons.email), onPressed: _openEmail),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => isGrid = !isGrid),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Buku'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookFormScreen()),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Book> books, _) {
          if (books.isEmpty) {
            return const Center(child: Text('Belum ada buku'));
          }

          return isGrid
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: books.length,
                  itemBuilder: (_, i) => _bookCard(books, i),
                )
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (_, i) => _bookCard(books, i),
                );
        },
      ),
    );
  }

  Widget _bookCard(Box<Book> box, int index) {
    final book = box.getAt(index)!;

    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(book.title),
        subtitle: Text(book.author),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => box.deleteAt(index),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookFormScreen(book: book, index: index),
          ),
        ),
      ),
    );
  }
}
