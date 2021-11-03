@load ./ascii-lookups


module XOR;

export {
  global enc_dec: function(key: string, input: string, exclude: set[string] &default=set()): string;
}

# `key` can be a multibyte XOR key but must be a string type
# `input` is the input string being transformed
# `exclude` must be a set of single byte strings which aren't transformed if they appear in the input string
function enc_dec(key: string, input: string, exclude: set[string] &default=set()): string {
  for (each in exclude) {
    if (|each| > 1) {
      return "ERROR - exclusion list includes multibyte value";
    }
  }

  local input_v: vector of string = vector();
  for (char in input) {
    input_v += char;
  }

  local result_s: string = "";
  for (idx in input_v) {
    if (input_v[idx] in exclude) {
      result_s += input_v[idx];
    } else {
      local n: count = ord[input_v[idx]] ^ ord[key[idx % |key|]];
      result_s += chr[n];
    }
  }
  return result_s;
}

