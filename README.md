# Transparent Database Encryption in Ruby
memorization for me...

## Procedure
### Generate Cipher Key from Key and Salt
- key
    - Randomized value
    - 1 key for 1 application
    - commonly saved as as environment variable
- salt
    - Randomized value
    - 1 salt per 1 user at least
        - Even if a lot of records are leaked, the hackers need to decrypt for each salt
        - It prevent Rainbow Table Attack
- use HKDF
    - a simple key derivation function ( HMAC-based Key Derivation Function )
        - ref: [RFC5869](https://tools.ietf.org/html/rfc5869)
    - calculate unique cipher key from Key and Salt
    - key should be 128, 192 and 256 bits
        - e.g. AES-256-CBC requires 256 bits size of key (8 bits * 32 characters)

### Encrypt Content
**Algorithm**
- AES (Advanced Encryption Standard)
    - ref: https://docs.ruby-lang.org/ja/latest/class/OpenSSL=3a=3aCipher.html
- 10 rounds for 128-bit keys, 12 rounds for 192-bit keys and 14 rounds for 256-bit keys
    - a round consists of several processing steps that include substitution, transposition and mixing of the input plaintext and transform it into the final output of cipher text
        - substitution of data using a substitution table
        - transformation shifts data rows
        - mixes columns
        - a simple exclusive or (XOR) operation performed on each column using a different part of the encryption key

**IV**
- Initialized Vector
- IV is needed for encryption algorithms
- When IVs are different, the cipher texts are different even if original texts are same
- It is not good to use same IV for all values for the security reason

**Modes**

ref: https://docs.ruby-lang.org/ja/latest/library/openssl.html#references
- ECB
    - IV is not needed
- SIV
    - IV equals to hashed value of plain text
    - If values are same, cipher texts are same, either
- GCM
    - It can be very vulnerable when use same IV   
    - faster than CBC 
- CBC
    - IV is used to calculate XOR with the first block
    - First strings will be same if use same IV for similar texts like 'Hello, world' and 'Hello, space'

## Gems
- [attr_encrypted](https://github.com/attr-encrypted/attr_encrypted)
- [crypt_keeper](https://github.com/jmazzi/crypt_keeper)
- [symmetric-encryption](https://github.com/rocketjob/symmetric-encryption)
- [active_record_encryption](https://github.com/alpaca-tc/active_record_encryption)

## References
- https://www.ipa.go.jp/security/rfc/RFC3602JA.html
- https://proprivacy.com/guides/aes-encryption
- https://www.comparitech.com/blog/information-security/what-is-aes-encryption/
- https://en.wikipedia.org/wiki/Advanced_Encryption_Standard