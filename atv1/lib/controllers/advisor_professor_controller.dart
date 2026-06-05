import 'package:atv1/models/advisor_professor_model.dart';
import 'package:atv1/repositories/advisor_professor_repository.dart';

class SqlAdvisorProfessorController implements AdvisorProfessorRepository {
  final AdvisorProfessorDataSource _repository;

  SqlAdvisorProfessorController({AdvisorProfessorDataSource? repository})
    : _repository = repository ?? AdvisorProfessorDataSource();

  @override
  Future<int> insertProfessor(AdvisorProfessor professor) async {
    return await _repository.insertProfessor(professor);
  }

  @override
  Future<List<AdvisorProfessor>> getProfessors() async {
    return await _repository.getProfessors();
  }

  @override
  Future<int> updateProfessor(AdvisorProfessor professor) async {
    return await _repository.updateProfessor(professor);
  }

  @override
  Future<int> deleteProfessor(int id) async {
    return await _repository.deleteProfessor(id);
  }
}
