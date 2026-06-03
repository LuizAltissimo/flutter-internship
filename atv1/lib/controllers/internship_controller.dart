import 'package:atv1/models/internship_model.dart';
import 'package:atv1/repositories/internship_repository.dart';

class sqlInternshipController implements InternshipRepository {
  final internship_data_source _repository;

  sqlInternshipController({internship_data_source? repository}) : _repository = repository ?? internship_data_source();

  @override
  Future<int> insert_internship(internship internship) async {
    return await _repository.insert_internship(internship);
  }

  @override
  Future<List<internship>> get_internships() async {
    return await _repository.get_internships();
  }
  
  @override
  Future<int> update_internship(internship internship) async {
    return await _repository.update_internship(internship);
  }

  @override
  Future<int> delete_internship(int id) async {
    return await _repository.delete_internship(id);
  }
}