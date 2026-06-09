/* The following import and mock are needed for AsyncStorage.
See https://react-native-async-storage.github.io/latest/integrations/jest */
import MockAsyncStorage from "@react-native-async-storage/async-storage/jest/async-storage-mock";

jest.mock("@react-native-async-storage/async-storage", () => MockAsyncStorage);

process.env.EXPO_PUBLIC_SUPABASE_URL = "http://test-url";
process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY = "test-sb-publishable-key";
