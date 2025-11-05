part of 'factory_bloc.dart';

@immutable
abstract class FactoryEvent {}

class FactoryEventHandler extends FactoryEvent {
  FactoryEventHandler();
}
