const crypto = require('crypto');

// Backup encryption helper using AES-256-CBC (async - non-blocking)
async function encryptText(text, password) {
  const salt = crypto.randomBytes(16);
  // Derive key using pbkdf2 asynchronously (does NOT block the event loop)
  const key = await new Promise((resolve, reject) => {
    crypto.pbkdf2(password, salt, 100000, 32, 'sha256', (err, derivedKey) => {
      if (err) reject(err); else resolve(derivedKey);
    });
  });
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  
  return JSON.stringify({
    salt: salt.toString('hex'),
    iv: iv.toString('hex'),
    data: encrypted
  });
}

// Backup decryption helper
function decryptText(encryptedJsonString, password) {
  const encryptedObj = JSON.parse(encryptedJsonString);
  const salt = Buffer.from(encryptedObj.salt, 'hex');
  const iv = Buffer.from(encryptedObj.iv, 'hex');
  const key = crypto.pbkdf2Sync(password, salt, 100000, 32, 'sha256');
  const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
  
  let decrypted = decipher.update(encryptedObj.data, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

module.exports = {
  encryptText,
  decryptText
};
