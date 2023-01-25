# bech32

A BIP173/BIP350 compatible Bech32/Bech32m encoding/decoding library for Crystal.

![GitHub](https://img.shields.io/github/license/wout/bech32)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/wout/bech32)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/wout/bech32/ci.yml?branch=main)

## Installation

1. Add the dependency to your `shard.yml`:

  ```yaml
  dependencies:
    bech32:
      github: wout/bech32
  ```

2. Run `shards install`

## Usage

```crystal
require "bech32"
```

### Decoding

Decode using the default `Bech32` encoding:

```crystal
prefix, words = Bech32.decode("abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw")
puts prefix
# => "abcdef"
puts words
# => Bytes[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
```

Decode using the `Bech32M` encoding:

```crystal
prefix, words = Bech32.decode(
  "abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx",
  encoding: Bech32::Encoding::Bech32M
)
puts prefix
# => "abcdef"
puts words
# => Bytes[31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
```

To convert the words to bytes:

```crystal
words = Bytes[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
Bech32.from_words(words)
# => Bytes[0, 68, 50, 20, 199, 66, 84, 182, 53, 207, 132, 101, 58, 86, 215, 198, 117, 190, 119, 223]
```

### Encoding

Convert the string to words:

```crystal
words = Bech32.to_words("foobar".to_slice)
```

Encode using the default `Bech32` encoding:

```crystal
Bech32.encode("foo", words)
# => "foo1vehk7cnpwgry9h96"
```

Encode using the `Bech32M` encoding:

```crystal
Bech32.encode("foo", words, encoding: Bech32::Encoding::Bech32M)
# => "foo1vehk7cnpwgkc4mqc"
```

### Advanced
BIP173 enforces a limitation of 90 characters. If the given string exceeds this
length, pass a higher value using the `limit` argument. Be aware that the
[effectiveness of the checksum decreases as the length
increases](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki#checksum-design).

It is highly recommended not to exceed 1023 characters, as the module could only
guarantee to detect one error.

## Development

Make sure you have [Guardian.cr](https://github.com/f/guardian) installed. Then
run:

```bash
$ guardian
```

This will automatically:
- run ameba for src and spec files
- run the relevant spec for any file in the src dir
- run spec a file whenever it's saved

## Contributing

1. Fork it (<https://github.com/wout/bech32/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Wout](https://github.com/wout) - creator and maintainer

## Acknowledgments
This shard pulls inspiration from the following projects:
- [bitcoinjs/bech32](https://github.com/bitcoinjs/bech32)
- [azuchi/bech32rb](https://github.com/azuchi/bech32rb)
