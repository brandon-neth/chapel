use CTypes;
proc f(ptr:c_ptr(int)) {
  writeln(ptr.deref());
}
proc g(ptr:c_ptr(void)) {
  writeptr(ptr);
}

proc writeptr(ptr:c_ptr(void)) {
  var p = ptr:c_ptr(int);
  writeln(p.deref());
}

proc main() {
  var a: c_array(int, 2);

  a[0] += 1;
  var ptr: c_ptr(int) = a; // ptr points to &a[0]
  writeln(ptr.deref());

  a[0] += 1;
  ptr = a; // ptr points to &a[0]
  writeln(ptr.deref());

  a[0] += 1;
  ptr = a:c_ptr(int);
  writeln(ptr.deref());

  a[0] += 1;
  f(a); // prints a[0]
 
  a[0] += 1;
  var vptr: c_ptr(void) = a; // ptr points to &a[0]
  writeptr(vptr);

  a[0] += 1;
  vptr = a; // ptr points to &a[0]
  writeptr(vptr);
 
  a[0] += 1;
  vptr = a:c_ptr(void);
  writeptr(vptr);
 
  a[0] += 1;
  g(a); // prints a[0]
}
