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
  late TextEditingController descriptionCtrl;
  late TextEditingController categoryCtrl;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Categories untuk dropdown
  final List<String> categories = [
    'Pekerjaan',
    'Pribadi',
    'Belanja',
    'Kesehatan',
    'Pendidikan',
    'Keuangan',
    'Lainnya',
  ];

  // Priority levels
  final List<String> priorities = ['Rendah', 'Sedang', 'Tinggi', 'Urgent'];
  String selectedPriority = 'Sedang';
  String selectedCategory = 'Pribadi';

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.book?.title ?? '');
    authorCtrl = TextEditingController(text: widget.book?.author ?? '');
    yearCtrl = TextEditingController(
      text: widget.book?.year != null ? widget.book!.year.toString() : '',
    );
    descriptionCtrl = TextEditingController();
    categoryCtrl = TextEditingController();
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    yearCtrl.dispose();
    descriptionCtrl.dispose();
    categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C5CE7),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D3748),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6C5CE7), Color(0xFFE8B4F7), Color(0xFFF5D4F7)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(isEdit),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildFormCard(isEdit),
                        const SizedBox(height: 20),
                        _buildSaveButton(isEdit),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= CUSTOM APP BAR =================
  Widget _buildAppBar(bool isEdit) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Catatan' : 'Tambah Catatan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isEdit ? 'Perbarui catatan Anda' : 'Buat catatan baru',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= FORM CARD =================
  Widget _buildFormCard(bool isEdit) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Header
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF8B7EF5)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Title Section
          Text(
            isEdit ? 'Edit Informasi Catatan' : 'Informasi Catatan Baru',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C5CE7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lengkapi form di bawah ini',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),

          const SizedBox(height: 24),

          // Form Fields
          _buildInputField(
            controller: titleCtrl,
            label: 'Judul Catatan',
            icon: Icons.title_rounded,
            hint: 'Masukkan judul catatan',
            validator: (v) => v!.isEmpty ? 'Judul tidak boleh kosong' : null,
          ),

          const SizedBox(height: 16),

          _buildInputField(
            controller: descriptionCtrl,
            label: 'Deskripsi / Isi Catatan',
            icon: Icons.description_outlined,
            hint: 'Tulis isi catatan Anda disini...',
            maxLines: 4,
            validator: (v) =>
                v!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
          ),

          const SizedBox(height: 16),

          // Category Dropdown
          _buildDropdownField(
            label: 'Kategori',
            icon: Icons.category_outlined,
            value: selectedCategory,
            items: categories,
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          // Priority Dropdown
          _buildDropdownField(
            label: 'Prioritas',
            icon: Icons.flag_outlined,
            value: selectedPriority,
            items: priorities,
            onChanged: (value) {
              setState(() {
                selectedPriority = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          // Date Picker
          _buildDatePicker(context),

          const SizedBox(height: 16),

          _buildInputField(
            controller: authorCtrl,
            label: 'Dibuat Oleh',
            icon: Icons.person_outline_rounded,
            hint: 'Nama pembuat catatan',
            validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
          ),

          const SizedBox(height: 16),

          _buildInputField(
            controller: yearCtrl,
            label: 'Tag / Label',
            icon: Icons.label_outline,
            hint: 'Contoh: Meeting, Reminder, Todo',
          ),
        ],
      ),
    );
  }

  /// ================= DATE PICKER =================
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF6C5CE7),
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Pilih tanggal',
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedDate != null
                          ? const Color(0xFF2D3748)
                          : Colors.grey[400],
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF6C5CE7)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ================= DROPDOWN FIELD =================
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6C5CE7)),
              style: const TextStyle(fontSize: 15, color: Color(0xFF2D3748)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: const Color(0xFF6C5CE7), size: 22),
                      const SizedBox(width: 12),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  /// ================= INPUT FIELD =================
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(icon, color: const Color(0xFF6C5CE7), size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F6FA),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: maxLines > 1 ? 16 : 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= SAVE BUTTON =================
  Widget _buildSaveButton(bool isEdit) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8B7EF5)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveBook,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_rounded, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    isEdit ? 'Update Catatan' : 'Simpan Catatan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// ================= SAVE BOOK =================
  void _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulasi loading
      await Future.delayed(const Duration(milliseconds: 500));

      // Untuk sementara tetap pakai model Book yang lama
      // Nanti bisa dibuat model Note baru jika diperlukan
      final newBook = Book(
        title: titleCtrl.text,
        author: authorCtrl.text,
        year: DateTime.now().year, // Gunakan tahun sekarang
      );

      final box = Hive.box<Book>('books');

      if (widget.book == null) {
        await box.add(newBook);
      } else {
        await box.putAt(widget.index!, newBook);
      }

      if (!mounted) return;

      setState(() => _isLoading = false);
      Navigator.pop(context);

      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.book == null
                ? 'Catatan berhasil disimpan!'
                : 'Catatan berhasil diupdate!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);

      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}

