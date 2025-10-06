class CardTileOptionModel<T extends Enum> {
  final String imagePath;
  final T titleEnum;
  final String route;
  final String? sectionTitle;
  final String Function(T)? labelMapper;

  String get title =>
      labelMapper != null ? labelMapper!(titleEnum) : titleEnum.name;

  CardTileOptionModel({
    required this.imagePath,
    required this.titleEnum,
    required this.route,
    this.sectionTitle,
    this.labelMapper,
  });
}
