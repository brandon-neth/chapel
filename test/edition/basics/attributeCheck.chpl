/* START_EXAMPLE */
@edition(first="pre-edition")
proc foo(x: int) {
  writeln("in new edition foo with arg x=", x);
}

@edition(last="2.0")
proc foo(x: int) {
  writeln("in old edition foo with arg x=", x);
}
/* STOP_EXAMPLE */

// Check specifying both first and last works
@edition(first="2.0", last="pre-edition")
proc bar(s: string) {
  writeln(s);
}

// Check specifying first and last when they are the same works
@edition(first="2.0", last="2.0")
proc baz() {
  writeln("in old baz");
}

@edition(first="pre-edition", last="pre-edition")
proc baz() {
  writeln("in new baz");
}

proc main() {
  foo(17);
  bar("always relevant");
  baz();
}
