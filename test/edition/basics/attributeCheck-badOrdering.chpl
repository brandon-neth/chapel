// Checks the behavior when first is a newer edition than last
@edition(first="pre-edition", last="2.0")
proc foo() {
  writeln("huh, that shouldn't have worked");
}

proc main() {
  foo();
}
