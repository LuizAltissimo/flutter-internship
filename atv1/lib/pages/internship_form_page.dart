import 'package:atv1/controllers/internship_controller.dart';
import 'package:atv1/models/internship_model.dart';
import 'package:flutter/material.dart';

class InternshipFormPage extends StatefulWidget {
  final internship? internshipToEdit;

  const InternshipFormPage({super.key, this.internshipToEdit});

  @override
  State<InternshipFormPage> createState() => _InternshipFormPageState();
}

class _InternshipFormPageState extends State<InternshipFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = sqlInternshipController();
  final _studentNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.internshipToEdit != null;

  @override
  void initState() {
    super.initState();

    final internshipToEdit = widget.internshipToEdit;
    if (internshipToEdit != null) {
      _studentNameController.text = internshipToEdit.student_name;
      _companyNameController.text = internshipToEdit.company_name;
      _locationController.text = internshipToEdit.location;
      _durationController.text = internshipToEdit.duration;
    }
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

    setState(() => _isSaving = true);

    final newInternship = internship(
      internship_id: widget.internshipToEdit?.internship_id,
      student_name: _studentNameController.text.trim(),
      company_name: _companyNameController.text.trim(),
      location: _locationController.text.trim(),
      duration: _durationController.text.trim(),
    );

    try {
      if (_isEditing) {
        await _controller.update_internship(newInternship);
      } else {
        await _controller.insert_internship(newInternship);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar estagio' : 'Novo estagio'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _studentNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do estudante',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Empresa',
                  prefixIcon: Icon(Icons.business_outlined),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Localizacao',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duracao',
                  prefixIcon: Icon(Icons.schedule_outlined),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _saveInternship(),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveInternship,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
