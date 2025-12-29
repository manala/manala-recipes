## CA Certificate

It's possible to simulate TLS termination by providing a self generated certificate AND by embeding CA certificate used to signed it into the system authority keychain.
⚠️ DO NOT use self signed certificates for production purposes.

Generate private key:
```
openssl genpkey -aes-256-cbc -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out ca.key
```

Generate self signed certificate:
```
openssl req -new -x509 -sha256 -days 825 -subj "/O=Elao/CN=Elao Development Only - 2025" -key ca.key -out ca.crt
```

⚠️ No more than 825 days of validity for OSX based systems (https://support.apple.com/en-us/HT210176).
