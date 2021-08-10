# This script ported from https://gist.github.com/aleiphoenix/5472119,
#  which has since disappeared. Thank you, ghost in the git.


@load ./ascii-lookups
@load ./bit-shifts


module Base64;

export {
  global alphabet: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  global encode: function(s: string, a: string &default=Base64::alphabet): string;
  global decode: function(s: string, a: string &default=Base64::alphabet): string;
}

function Base64::encode(s: string, a: string): string {
  # Convert s to a vector, input, so we can operate with indices
  local input: vector of string = vector();
  for (char in s) {
    input += char;
  }

  # Convert alphabet string to a vector
  local alphabet_v: vector of string = vector();
  for (char in a) {
    alphabet_v += char;
  }

  local output: string = "";

  local enc1: count;
  local enc2: count;
  local enc3: count;
  local enc4: count;

  local char1: count;
  local char2: count;
  local char3: count;

  local i: count = 0;
  local len: count = |input|;

  while (i + (len % 3) < len) {
    char1 = ord[input[i]];
    i += 1;

    char2 = ord[input[i]];
    i += 1;

    char3 = ord[input[i]];
    i += 1;

    enc1 = shift_right(char1, 2);
    enc2 = shift_left((char1 & 3), 4) | shift_right(char2, 4);
    enc3 = shift_left((char2 & 15), 2) | shift_right(char3, 6);
    enc4 = char3 & 63;

    output += alphabet_v[enc1] + alphabet_v[enc2] + alphabet_v[enc3] + alphabet_v[enc4];
  }

  if (len % 3 == 2) {
    char1 = ord[input[i]];
    i += 1;
    char2 = ord[input[i]];

    enc1 = shift_right(char1, 2);
    enc2 = shift_left((char1 & 3), 4) | shift_right(char2, 4);
    enc3 = shift_left((char2 & 15), 2);
    enc4 = 64;
    output += alphabet_v[enc1] + alphabet_v[enc2] + alphabet_v[enc3] + alphabet_v[enc4];

  } else if (len % 3 == 1) {
    char1 = ord[input[i]];

    enc1 = shift_right(char1, 2);
    enc2 = shift_left((char1 & 3), 4);
    enc3 = 64;
    enc4 = 64;

    output += alphabet_v[enc1] + alphabet_v[enc2] + alphabet_v[enc3] + alphabet_v[enc4];
  }

  return output;
}

function Base64::decode(s: string, a: string): string {
  # Convert s to a vector, input, so we can operate with indices
  local input: vector of string = vector();
  for (char in s) {
    input += char;
  }

  # Convert alphabet to table of strings yeilding counts
  local alphabet_t: table[string] of count = table();
  local x: count = 0;
  for (char in a) {
    alphabet_t[char] = x;
    x += 1;
  }

  local output: string = "";

  local enc1: count;
  local enc2: count;
  local enc3: count;
  local enc4: count;

  local char1: count;
  local char2: count;
  local char3: count;

  local i = 0;

  while (i < |input|) {
    enc1 = alphabet_t[input[i]];
    i += 1;

    enc2 = alphabet_t[input[i]];
    i += 1;

    enc3 = alphabet_t[input[i]];
    i += 1;

    enc4 = alphabet_t[input[i]];
    i += 1;

    char1 = shift_left(enc1, 2) | shift_right(enc2, 4);
    char2 = shift_left((enc2 & 15), 4) | shift_right(enc3, 2);
    char3 = shift_left((enc3 & 3), 6) | enc4;

    output += chr[char1];

    if (enc3 != 64) {
      output += chr[char2]; 
    }

    if (enc4 != 64) {
      output += chr[char3];
    }
  }

  return output;
}
