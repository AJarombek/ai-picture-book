String removeLastNewlines(String input) {
  if (input.length >= 2 && input.endsWith('\n')) {
    return input.substring(0, input.length - 1);
  }

  if (input.length >= 3 && input.endsWith('\n\n')) {
    return input.substring(0, input.length - 2);
  }

  return input;
}