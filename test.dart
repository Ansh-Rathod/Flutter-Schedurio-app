void main() {
  RegExp exp = RegExp(r'https:\/\/t.co\/\S+');
  final urls = exp.allMatches(
      "https://t.co/gpqlaIBonW \nthis is text\nhttps://t.co/vv8AHGoYFi https://t.co/YCrFkhPCLS");
  print(urls.map((e) => e.group(0)).toList());
}
