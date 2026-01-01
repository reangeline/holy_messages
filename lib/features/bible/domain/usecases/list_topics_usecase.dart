import '../entities/topic_entity.dart';
import '../repositories/bible_repository.dart';

class ListTopicsUseCase {
  final BibleRepository repository;

  const ListTopicsUseCase(this.repository);

  Future<List<TopicEntity>> call() => repository.listTopics();
}