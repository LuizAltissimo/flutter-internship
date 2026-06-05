import 'package:atv1/controllers/advisor_professor_controller.dart';
import 'package:atv1/controllers/internship_controller.dart';
import 'package:atv1/models/advisor_professor_model.dart';
import 'package:atv1/models/internship_model.dart';
import 'package:flutter/material.dart';

class InternshipFormPage extends StatefulWidget {
  final Internship? internshipToEdit;

  const InternshipFormPage({super.key, this.internshipToEdit});

  @override
  State<InternshipFormPage> createState() => _InternshipFormPageState();
}

class _InternshipFormPageState extends State<InternshipFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SqlInternshipController();
  final _professorController = SqlAdvisorProfessorController();
  final _studentNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();

  int? _advisorProfessorId;
  String? _advisorProfessorName;
  final List<AdvisorProfessor> _professors = [];
  bool _isProfessorsLoading = true;
  bool _isSaving = false;

  bool get _isEditing => widget.internshipToEdit != null;

  @override
  void initState() {
    super.initState();

    final internshipToEdit = widget.internshipToEdit;
    if (internshipToEdit != null) {
      _studentNameController.text = internshipToEdit.studentName;
      _companyNameController.text = internshipToEdit.companyName;
      _locationController.text = internshipToEdit.location;
      _durationController.text = internshipToEdit.duration;
      _advisorProfessorId = internshipToEdit.advisorProfessorId;
      _advisorProfessorName = internshipToEdit.advisorProfessorName;
    }

    _loadProfessors();
  }

  Future<void> _loadProfessors() async {
    final professors = await _professorController.getProfessors();
    if (!mounted) return;
    setState(() {
      _professors.clear();
      _professors.addAll(professors);
      _isProfessorsLoading = false;
    });
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveInternship() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_advisorProfessorId == null || _advisorProfessorName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um professor orientador antes de salvar.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final newInternship = Internship(
      internshipId: widget.internshipToEdit?.internshipId,
      studentName: _studentNameController.text.trim(),
      companyName: _companyNameController.text.trim(),
      location: _locationController.text.trim(),
      duration: _durationController.text.trim(),
      advisorProfessorId: _advisorProfessorId,
      advisorProfessorName: _advisorProfessorName,
    );

    try {
      if (_isEditing) {
        await _controller.updateInternship(newInternship);
      } else {
        await _controller.insertInternship(newInternship);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _requiredFieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatorio';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = _isEditing ? 'Editar estagio' : 'Novo estagio';

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _FormHeader(
                    title: pageTitle,
                    subtitle: _isEditing
                        ? 'Atualize as informacoes do registro selecionado.'
                        : 'Preencha os dados principais para cadastrar o estagio.',
                    icon: _isEditing
                        ? Icons.edit_note_outlined
                        : Icons.add_business_outlined,
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'Dados do estudante',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _studentNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do estudante',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle(
                    title: 'Professor orientador',
                    icon: Icons.school_outlined,
                  ),
                  const SizedBox(height: 10),
                  if (_isProfessorsLoading)
                    const SizedBox(
                      height: 64,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_professors.isEmpty)
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nenhum professor cadastrado.',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Cadastre um professor orientador antes de vincular ao estagio.',
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/professors');
                              },
                              icon: const Icon(Icons.school_outlined),
                              label: const Text('Ir para professores'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    DropdownButtonFormField<int>(
                      initialValue: _advisorProfessorId,
                      items: _professors
                          .map(
                            (professor) => DropdownMenuItem(
                              value: professor.professorId,
                              child: Text(professor.name),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Orientador',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      onChanged: (value) {
                        final professor = _professors
                            .firstWhere((item) => item.professorId == value);
                        setState(() {
                          _advisorProfessorId = professor.professorId;
                          _advisorProfessorName = professor.name;
                        });
                      },
                      validator: (value) {
                        if (_professors.isEmpty) return null;
                        if (value == null) {
                          return 'Selecione um orientador';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  const _SectionTitle(
                    title: 'Dados do estagio',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _companyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Empresa',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Localizacao',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duracao',
                      hintText: 'Ex.: 6 meses',
                      prefixIcon: Icon(Icons.schedule_outlined),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveInternship(),
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 26),
                  _FormActions(
                    isSaving: _isSaving,
                    isEditing: _isEditing,
                    onCancel: () => Navigator.of(context).maybePop(),
                    onSave: _saveInternship,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _FormHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.onSecondaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FormActions extends StatelessWidget {
  final bool isSaving;
  final bool isEditing;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _FormActions({
    required this.isSaving,
    required this.isEditing,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final saveLabel = isEditing ? 'Salvar alteracoes' : 'Cadastrar estagio';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;
        final saveButton = FilledButton.icon(
          onPressed: isSaving ? null : onSave,
          icon: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(isSaving ? 'Salvando...' : saveLabel),
        );
        final cancelButton = OutlinedButton.icon(
          onPressed: isSaving ? null : onCancel,
          icon: const Icon(Icons.close),
          label: const Text('Cancelar'),
        );

        if (isCompact) {
          return Column(
            children: [saveButton, const SizedBox(height: 10), cancelButton],
          );
        }

        return Row(
          children: [
            Expanded(child: cancelButton),
            const SizedBox(width: 12),
            Expanded(child: saveButton),
          ],
        );
      },
    );
  }
}
