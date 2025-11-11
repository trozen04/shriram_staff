part of 'factory_bloc.dart';

@immutable
abstract class FactoryEvent {}

class FactoryEventHandler extends FactoryEvent {
  FactoryEventHandler();
}

class InsertFactoryInventoryEvent extends FactoryEvent {
  final inventoryData;

  InsertFactoryInventoryEvent({
    required this.inventoryData,
  });
}