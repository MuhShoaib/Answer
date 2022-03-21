class Language {
  int id;
  String name;
  String flag;
  String langaugeCode;
  Language(this.id, this.name, this.flag, this.langaugeCode);

  static List<Language> langaugeList() {
    return <Language>[
      Language(1, "🇮🇳", "India", "hi"),
      Language(2, "🇦🇪", "United Arab Emirates", "ar"),
      Language(3, '🇸🇪', 'Sweden', 'sv'),
      Language(4, "🇨🇭", "SwitzerLand", "de"),
      Language(5, "🇧🇶", "Netherland", "nl"),
      Language(6, "🇩🇪", "Germany", "de"),
      Language(7, "🇧🇪", "Belgium", "fr"),
      Language(8, "🇪🇸", "Spain", "es"),
      Language(9, "🇦🇿", "Azerbaijan", "az"),
      Language(10, "🇮🇹", "Italy", "it"),
      Language(11, "🇫🇷", "France", "fr"),
      Language(12, "🇸🇦", "Saudi Arabia", "ar"),
      Language(13, "🇹🇼", "Taiwan", "zh-cn"),
      Language(14, "🇻🇳", "Vietnam", "vi"),
      Language(15, "🇹🇭", "Thailand", "th"),
      Language(16, "🇨🇳", "China", "zh-cn"),
      Language(17, "🇯🇵", "Japan", "ja"),

    ];
  }
}
