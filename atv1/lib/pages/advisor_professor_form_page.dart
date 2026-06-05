import 'package:atv1/controllers/advisor_professor_controller.dart';
import 'package:atv1/models/advisor_professor_model.dart';
import 'package:flutter/material.dart';

class AdvisorProfessorFormPage extends StatefulWidget {
  final AdvisorProfessor? professorToEdit;

  const AdvisorProfessorFormPage({super.key, this.professorToEdit});

  @override
  State<AdvisorProfessorFormPage> createState() =>
      _AdvisorProfessorFormPageState();
}

class _AdvisorProfessorFormPageState extends State<AdvisorProfessorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SqlAdvisorProfessorController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.professorToEdit != null;

  @override
  void initState() {
    super.initState();

    final professorToEdit = widget.professorToEdit;
    if (professorToEdit != null) {
      _nameController.text = professorToEdit.name;
      _emailController.text = professorToEdit.email;
      _departmentController.text = professorToEdit.department;
      _phoneController.text = professorToEdit.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfessor() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    final newProfessor = AdvisorProfessor(
      professorId: widget.professorToEdit?.professorId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      department: _departmentController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    try {
      if (_isEditing) {
        await _controller.updateProfessor(newProfessor);
      } else {
        await _controller.insertProfessor(newProfessor);
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

  String? _emailValidator(String? value) {
    final requiredError = _requiredFieldValidator(value);
    if (requiredError != null) return requiredError;

    final email = value!.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'E-mail invalido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = _isEditing
        ? 'Editar professor orientador'
        : 'Novo professor orientador';

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
                        ? 'Atualize os dados do orientador selecionado.'
                        : 'Preencha os dados principais do professor orientador.',
                    icon: _isEditing
                        ? Icons.edit_note_outlined
                        : Icons.school_outlined,
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'Dados do professor',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do professor',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle(
                    title: 'Dados de orientacao',
                    icon: Icons.assignment_ind_outlined,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Area ou departamento',
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      hintText: 'Ex.: (11) 99999-9999',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveProfessor(),
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 26),
                  _FormActions(
                    isSaving: _isSaving,
                    isEditing: _isEditing,
                    onCancel: () => Navigator.of(context).maybePop(),
                    onSave: _saveProfessor,
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
    final saveLabel = isEditing ? 'Salvar alteracoes' : 'Cadastrar professor';

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
