use Time;

class C {
  type t;
  var x: t;
  proc init(type t) {
    this.t = t;
  }
}

type t = sync int;

var c = new unmanaged C(t);

begin {
  writeln(c.x.readFE());
  delete c;
}

sleep(2);

c.x.writeEF(2);
