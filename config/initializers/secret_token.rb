# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Chat::Application.config.secret_key_base = '9bb1b9e2e7c46f6bcfca0cff6d90388ea6932c94fd7314d838be8e4c535dffe141ab2f416ccd67fef4f57b1b3dc63407c6f55407073eeb06fe49d74580ecb1e0'
