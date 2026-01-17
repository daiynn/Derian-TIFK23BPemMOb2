import 'package:flutter/material.dart';
import 'package:tugasku/db/db_helper.dart';
import 'package:tugasku/models/tugas.dart';
import 'package:tugasku/halaman/add_tugas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Tugas> daftarTugas = [];

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    final data = await DBHelper.instance.getAll("tasks");
    setState(() {
      daftarTugas = data
          .map(
            (e) => Tugas(
              id: e['id'],
              title: e['title'],
              description: e['description'],
              isDone: e['isDone'],
              createdAt: e['createdAt'],
            ),
          )
          .toList();
    });
  }

  Future<void> _hapusTugas(int id) async {
    await DBHelper.instance.delete("tasks", id);
    _loadTugas();
  }

  Future<void> _toggleSelesai(Tugas tugas) async {
    tugas.isDone = tugas.isDone == 1 ? 0 : 1;
    await DBHelper.instance.update("tasks", tugas.toMap(), tugas.id!);
    _loadTugas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Tugas")),
      body: daftarTugas.isEmpty
          ? const Center(child: Text("Belum ada tugas."))
          : ListView.builder(
              itemCount: daftarTugas.length,
              itemBuilder: (context, index) {
                final item = daftarTugas[index];
                return Dismissible(
                  key: Key(item.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _hapusTugas(item.id!);
                  },
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(
                        decoration: item.isDone == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(item.description),
                    trailing: Checkbox(
                      value: item.isDone == 1,
                      onChanged: (_) => _toggleSelesai(item),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTugas(tugas: item),
                        ),
                      );
                      _loadTugas();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTugas()),
          );
          _loadTugas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
