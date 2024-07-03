import secrets

def generate_secret_key1():
    return secrets.token_hex(24)

secret_key = generate_secret_key1()
print(f"Secret_key {secret_key}")
