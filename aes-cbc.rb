require 'securerandom'
require 'openssl'

# Generate Cipher key from key and salt with HKDF
# ref: https://ruby-doc.org/stdlib-2.5.0/libdoc/openssl/rdoc/OpenSSL/KDF.html
salt    = SecureRandom.random_bytes(32 )
key     = 'password'
iter    = 20_000
key_len = 32
cipher_key = OpenSSL::KDF.pbkdf2_hmac(key, salt: salt, iterations: iter, length: key_len, hash: "sha256")

# Encrypt Content
text = 'hello world'
puts "original text is #{text}"

puts '--- cbc ---'
puts 'start encryption'
cipher = OpenSSL::Cipher.new('AES-256-CBC')
cipher.encrypt
cipher.key = cipher_key
iv = cipher.random_iv
encrypted_text = cipher.update(text) + cipher.final

puts "encrypted text is #{encrypted_text}, key: #{cipher_key}, iv: #{iv}"

puts 'start decryption'
cipher = OpenSSL::Cipher.new('AES-256-CBC')
cipher.decrypt
cipher.key = cipher_key
cipher.iv = iv
decrypted_text = cipher.update(encrypted_text) + cipher.final

puts "decrypted text is #{decrypted_text}"
puts "same text? #{text == decrypted_text}"
