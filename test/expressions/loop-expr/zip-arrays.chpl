
var A, B: [1..2,1..3] int;
var C = [ab in zip(A,B)] ab;  // C: [A.domain] (2*int)
writeln(C);

var D = foreach ab in zip(A,B) do ab;  // D: [A.domain] (2*int)
writeln(D);
