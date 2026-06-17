import 'package:atv1/controllers/company_controller.dart';
import 'package:atv1/models/company_model.dart';
import 'package:atv1/pages/company_form_page.dart';
import 'package:atv1/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  final SqlCompanyController _controller = SqlCompanyController();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Company>> _companiesFuture;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchTerm = _searchController.text.trim());
    });
    _loadCompanies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCompanies() {
    _companiesFuture = _controller.getCompanies();
  }

  Future<void> _refreshCompanies() async {
    setState(_loadCompanies);
    await _companiesFuture;
  }

  Future<void> _openForm({Company? selectedCompany}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CompanyFormPage(companyToEdit: selectedCompany),
      ),
    );

    if (saved == true && mounted) {
      _refreshCompanies();
    }
  }

  Future<void> _confirmDelete(Company selectedCompany) async {
    final id = selectedCompany.companyId;
    if (id == null) {
      _showMessage('Não foi possível excluir esta empresa.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
          title: const Text('Excluir empresa?'),
          content: Text(
            'O registro de ${selectedCompany.name} será removido permanentemente.',
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
      await _controller.deleteCompany(id);
      if (!mounted) return;
      _showMessage('Empresa excluída.');
      _refreshCompanies();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToInternships() {
    Navigator.of(context).pushReplacementNamed('/internships');
  }

  void _navigateToProfessors() {
    Navigator.of(context).pushReplacementNamed('/professors');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        activeSection: AppSection.companies,
        onInternshipsSelected: _navigateToInternships,
        onProfessorsSelected: _navigateToProfessors,
        onCompaniesSelected: () {},
      ),
      appBar: AppBar(title: const Text('Empresas concedentes'), elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: _searchController,
                    hintText: 'Pesquisar empresa',
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() => _searchTerm = value.trim());
                    },
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return [];
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Company>>(
                future: _companiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar empresas: ${snapshot.error}',
                      ),
                    );
                  }

                  final allCompanies = snapshot.data ?? [];
                  final filteredCompanies = allCompanies
                      .where(
                        (company) =>
                            company.name.toLowerCase().contains(
                              _searchTerm.toLowerCase(),
                            ) ||
                            company.cnpj.toLowerCase().contains(
                              _searchTerm.toLowerCase(),
                            ),
                      )
                      .toList();

                  if (filteredCompanies.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchTerm.isEmpty
                                ? 'Nenhuma empresa cadastrada'
                                : 'Nenhuma empresa encontrada',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = filteredCompanies[index];
                      return _CompanyCard(
                        company: company,
                        onEdit: () => _openForm(selectedCompany: company),
                        onDelete: () => _confirmDelete(company),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        label: const Text('Nova empresa'),
        icon: const Icon(Icons.add_business_outlined),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final Company company;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CompanyCard({
    required this.company,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company.cnpj,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: const Text('Editar'), onTap: onEdit),
                    PopupMenuItem(
                      child: Text(
                        'Excluir',
                        style: TextStyle(color: colorScheme.error),
                      ),
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    company.location,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    company.contactName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    company.contactEmail,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  company.contactPhone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
