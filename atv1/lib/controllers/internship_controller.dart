import 'package:atv1/models/internship_model.dart';
import 'package:atv1/repositories/internship_repository.dart';

class SqlInternshipController implements InternshipRepository {
  final InternshipDataSource _repository;

  SqlInternshipController({InternshipDataSource? repository})
    : _repository = repository ?? InternshipDataSource();

  @override
  Future<int> insertInternship(Internship internship) async {
    return await _repository.insertInternship(internship);
  }

  @override
  Future<List<Internship>> getInternships() async {
    return await _repository.getInternships();
  }

  @override
  Future<int> updateInternship(Internship internship) async {
    return await _repository.updateInternship(internship);
  }

  @override
  Future<int> deleteInternship(int id) async {
    return await _repository.deleteInternship(id);
  }
}
