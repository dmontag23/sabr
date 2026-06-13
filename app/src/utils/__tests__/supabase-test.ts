import { createClient } from "@supabase/supabase-js";
import * as SecureStore from "expo-secure-store";
import AsyncStorage from "@react-native-async-storage/async-storage";
import "@/utils/supabase";

jest.mock("@supabase/supabase-js", () => ({ createClient: jest.fn() }));
jest.mock("expo-secure-store", () => ({
  setItemAsync: jest.fn(),
  getItemAsync: jest.fn(),
  deleteItemAsync: jest.fn(),
}));

const [SUPABASE_URL, SUPABASE_KEY, OPTIONS] =
  jest.mocked(createClient).mock.calls[0];
const STORAGE = OPTIONS?.auth?.storage;

describe("supabase client", () => {
  test("connects using the Supabase URL and key", () => {
    expect(SUPABASE_URL).toBe(process.env.EXPO_PUBLIC_SUPABASE_URL);
    expect(SUPABASE_KEY).toBe(process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY);
  });

  test("uses the PKCE auth flow", () => {
    expect(OPTIONS?.auth?.flowType).toBe("pkce");
  });

  test("falls back to empty credentials when the env vars are not set", () => {
    const originalEnv = { ...process.env };
    delete process.env.EXPO_PUBLIC_SUPABASE_URL;
    delete process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

    /* this is needed because createClient is called when the module is imported, not as a part of any function.
    The strategy is to re-import the module after deleting the env vars and then test the result */
    jest.isolateModules(() => {
      // eslint-disable-next-line @typescript-eslint/no-require-imports
      require("@/utils/supabase");
      expect(
        jest.requireMock<typeof import("@supabase/supabase-js")>(
          "@supabase/supabase-js",
        ).createClient,
      ).toHaveBeenCalledWith("", "", expect.anything());
    });

    Object.assign(process.env, originalEnv);
  });

  describe("storage", () => {
    const ENCRYPTION_KEY_HEX = "0".repeat(64); // hex code for 32 byte encryption key of all zeros
    const VALUE = "secret-value";
    const ENCRYPTED_VALUE_HEX = "206ae989a2311bcfc80fc194"; // the result of encrypting "secret-value" using the 32 byte encryption key

    beforeEach(async () => {
      jest
        .spyOn(globalThis.crypto, "getRandomValues")
        .mockImplementation((byteArray) => byteArray);
    });

    test("getItem returns null when the key is missing", async () => {
      jest.mocked(AsyncStorage.getItem).mockResolvedValueOnce(null);

      await expect(STORAGE?.getItem("key")).resolves.toBeNull();
      await expect(AsyncStorage.getItem).toHaveBeenCalledTimes(1);
      await expect(AsyncStorage.getItem).toHaveBeenCalledWith("key");
      await expect(SecureStore.getItemAsync).not.toHaveBeenCalled();
    });

    test("getItem returns null when the encryption key hex in SecureStore is missing", async () => {
      jest
        .mocked(AsyncStorage.getItem)
        .mockResolvedValueOnce(ENCRYPTED_VALUE_HEX);
      jest.mocked(SecureStore.getItemAsync).mockResolvedValueOnce(null);

      await expect(STORAGE?.getItem("key")).resolves.toBeNull();
      await expect(AsyncStorage.getItem).toHaveBeenCalledTimes(1);
      await expect(AsyncStorage.getItem).toHaveBeenCalledWith("key");
      await expect(SecureStore.getItemAsync).toHaveBeenCalledTimes(1);
      await expect(SecureStore.getItemAsync).toHaveBeenCalledWith("key");
    });

    test("getItem returns the value when the encryption key in SecureStore is present", async () => {
      jest
        .mocked(AsyncStorage.getItem)
        .mockResolvedValueOnce(ENCRYPTED_VALUE_HEX);
      jest
        .mocked(SecureStore.getItemAsync)
        .mockResolvedValueOnce(ENCRYPTION_KEY_HEX);

      await expect(STORAGE?.getItem("key")).resolves.toBe(VALUE);
      await expect(AsyncStorage.getItem).toHaveBeenCalledTimes(1);
      await expect(AsyncStorage.getItem).toHaveBeenCalledWith("key");
      await expect(SecureStore.getItemAsync).toHaveBeenCalledTimes(1);
      await expect(SecureStore.getItemAsync).toHaveBeenCalledWith("key");
    });

    test("removeItem clears both AsyncStorage and SecureStore", async () => {
      await STORAGE?.removeItem("key");

      expect(AsyncStorage.removeItem).toHaveBeenCalledTimes(1);
      expect(AsyncStorage.removeItem).toHaveBeenCalledWith("key");
      expect(SecureStore.deleteItemAsync).toHaveBeenCalledTimes(1);
      expect(SecureStore.deleteItemAsync).toHaveBeenCalledWith("key");
    });

    test("setItem sets the encrypted value hex in AsyncStorage and keeps the encryption key hex in SecureStore", async () => {
      await STORAGE?.setItem("key", VALUE);

      expect(SecureStore.setItemAsync).toHaveBeenCalledTimes(1);
      expect(SecureStore.setItemAsync).toHaveBeenCalledWith(
        "key",
        ENCRYPTION_KEY_HEX,
      );
      expect(AsyncStorage.setItem).toHaveBeenCalledTimes(1);
      expect(AsyncStorage.setItem).toHaveBeenCalledWith(
        "key",
        ENCRYPTED_VALUE_HEX,
      );
    });
  });
});
