//создание enum
enum City {
  vladivostok,
  khabarovsk,
  moscow;

  String get queryName => switch (this) {
        City.moscow => "moscow",
        City.khabarovsk => "khabarovsk",
        City.vladivostok => "vladivostok"
      };

  String get name => switch (this) {
        City.moscow => "МосКва",
        City.khabarovsk => "Хабаровск",
        City.vladivostok => "Владивосток"
      };
}
