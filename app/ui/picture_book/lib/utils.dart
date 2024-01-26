String transformString(String input) {
  // Remove newline characters
  String withoutNewlines = input.replaceAll('\n', '');

  // Remove all whitespace
  String withoutWhitespace = withoutNewlines.replaceAll(' ', '');

  // Fix end of sentences
  String properEndOfSentence = withoutWhitespace.replaceAll('.', '.  ');

  // Replace underscore (_) with whitespace
  String withoutUnderscore = properEndOfSentence.replaceAll('_', ' ');

  // Replace pipe (|) with two newline characters
  String finalResult = withoutUnderscore.replaceAll('|', '\n\n');

  return finalResult;
}