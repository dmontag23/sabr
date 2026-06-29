import { createClient, type SupportedStorage } from "@supabase/supabase-js";
import * as aesjs from "aes-js";
import * as SecureStore from "expo-secure-store";
import AsyncStorage from "@react-native-async-storage/async-storage";
import "react-native-get-random-values";
import { Platform } from "react-native";

/*
As Expo's SecureStore does not support values larger than 2048
bytes, so an AES-256 key is generated and stored in SecureStore. This key
is then used to encrypt/decrypt values stored in AsyncStorage. Taken from
https://supabase.com/docs/guides/getting-started/tutorials/with-expo-react-native?queryGroups=auth-store&auth-store=secure-store
*/

const generateCipher = (encryptionKeyBytes: Uint8Array) =>
  new aesjs.ModeOfOperation.ctr(encryptionKeyBytes, new aesjs.Counter(1));

const encrypt = async (key: string, value: string) => {
  const encryptionKeyBytes = crypto.getRandomValues(new Uint8Array(256 / 8));
  await SecureStore.setItemAsync(
    key,
    aesjs.utils.hex.fromBytes(encryptionKeyBytes),
  );

  const cipher = generateCipher(encryptionKeyBytes);
  const encryptedValueBytes = cipher.encrypt(aesjs.utils.utf8.toBytes(value));
  return aesjs.utils.hex.fromBytes(encryptedValueBytes);
};

const decrypt = async (key: string, encryptedValueHex: string) => {
  const encryptionKeyHex = await SecureStore.getItemAsync(key);
  if (!encryptionKeyHex) return encryptionKeyHex;
  const cipher = generateCipher(aesjs.utils.hex.toBytes(encryptionKeyHex));
  const decryptedValueBytes = cipher.decrypt(
    aesjs.utils.hex.toBytes(encryptedValueHex),
  );
  return aesjs.utils.utf8.fromBytes(decryptedValueBytes);
};

const largeSecureStore: SupportedStorage = {
  getItem: async (key: string) => {
    const encryptedValueHex = await AsyncStorage.getItem(key);
    if (!encryptedValueHex) return encryptedValueHex;
    return await decrypt(key, encryptedValueHex);
  },

  removeItem: async (key: string) => {
    await AsyncStorage.removeItem(key);
    await SecureStore.deleteItemAsync(key);
  },

  setItem: async (key: string, value: string) => {
    const encryptedValueHex = await encrypt(key, value);
    await AsyncStorage.setItem(key, encryptedValueHex);
  },
};

export const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL ?? "",
  process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? "",
  {
    auth: {
      ...(Platform.OS !== "web" && { storage: largeSecureStore }),
      flowType: "pkce",
    },
  },
);
