var Model = {
  generate: {
    rsa_oaep: function() {
      return crypto.subtle.generateKey(
        { 
          name: "RSA-OAEP",
          modulusLength: 2048,
          publicExponent: new Uint8Array([0x01, 0x00, 0x01]),
          hash: {name: "SHA-256"},
        },
        true,
        ["encrypt", "decrypt"]
      )
    },
    ecdh: function() {
      return crypto.subtle.generateKey(
        { name: "ECDH", namedCurve: "P-256" },
        true,
        ["deriveKey", "deriveBits"]
      )
    },
    ecdsa: function() {
      return crypto.subtle.generateKey(
        { name: "ECDSA", namedCurve: "P-256" },
        true,
        ["sign", "verify"]
      )
    }
  },
  export: function(keyType) {
    return crypto.subtle.exportKey("jwk", keyType)
  }
}
