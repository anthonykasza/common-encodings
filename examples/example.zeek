
event zeek_init() {
  local cleartext: string = "Hello123";
  local key: string = "key123";

  local ciphertext = RC4::enc_dec(key, cleartext);
  print ciphertext, RC4::enc_dec(key, ciphertext);

  local encoded = Base64::encode(cleartext);
  print encoded, Base64::decode(encoded);

  print cleartext[0], ord[cleartext[0]], chr[ord[cleartext[0]]];

  local n: count = 10;
  local i: count = 2;
  local lshift = shift_left(n, i);
  print n, lshift, shift_right(lshift, i);

  print XOR::enc_dec("A", "ABC");
  print XOR::enc_dec("A", "ABC", set("A"));
  print XOR::enc_dec("AB", "ABC");
  print XOR::enc_dec("AB", "ABC", set("A"));
  print XOR::enc_dec("AB", "ABC", set("A", "B", "C"));
}
