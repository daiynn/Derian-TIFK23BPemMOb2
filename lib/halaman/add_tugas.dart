import 'package:flutter/material.dart';
import 'package:tugasku/db/db_helper.dart';
import 'package:tugasku/models/tugas.dart';

class AddTugas extends StatefulWidget {
  final Tugas? tugas;
  const AddTugas({super.key, this.tugas});

  @override
  State<AddTugas> createState() => _AddTugasState();
}

class _AddTugasState extends State<AddTugas> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tugas != null) {
      titleCtrl.text = widget.tugas!.title;
      descCtrl.text = widget.tugas!.description;
    }
  }

  Future<void> _simpan() async {
    final title = titleCtrl.text.trim();
    final desc = descCtrl.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan Deskripsi tidak boleh kosong")),
      );
      return;
    }

    if (widget.tugas == null) {
      // CREATE
      await DBHelper.instance.insert(
        "tasks",
        Tugas(
          title: title,
          description: desc,
          createdAt: DateTime.now().toString(),
        ).toMap(),
      );
    } else {
      // UPDATE
      widget.tugas!.title = title;
      widget.tugas!.description = desc;
      await DBHelper.instance.update(
        "tasks",
        widget.tugas!.toMap(),
        widget.tugas!.id!,
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tugas != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Tugas" : "Tambah Tugas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Deskripsi"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simpan,
              child: Text(isEdit ? "Update" : "Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
