// generate compiler warnings when some calls are created by the compiler

class myiter1 {
  iter these() {
    compilerError("error from myiter1.these(), depth=0", 0);
    yield 111;
  }
}

var mi1Obj = new myiter1(); var mi1 = mi1Obj.borrow();
for i in mi1 do writeln(i);
