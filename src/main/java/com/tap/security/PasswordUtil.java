
package com.tap.security;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtil {

    private static final int ITERATIONS = 120000;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 16;

    private PasswordUtil() {
    }

    // Convert a plain password into a secure hash
    public static String hashPassword(String password) {

        byte[] salt = new byte[SALT_LENGTH];

        new SecureRandom().nextBytes(salt);

        byte[] hash = generateHash(password, salt, ITERATIONS);

        return "pbkdf2$"
                + ITERATIONS + "$"
                + Base64.getEncoder()
                        .withoutPadding()
                        .encodeToString(salt)
                + "$"
                + Base64.getEncoder()
                        .withoutPadding()
                        .encodeToString(hash);
    }

    // Verify a password during login
    public static boolean verifyPassword(
            String password, String storedPassword) {

        if (password == null || storedPassword == null) {
            return false;
        }

        try {
            String[] parts = storedPassword.split("\\$");

            if (parts.length != 4
                    || !parts[0].equals("pbkdf2")) {
                return false;
            }

            int iterations = Integer.parseInt(parts[1]);

            if (iterations < 10000 || iterations > 1000000) {
                return false;
            }

            byte[] salt = Base64.getDecoder()
                    .decode(parts[2]);

            byte[] expectedHash = Base64.getDecoder()
                    .decode(parts[3]);

            if (salt.length != SALT_LENGTH
                    || expectedHash.length != KEY_LENGTH / 8) {
                return false;
            }

            byte[] actualHash = generateHash(
                    password, salt, iterations);

            return MessageDigest.isEqual(
                    expectedHash, actualHash);

        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    private static byte[] generateHash(
            String password, byte[] salt, int iterations) {

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                iterations,
                KEY_LENGTH);

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance(
                            "PBKDF2WithHmacSHA256");

            return factory.generateSecret(spec).getEncoded();

        } catch (Exception e) {
            throw new IllegalStateException(
                    "Unable to hash password", e);
        } finally {
            spec.clearPassword();
        }
    }
}
