# All work and no shifts make Jack a dull boy.

module GLOBAL;

export {
  global shift_left: function(n: count, i: count): count;
  global shift_right: function(n: count, i: count): count;
}

# <<
function shift_left(n: count, i: count): count {
  local temp: count = 2;
  i -= 1;
  while (i > 0) {
    temp = temp * 2;
    i -= 1;
  }
  return n * temp;
}

# >>
function shift_right(n: count, i: count): count {
  while (i > 0) {
    n = n / 2;
    i -= 1;
  }
  return n;
}
