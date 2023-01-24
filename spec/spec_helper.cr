require "spec"
require "../src/bech32"

VALID_BECH32_DECODE = {
  {
    string: "A12UEL5L",
    prefix: "A",
    hex:    "",
    bytes:  Bytes[],
  },
  {
    string: "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs",
    prefix: "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio",
    hex:    "",
    bytes:  Bytes[],
  },
  {
    string: "abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw",
    prefix: "abcdef",
    hex:    "00443214c74254b635cf84653a56d7c675be77df",
    bytes:  Bytes[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31],
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    bytes:  Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  },
  {
    string: "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w",
    prefix: "split",
    hex:    "c5f38b70305f519bf66d85fb6cf03058f3dde463ecd7918f2dc743918f2d",
    bytes:  Bytes[24, 23, 25, 24, 22, 28, 1, 16, 11, 29, 8, 25, 23, 29, 19, 13, 16, 23, 29, 22, 25, 28, 1, 16, 11, 3, 25, 29, 27, 25, 3, 3, 29, 19, 11, 25, 3, 3, 25, 13, 24, 29, 1, 25, 3, 3, 25, 13],
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq978ear",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    bytes:  Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
