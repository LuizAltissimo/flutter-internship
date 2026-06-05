import 'package:atv1/controllers/internship_controller.dart';
import 'package:atv1/models/internship_model.dart';
import 'package:atv1/pages/internship_form_page.dart';
import 'package:atv1/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class InternshipListPage extends StatefulWidget {
  const InternshipListPage({super.key});

  @override
  State<InternshipListPage> createState() => _InternshipListPageState();
}

class _InternshipListPageState extends State<InternshipListPage> {
  final SqlInternshipController _controller = SqlInternshipController();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Internship>> _internshipsFuture;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchTerm = _searchController.text.trim());
    });
    _loadInternships();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInternships() {
    _internshipsFuture = _controller.getInternships();
  }

  Future<void> _refreshInternships() async {
    setState(_loadInternships);
    await _internshipsFuture;
  }

  Future<void> _openForm({Internship? selectedInternship}) async {
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

  Future<void> _confirmDelete(Internship selectedInternship) async {
    final id = selectedInternship.internshipId;
    if (id == null) {
      _showMessage('Nao foi possivel excluir este estagio.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
          title: const Text('Excluir estagio?'),
          content: Text(
            'O registro de ${selectedInternship.studentName} sera removido permanentemente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _controller.deleteInternship(id);
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

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void _openProfessors() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/professors');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        activeSection: AppSection.internships,
        onInternshipsSelected: _closeDrawer,
        onProfessorsSelected: _openProfessors,
      ),
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
      body: FutureBuilder<List<Internship>>(
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
              actionLabel: 'Tentar novamente',
              onAction: _refreshInternships,
            );
          }

          final internships = snapshot.data ?? [];
          if (internships.isEmpty) {
            return _InternshipMessage(
              icon: Icons.work_outline,
              title: 'Nenhum estagio cadastrado',
              message:
                  'Cadastre um estagio para acompanhar estudantes, empresas e duracao em um so lugar.',
              actionLabel: 'Adicionar estagio',
              onAction: () => _openForm(),
            );
          }

          final visibleInternships = internships.where((item) {
            final normalizedSearch = _searchTerm.toLowerCase();
            if (normalizedSearch.isEmpty) return true;

            return item.studentName.toLowerCase().contains(normalizedSearch) ||
                item.companyName.toLowerCase().contains(normalizedSearch) ||
                item.location.toLowerCase().contains(normalizedSearch) ||
                item.duration.toLowerCase().contains(normalizedSearch) ||
                // IA: busca agora inclui o nome do orientador vinculado ao estagio
                (item.advisorProfessorName?.toLowerCase().contains(normalizedSearch) ?? false);
          }).toList();

          return RefreshIndicator(
            onRefresh: _refreshInternships,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _InternshipOverview(internships: internships),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por estudante, empresa ou local',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchTerm.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar busca',
                            onPressed: _searchController.clear,
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                if (visibleInternships.isEmpty)
                  _InternshipMessage(
                    icon: Icons.search_off_outlined,
                    title: 'Nenhum resultado encontrado',
                    message:
                        'Revise o termo pesquisado para localizar o registro.',
                    actionLabel: 'Limpar busca',
                    onAction: _searchController.clear,
                  )
                else
                  ...visibleInternships.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _InternshipCard(
                        internshipItem: item,
                        onEdit: () => _openForm(selectedInternship: item),
                        onDelete: () => _confirmDelete(item),
                      ),
                    ),
                  ),
              ],
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

class _InternshipOverview extends StatelessWidget {
  final List<Internship> internships;

  const _InternshipOverview({required this.internships});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final companyCount = internships
        .map((item) => item.companyName.trim())
        .where((company) => company.isNotEmpty)
        .toSet()
        .length;
    final locationCount = internships
        .map((item) => item.location.trim())
        .where((location) => location.isNotEmpty)
        .toSet()
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assignment_turned_in_outlined,
                  color: colorScheme.onSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Controle de Estagios',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Visao geral dos registros cadastrados',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Estagios',
                  value: internships.length.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewMetric(
                  label: 'Empresas',
                  value: companyCount.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewMetric(
                  label: 'Locais',
                  value: locationCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.76),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InternshipCard extends StatelessWidget {
  final Internship internshipItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _InternshipCard({
    required this.internshipItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final studentName = internshipItem.studentName.trim();
    final initial = studentName.isEmpty ? '?' : studentName[0].toUpperCase();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              child: Text(
                initial,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    internshipItem.studentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _InfoLine(
                    icon: Icons.business_outlined,
                    text: internshipItem.companyName,
                  ),
                  const SizedBox(height: 4),
                  _InfoLine(
                    icon: Icons.location_on_outlined,
                    text: internshipItem.location,
                  ),
                  const SizedBox(height: 4),
                  _InfoLine(
                    icon: Icons.schedule_outlined,
                    text: internshipItem.duration,
                  ),
                  if (internshipItem.advisorProfessorName != null &&
                      internshipItem.advisorProfessorName!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    // IA: exibe o nome do professor orientador vinculado ao estagio na lista
                    _InfoLine(
                      icon: Icons.school_outlined,
                      text: internshipItem.advisorProfessorName!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Editar',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Excluir',
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, color: colorScheme.error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 17, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _InternshipMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _InternshipMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
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
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.arrow_forward),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
