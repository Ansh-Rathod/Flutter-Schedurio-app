void main() {
  var year = 2009;

  var years = [year];
  while (year != 2023) {
    year = year + 1;
    years.add(year);
  }

  print(years);
}
