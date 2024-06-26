// Test sync field in a record

record D {
  var s: sync int;
  proc init() {}
  proc init=(other: D) {
    this.s = other.s.readXX();
  }
}

var d: D;
var i: int;

d.s.writeEF(4);
i = d.s.readFE();
writeln( "i is ", i);


record E {
  var sf: sync real;
  proc init() {}
  proc init=(other: E) {
    this.sf = other.sf.readXX();
  }
}

var e: E;
var f: real;

e.sf.writeEF(1.2);
f = e.sf.readFE();
writeln( "f is ", f);
