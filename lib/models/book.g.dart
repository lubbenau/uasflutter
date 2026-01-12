// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    return Book(
      title: reader.readString(),
      author: reader.readString(),
      year: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeString(obj.title)
      ..writeString(obj.author)
      ..writeInt(obj.year);
  }
}
