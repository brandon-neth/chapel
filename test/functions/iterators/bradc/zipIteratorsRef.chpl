class C {
  var x: real = 1.2;

  iter these() ref {
    yield x;
  }
}

var myC = new unmanaged C();

writeln("myC is: ");
for c in myC do
  writeln(c, " ");

writeln("writing to myC");
for c in myC {
  c = 2.3;
}

writeln("myC is: ");
for c in myC do
  writeln(c, " ");

var ownOtherC = new owned C();
var otherC = ownOtherC.borrow();

writeln("otherC is: ");
for c in otherC do
  writeln(c, " ");

for (c1, c2) in zip(otherC, myC) {
  c1 = c2;
}

writeln("otherC is: ");
for c in otherC do
  writeln(c, " ");

delete myC;
