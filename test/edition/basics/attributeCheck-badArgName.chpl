@edition(fisrt="pre-edition")
proc foo(x: int) {
  writeln("in new edition foo with arg x=", x);
}

proc main() {
  foo(12);
}
