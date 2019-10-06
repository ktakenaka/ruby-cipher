require_relative "init"

# ref: https://tools.ietf.org/html/rfc5297

salt    = SecureRandom.random_bytes(32 )
key     = 'password'
iter    = 20_000
key_len = 32
cipher_key = OpenSSL::KDF.pbkdf2_hmac(key, salt: salt, iterations: iter, length: key_len, hash: "sha256")

encryptor = Miscreant::AEAD.new("AES-SIV", cipher_key)

# Encrypt Content
text = 'hello world'
puts "original text is #{text}"

# ref: https://tools.ietf.org/html/rfc5297#section-3
#   > A non-random source MAY also be used

puts '--- cbc ---'
puts 'start encryption'
nonce = Miscreant::AEAD.generate_nonce
encrypted_text = encryptor.seal(text, nonce: nonce)

puts "encrypted text is #{encrypted_text}"

puts 'start decryption'
decrypted_text = encryptor.open(encrypted_text, nonce: nonce)

puts "decrypted text is #{decrypted_text}"
puts "same text? #{text == decrypted_text}"
