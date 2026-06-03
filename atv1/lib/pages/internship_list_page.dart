import 'package:atv1/controllers/internship_controller.dart';
import 'package:atv1/models/internship_model.dart';
import 'package:atv1/pages/internship_form_page.dart';
import 'package:flutter/material.dart';

class InternshipListPage extends StatefulWidget {
  const InternshipListPage({super.key});

  @override
  State<InternshipListPage> createState() => _InternshipListPageState();
}

class _InternshipListPageState extends State<InternshipListPage> {
  final sqlInternshipController _controller = sqlInternshipController();
  late Future<List<internship>> _internshipsFuture;

  @override
  void initState() {
    super.initState();
    _loadInternships();
  }

  void _loadInternships() {
    _internshipsFuture = _controller.get_internships();
  }

  Future<void> _refreshInternships() async {
    setState(_loadInternships);
    await _internshipsFuture;
  }

  Future<void> _openForm({internship? selectedInternship}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            InternshipFormPage(internshipToEdit: selectedInternship),
      ),
    );

    if (saved == true && mounted) {
      _refreshInternships();
    }
  }

  Future<void> _confirmDelete(internship selectedInternship) async {
    final id = selectedInternship.internship_id;
    if (id == null) {
      _showMessage('Nao foi possivel excluir este estagio.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir estagio'),
          content: Text(
            'Deseja excluir o estagio de ${selectedInternship.student_name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _controller.delete_internship(id);
      if (!mounted) return;
      _showMessage('Estagio excluido.');
      _refreshInternships();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estagios'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _refreshInternships,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<internship>>(
        future: _internshipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _InternshipMessage(
              icon: Icons.error_outline,
              title: 'Erro ao carregar estagios',
              message: snapshot.error.toString(),
            );
          }

          final internships = snapshot.data ?? [];
          if (internships.isEmpty) {
            return const _InternshipMessage(
              icon: Icons.work_outline,
              title: 'Nenhum estagio cadastrado',
              message: 'Toque em adicionar para criar o primeiro registro.',
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshInternships,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: internships.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = internships[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        item.student_name.trim().isEmpty
                            ? '?'
                            : item.student_name.trim()[0].toUpperCase(),
                      ),
                    ),
                    title: Text(item.student_name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.company_name),
                          Text('${item.location} - ${item.duration}'),
                        ],
                      ),
                    ),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: 'Editar',
                          onPressed: () => _openForm(selectedInternship: item),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Excluir',
                          onPressed: () => _confirmDelete(item),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }
}

class _InternshipMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _InternshipMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
