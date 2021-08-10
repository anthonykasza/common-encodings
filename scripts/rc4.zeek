@load ./ascii-lookups


module RC4;

export {
  global enc_dec: function(key: string, s1: string): string;
}

function RC4::enc_dec(key: string, s1: string): string {
  local sbox: vector of count = vector();
  local j: count = 0;
  local x: count;
  local result_v: vector of count = vector();
  local i: count = 0;

  # Populate our sbox
  while (i < 256) {
    sbox[i] = i;
    i += 1;
  }

  i = 0;
  while (i < 256) {
    j = (j + sbox[i] + ord[key[i % |key|]]) % 256;
    x = sbox[i];

    sbox[i] = sbox[j];
    sbox[j] = x;

    i += 1;
  }

  i = 0;
  j = 0;
  local y: count = 0;
  while (y < |s1|) {
    i = (i+1) % 256;
    j = (j + sbox[i]) % 256;
    x = sbox[i];

    sbox[i] = sbox[j];
    sbox[j] = x;

    result_v += ord[s1[y]] ^ sbox[(sbox[i] + sbox[j]) % 256];

    y += 1;
  }

  # Place the result_vector into a result_string and return it.
  local result_s: string = "";
  for (idx in result_v) {
    result_s += chr[ result_v[idx] ];
  }

  return result_s;
}
