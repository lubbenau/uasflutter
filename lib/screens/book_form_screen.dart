import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/book.dart';

class BookFormScreen extends StatefulWidget {
  final Book? book;
  final int? index;

  const BookFormScreen({super.key, this.book, this.index});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController authorCtrl;
  late TextEditingController yearCtrl;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.book?.title ?? '');
    authorCtrl = TextEditingController(text: widget.book?.author ?? '');
    yearCtrl = TextEditingController(
      text: widget.book?.year != null ? widget.book!.year.toString() : '',
    );
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(isEdit ? 'Edit Buku' : 'Tambah Buku'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleSection(isEdit),
                const SizedBox(height: 24),

                _inputField(
                  controller: titleCtrl,
                  label: 'Judul Buku',
                  icon: Icons.menu_book_rounded,
                  validator: (v) =>
                      v!.isEmpty ? 'Judul tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),

                _inputField(
                  controller: authorCtrl,
                  label: 'Penulis',
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v!.isEmpty ? 'Penulis tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),

                _inputField(
                  controller: yearCtrl,
                  label: 'Tahun Terbit',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v!.isEmpty ? 'Tahun tidak boleh kosong' : null,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3C72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _saveBook,
                    child: Text(
                      isEdit ? 'Update Buku' : 'Simpan Buku',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= SAVE BOOK =================
  void _saveBook() {
    if (!_formKey.currentState!.validate()) return;

    final newBook = Book(
      title: titleCtrl.text,
      author: authorCtrl.text,
      year: int.parse(yearCtrl.text),
    );

    final box = Hive.box<Book>('books');

    if (widget.book == null) {
      box.add(newBook);
    } else {
      box.putAt(widget.index!, newBook);
    }

    Navigator.pop(context);
  }

  /// ================= UI COMPONENTS =================
  Widget _titleSection(bool isEdit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEdit ? 'Edit Data Buku' : 'Tambah Buku Baru',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          isEdit
              ? 'Perbarui informasi buku'
              : 'Lengkapi data buku yang akan ditambahkan',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
