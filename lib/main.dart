import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista viva DMI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade100),
        useMaterial3: true,
      ),
      home: const ListaVivaPage(title: 'Equipo 10B — Tareas'),
    );
  }
}

class ListaVivaPage extends StatefulWidget {
  const ListaVivaPage({super.key, required this.title});

  final String title;

  @override
  State<ListaVivaPage> createState() => _ListaVivaPageState();
}

class _ListaVivaPageState extends State<ListaVivaPage> {
  bool _soloPendientes = false;

  final List<({String nombre, bool completada})> _tareas = [
    (nombre: 'Subir captura de la lista viva', completada: false),
    (nombre: 'Responder autoevaluación', completada: false),
    (nombre: 'Tarea 3', completada: false),
  ];

  void _agregar() {
    setState(() {
      _tareas.add((
      nombre: 'Tarea ${_tareas.length + 1}',
      completada: false,
      ));
    });
  }

  void _eliminar(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  void _reiniciar() {
    setState(() {
      _tareas.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    final completadasCount = _tareas.fold<int>(0, (acc, t) => acc + (t.completada ? 1 : 0));

    final tareasFiltradas = _soloPendientes
        ? _tareas.where((t) => !t.completada).toList()
        : _tareas;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reiniciar',
            onPressed: _reiniciar,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completadas: $completadasCount / ${_tareas.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    const Text('Solo pendientes'),
                    const SizedBox(width: 8),
                    Switch(
                      value: _soloPendientes,
                      onChanged: (val) {
                        setState(() {
                          _soloPendientes = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: tareasFiltradas.length,
              itemBuilder: (context, index) {
                final tarea = tareasFiltradas[index];

                final indexOriginal = _tareas.indexOf(tarea);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (bool? valor) {
                        setState(() {
                          _tareas[indexOriginal] = (
                          nombre: tarea.nombre,
                          completada: valor ?? false,
                          );
                        });
                      },
                    ),
                    title: Text(tarea.nombre),
                    trailing: IconButton(
                      tooltip: 'Eliminar',
                      onPressed: () => _eliminar(indexOriginal),
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Agregar'),
      ),
    );
  }
}