require "spec"
require "yaml"
require "../src/bech32"

VALID_CONVERT = {
  bytes: Bytes[
    0, 4, 223, 149, 66, 179, 36, 18, 22, 136, 65, 58, 246, 181, 214, 202, 149,
    133, 28, 218, 58, 223, 168, 43, 77, 218, 125, 154, 49, 31, 238, 97, 249,
    84, 126, 33, 22, 120, 217, 124, 109, 202, 174, 26, 21, 7, 30, 115, 30,
    223, 73, 170, 24, 76, 71, 183, 124,
  ],
  words: Bytes[
    0, 0, 2, 13, 31, 5, 10, 2, 22, 12, 18, 1, 4, 5, 20, 8, 8, 4, 29, 15, 13,
    13, 14, 22, 25, 10, 10, 24, 10, 7, 6, 26, 7, 11, 15, 26, 16, 10, 26, 13,
    27, 9, 30, 25, 20, 12, 8, 31, 29, 25, 16, 31, 18, 21, 3, 30, 4, 4, 11, 7,
    17, 22, 11, 28, 13, 23, 5, 10, 28, 6, 16, 21, 0, 28, 15, 7, 6, 7, 22, 31,
    9, 6, 21, 1, 16, 19, 2, 7, 22, 29, 30, 0,
  ],
}

VALID_BECH32 = {
  {
    string: "A12UEL5L",
    prefix: "A",
    hex:    "",
    words:  Bytes[],
  },
  {
    string: "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs",
    prefix: "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio",
    hex:    "",
    words:  Bytes[],
  },
  {
    string: "abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw",
    prefix: "abcdef",
    hex:    "00443214c74254b635cf84653a56d7c675be77df",
    words:  Bytes[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31],
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    words:  Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  },
  {
    string: "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w",
    prefix: "split",
    hex:    "c5f38b70305f519bf66d85fb6cf03058f3dde463ecd7918f2dc743918f2d",
    words:  Bytes[24, 23, 25, 24, 22, 28, 1, 16, 11, 29, 8, 25, 23, 29, 19, 13, 16, 23, 29, 22, 25, 28, 1, 16, 11, 3, 25, 29, 27, 25, 3, 3, 29, 19, 11, 25, 3, 3, 25, 13, 24, 29, 1, 25, 3, 3, 25, 13],
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq978ear",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    words:  Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    limit:  300,
  },
  {
    string: "addr1w8phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcyjy7wx",
    prefix: "addr",
    hex:    "71c37b1b5dc0669f1d3c61a6fddb2e8fde96be87b881c60bce8e8d542f",
    words:  Bytes[14, 7, 1, 23, 22, 6, 26, 29, 24, 1, 19, 9, 30, 7, 9, 28, 12, 6, 19, 15, 27, 22, 25, 14, 17, 31, 15, 9, 13, 15, 20, 7, 23, 2, 0, 28, 12, 2, 30, 14, 17, 26, 6, 21, 8, 11, 24],
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

INVALID_BECH32_ENCODE = {
  {
    prefix:    "abc",
    words:     Bytes[128],
    exception: "Non 5-bit word",
  },
  {
    prefix:    "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobar",
    words:     Bytes[128],
    exception: "Exceeds length limit",
  },
  {
    prefix:    "foobar",
    words:     Bytes[20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20],
    exception: "Exceeds length limit",
  },
  {
    prefix:    "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobarfoobarfoobar",
    words:     Bytes[128],
    "limit":   104,
    exception: "Exceeds length limit",
  },
  {
    prefix:    "abc\u00ff",
    words:     Bytes[18],
    exception: "Invalid prefix",
  },
}

VALID_BECH32M = {
  {
    string: "A1LQFN3A",
    prefix: "A",
    hex:    "",
    words:  Bytes[],
  },
  {
    string: "a1lqfn3a",
    prefix: "a",
    hex:    "",
    words:  Bytes[],
  },
  {
    string: "an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11sg7hg6",
    prefix: "an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber1",
    hex:    "",
    words:  Bytes[],
  },
  {
    string: "abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx",
    prefix: "abcdef",
    hex:    "ffbbcdeb38bdab49ca307b9ac5a928398a418820",
    words:  Bytes[31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    string: "11llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllludsr8",
    prefix: "1",
    words:  Bytes[31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31],
  },
  {
    string: "split1checkupstagehandshakeupstreamerranterredcaperredlc445v",
    prefix: "split",
    hex:    "c5f38b70305f519bf66d85fb6cf03058f3dde463ecd7918f2dc743918f2d",
    words:  Bytes[24, 23, 25, 24, 22, 28, 1, 16, 11, 29, 8, 25, 23, 29, 19, 13, 16, 23, 29, 22, 25, 28, 1, 16, 11, 3, 25, 29, 27, 25, 3, 3, 29, 19, 11, 25, 3, 3, 25, 13, 24, 29, 1, 25, 3, 3, 25, 13],
  },
  {
    string: "?1v759aa",
    prefix: "?",
    hex:    "",
    words:  Bytes[],
  },
  {
    string: "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqszh4cp",
    prefix: "1",
    hex:    "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    words:  Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    limit:  300,
  },
}

INVALID_BECH32M_DECODE = {
  {
    string:    "A1LQfN3A",
    exception: "Mixed-case string 'A1LQfN3A'",
  },
  {
    string:    " 1xj0phk",
    exception: "Invalid prefix \\( \\)",
  },
  {
    string:    "abc1rzg",
    exception: "'abc1rzg' is too short",
  },
  {
    string:    "an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4",
    exception: "Exceeds length limit",
  },
  {
    string:    "qyrz8wqd2c9m",
    exception: "No separator character for qyrz8wqd2c9m",
  },
  {
    string:    "1qyrz8wqd2c9m",
    exception: "Missing prefix for 1qyrz8wqd2c9m",
  },
  {
    string:    "y1b0jsk6g",
    exception: "Unknown character b",
  },
  {
    string:    "lt1igcx5c0",
    exception: "Unknown character i",
  },
  {
    string:    "in1muywd",
    exception: "Data too short",
  },
  {
    string:    "mm1crxm3i",
    exception: "Unknown character i",
  },
  {
    string:    "au1s5cgom",
    exception: "Unknown character o",
  },
  {
    string:    "M1VUXWEZ",
    exception: "Invalid checksum for m1vuxwez",
  },
  {
    string:    "16plkw9",
    exception: "'16plkw9' is too short",
  },
  {
    string:    "1p2gdwpf",
    exception: "Missing prefix for 1p2gdwpf",
  },
  {
    string:    "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
    exception: "Exceeds length limit",
  },
  {
    string:    "in1muywd",
    exception: "Data too short",
  },
}

INVALID_BECH32M_ENCODE = {
  {
    prefix:    "abc",
    words:     Bytes[128],
    exception: "Non 5-bit word",
  },
  {
    prefix:    "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobar",
    words:     Bytes[128],
    exception: "Exceeds length limit",
  },
  {
    prefix:    "foobar",
    words:     Bytes[20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20],
    exception: "Exceeds length limit",
  },
  {
    prefix:    "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobarfoobarfoobar",
    words:     Bytes[128],
    limit:     104,
    exception: "Exceeds length limit",
  },
  {
    prefix:    "abc\u00ff",
    words:     Bytes[18],
    exception: "Invalid prefix 'abc\u00ff'",
  },
}
