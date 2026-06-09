import { AuthContextProvider, useAuthContext } from "@/context/AuthContext";
import { Stack } from "expo-router";

const RootNavigator = () => {
  const { isLoggedIn } = useAuthContext();

  return (
    <Stack>
      <Stack.Protected guard={isLoggedIn}>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      </Stack.Protected>

      <Stack.Protected guard={!isLoggedIn}>
        <Stack.Screen name="(public)" options={{ headerShown: false }} />
      </Stack.Protected>
    </Stack>
  );
};

const RootLayout = () => (
  <AuthContextProvider>
    <RootNavigator />
  </AuthContextProvider>
);

export default RootLayout;
