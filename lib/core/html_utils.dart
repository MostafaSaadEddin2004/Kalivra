import 'package:html/parser.dart' show parse;

/// Strips HTML tags and decodes entities (e.g. `&nbsp;`) to plain text.
String htmlToPlainText(String? html) {
  if (html == null || html.trim().isEmpty) return '';
  final document = parse(html);
  final text = document.body?.text ?? document.documentElement?.text ?? html;
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}
