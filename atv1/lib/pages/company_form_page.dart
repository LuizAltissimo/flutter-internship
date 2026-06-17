import 'package:atv1/controllers/company_controller.dart';
import 'package:atv1/models/company_model.dart';
import 'package:flutter/material.dart';

class CompanyFormPage extends StatefulWidget {
  final Company? companyToEdit;

  const CompanyFormPage({super.key, this.companyToEdit});

  @override
  State<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends State<CompanyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SqlCompanyController();
  final _nameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.companyToEdit != null;

  @override
  void initState() {
    super.initState();

    final companyToEdit = widget.companyToEdit;
    if (companyToEdit != null) {
      _nameController.text = companyToEdit.name;
      _cnpjController.text = companyToEdit.cnpj;
      _locationController.text = companyToEdit.location;
      _contactNameController.text = companyToEdit.contactName;
      _contactEmailController.text = companyToEdit.contactEmail;
      _contactPhoneController.text = companyToEdit.contactPhone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnpjController.dispose();
    _locationController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _saveCompany() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    final newCompany = Company(
      companyId: widget.companyToEdit?.companyId,
      name: _nameController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      location: _locationController.text.trim(),
      contactName: _contactNameController.text.trim(),
      contactEmail: _contactEmailController.text.trim(),
      contactPhone: _contactPhoneController.text.trim(),
    );

    try {
      if (_isEditing) {
        await _controller.updateCompany(newCompany);
      } else {
        await _controller.insertCompany(newCompany);
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
    final pageTitle = _isEditing ? 'Editar empresa' : 'Nova empresa';

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
                        ? 'Atualize os dados da empresa concedente.'
                        : 'Cadastre a empresa que recebera estudantes em estagio.',
                    icon: _isEditing
                        ? Icons.edit_note_outlined
                        : Icons.add_business_outlined,
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'Dados da empresa',
                    icon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da empresa',
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cnpjController,
                    decoration: const InputDecoration(
                      labelText: 'CNPJ',
                      hintText: 'Ex.: 00.000.000/0001-00',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    keyboardType: TextInputType.number,
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
                  const SizedBox(height: 20),
                  const _SectionTitle(
                    title: 'Contato responsavel',
                    icon: Icons.contact_mail_outlined,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _contactNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do contato',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contactEmailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contactPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      hintText: 'Ex.: (11) 99999-9999',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveCompany(),
                    validator: _requiredFieldValidator,
                  ),
                  const SizedBox(height: 26),
                  _FormActions(
                    isSaving: _isSaving,
                    isEditing: _isEditing,
                    onCancel: () => Navigator.of(context).maybePop(),
                    onSave: _saveCompany,
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
    final saveLabel = isEditing ? 'Salvar alteracoes' : 'Cadastrar empresa';

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
