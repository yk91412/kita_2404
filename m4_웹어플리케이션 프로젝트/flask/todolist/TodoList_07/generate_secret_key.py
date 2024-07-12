import secrets

def generate_key():
    return secrets.token_hex(24)

generate_key = generate_key()
print(f"Secret key : {generate_key}")