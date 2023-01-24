require "spec"
require "../src/bech32"

VALID_CONVERT = {
  bytes: Bytes[
    0, 4, 223, 149, 66, 179, 36, 18, 22, 136, 65, 58, 246, 181, 214, 202, 149,
    133, 28, 218, 58, 223, 168, 43, 77, 218, 125, 154, 49, 31, 238, 97, 249,
    84, 126, 33, 22, 120, 217, 124, 109, 202, 174, 26, 21, 7, 30, 115, 30,
    223, 73, 170, 24, 76, 71, 183, 124,
  ],
  words: [
    0, 0, 2, 13, 31, 5, 10, 2, 22, 12, 18, 1, 4, 5, 20, 8, 8, 4, 29, 15, 13,
    13, 14, 22, 25, 10, 10, 24, 10, 7, 6, 26, 7, 11, 15, 26, 16, 10, 26, 13,
    27, 9, 30, 25, 20, 12, 8, 31, 29, 25, 16, 31, 18, 21, 3, 30, 4, 4, 11, 7,
    17, 22, 11, 28, 13, 23, 5, 10, 28, 6, 16, 21, 0, 28, 15, 7, 6, 7, 22, 31,
    9, 6, 21, 1, 16, 19, 2, 7, 22, 29, 30, 0,
  ] of UInt8,
}

VALID_BECH32_DECODE = {
  {
    string: "A12UEL5L",
    prefix: "A",
    hex:    "",
    words:  [] of UInt8,
  },
  {
    string: "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs",
    prefix: "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio",
    hex:    "",
    words:  [] of UInt8,
  },
  {
    string: "abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw",
    prefix: "abcdef",
    hex:    "00443214c74254b635cf84653a56d7c675be77df",
    words:  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31] of UInt8,
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    words:  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] of UInt8,
  },
  {
    string: "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w",
    prefix: "split",
    hex:    "c5f38b70305f519bf66d85fb6cf03058f3dde463ecd7918f2dc743918f2d",
    words:  [24, 23, 25, 24, 22, 28, 1, 16, 11, 29, 8, 25, 23, 29, 19, 13, 16, 23, 29, 22, 25, 28, 1, 16, 11, 3, 25, 29, 27, 25, 3, 3, 29, 19, 11, 25, 3, 3, 25, 13, 24, 29, 1, 25, 3, 3, 25, 13] of UInt8,
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq978ear",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    words:  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] of UInt8,
    limit:  300,
  },
}

INVALID_BECH32_DECODE = {
  {
    string:    "A12Uel5l",
    exception: "Mixed-case string A12Uel5l",
  },
  {
    string:    " 1nwldj5",
    exception: "Invalid prefix",
  },
  {
    string:    "abc1rzg",
    exception: "'abc1rzg' is too short",
  },
  {
    string:    "an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx",
    exception: "Exceeds length limit",
  },
  {
    string:    "x1b4n0q5v",
    exception: "Unknown character b",
  },
  {
    string:    "1pzry9x0s0muk",
    exception: "Missing prefix",
  },
  {
    string:    "pzry9x0s0muk",
    exception: "No separator character",
  },
  {
    string:    "abc1rzgt4",
    exception: "Data too short",
  },
  {
    string:    "s1vcsyn",
    exception: "'s1vcsyn' is too short",
  },
  {
    string:    "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
    exception: "Exceeds length limit",
  },
  {
    string:    "li1dgmt3",
    exception: "Data too short",
  },
}
