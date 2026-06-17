import 'package:atv1/controllers/advisor_professor_controller.dart';
import 'package:atv1/models/advisor_professor_model.dart';
import 'package:atv1/pages/advisor_professor_form_page.dart';
import 'package:atv1/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class AdvisorProfessorListPage extends StatefulWidget {
  const AdvisorProfessorListPage({super.key});

  @override
  State<AdvisorProfessorListPage> createState() =>
      _AdvisorProfessorListPageState();
}

class _AdvisorProfessorListPageState extends State<AdvisorProfessorListPage> {
  final SqlAdvisorProfessorController _controller =
      SqlAdvisorProfessorController();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<AdvisorProfessor>> _professorsFuture;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchTerm = _searchController.text.trim());
    });
    _loadProfessors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProfessors() {
    _professorsFuture = _controller.getProfessors();
  }

  Future<void> _refreshProfessors() async {
    setState(_loadProfessors);
    await _professorsFuture;
  }

  Future<void> _openForm({AdvisorProfessor? selectedProfessor}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            AdvisorProfessorFormPage(professorToEdit: selectedProfessor),
      ),
    );

    if (saved == true && mounted) {
      _refreshProfessors();
    }
  }

  Future<void> _confirmDelete(AdvisorProfessor selectedProfessor) async {
    final id = selectedProfessor.professorId;
    if (id == null) {
      _showMessage('Nao foi possivel excluir este professor.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
          title: const Text('Excluir professor?'),
          content: Text(
            'O cadastro de ${selectedProfessor.name} sera removido permanentemente.',
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
      await _controller.deleteProfessor(id);
      if (!mounted) return;
      _showMessage('Professor excluido.');
      _refreshProfessors();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openInternships() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/internships');
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void _openCompanies() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/companies');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        activeSection: AppSection.professors,
        onInternshipsSelected: _openInternships,
        onProfessorsSelected: _closeDrawer,
        onCompaniesSelected: _openCompanies,
      ),
      appBar: AppBar(
        title: const Text('Professores orientadores'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _refreshProfessors,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<AdvisorProfessor>>(
        future: _professorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ProfessorMessage(
              icon: Icons.error_outline,
              title: 'Erro ao carregar professores',
              message: snapshot.error.toString(),
              actionLabel: 'Tentar novamente',
              onAction: _refreshProfessors,
            );
          }

          final professors = snapshot.data ?? [];
          if (professors.isEmpty) {
            return _ProfessorMessage(
              icon: Icons.school_outlined,
              title: 'Nenhum professor cadastrado',
              message:
                  'Cadastre orientadores para organizar contatos e areas de acompanhamento dos estagios.',
              actionLabel: 'Adicionar professor',
              onAction: () => _openForm(),
            );
          }

          final visibleProfessors = professors.where((item) {
            final normalizedSearch = _searchTerm.toLowerCase();
            if (normalizedSearch.isEmpty) return true;

            return item.name.toLowerCase().contains(normalizedSearch) ||
                item.email.toLowerCase().contains(normalizedSearch) ||
                item.department.toLowerCase().contains(normalizedSearch) ||
                item.phone.toLowerCase().contains(normalizedSearch);
          }).toList();

          return RefreshIndicator(
            onRefresh: _refreshProfessors,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _ProfessorOverview(professors: professors),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome, e-mail ou area',
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
                if (visibleProfessors.isEmpty)
                  _ProfessorMessage(
                    icon: Icons.search_off_outlined,
                    title: 'Nenhum resultado encontrado',
                    message:
                        'Revise o termo pesquisado para localizar o cadastro.',
                    actionLabel: 'Limpar busca',
                    onAction: _searchController.clear,
                  )
                else
                  ...visibleProfessors.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ProfessorCard(
                        professorItem: item,
                        onEdit: () => _openForm(selectedProfessor: item),
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

class _ProfessorOverview extends StatelessWidget {
  final List<AdvisorProfessor> professors;

  const _ProfessorOverview({required this.professors});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final departmentCount = professors
        .map((item) => item.department.trim())
        .where((department) => department.isNotEmpty)
        .toSet()
        .length;
    final contactCount = professors
        .where(
          (item) =>
              item.email.trim().isNotEmpty || item.phone.trim().isNotEmpty,
        )
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
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
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orientadores de Estagio',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Professores disponiveis para acompanhamento',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondary.withValues(alpha: 0.78),
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
                  label: 'Professores',
                  value: professors.length.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewMetric(
                  label: 'Areas',
                  value: departmentCount.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewMetric(
                  label: 'Contatos',
                  value: contactCount.toString(),
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
        color: colorScheme.onSecondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.onSecondary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSecondary.withValues(alpha: 0.76),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessorCard extends StatelessWidget {
  final AdvisorProfessor professorItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProfessorCard({
    required this.professorItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final professorName = professorItem.name.trim();
    final initial = professorName.isEmpty
        ? '?'
        : professorName[0].toUpperCase();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
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
                    professorItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _InfoLine(
                    icon: Icons.mail_outline,
                    text: professorItem.email,
                  ),
                  const SizedBox(height: 4),
                  _InfoLine(
                    icon: Icons.apartment_outlined,
                    text: professorItem.department,
                  ),
                  const SizedBox(height: 4),
                  _InfoLine(
                    icon: Icons.phone_outlined,
                    text: professorItem.phone,
                  ),
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

class _ProfessorMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ProfessorMessage({
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
