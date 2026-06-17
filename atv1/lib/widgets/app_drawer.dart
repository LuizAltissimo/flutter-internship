import 'package:flutter/material.dart';

enum AppSection { internships, professors, companies }

class AppDrawer extends StatelessWidget {
  final AppSection activeSection;
  final VoidCallback onInternshipsSelected;
  final VoidCallback onProfessorsSelected;
  final VoidCallback onCompaniesSelected;

  const AppDrawer({
    super.key,
    required this.activeSection,
    required this.onInternshipsSelected,
    required this.onProfessorsSelected,
    required this.onCompaniesSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              color: colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    color: colorScheme.onPrimary,
                    size: 34,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Controle de Estagios',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cadastros do acompanhamento',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              selected: activeSection == AppSection.internships,
              leading: const Icon(Icons.work_outline),
              title: const Text('Estagios'),
              onTap: onInternshipsSelected,
            ),
            ListTile(
              selected: activeSection == AppSection.professors,
              leading: const Icon(Icons.school_outlined),
              title: const Text('Professores orientadores'),
              onTap: onProfessorsSelected,
            ),
            ListTile(
              selected: activeSection == AppSection.companies,
              leading: const Icon(Icons.business_outlined),
              title: const Text('Empresas concedentes'),
              onTap: onCompaniesSelected,
            ),
          ],
        ),
      ),
    );
  }
}
