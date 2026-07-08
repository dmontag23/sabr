import { supabase } from "@/utils/supabase";
import { ComponentProps, useState } from "react";
import { View, TextInput } from "react-native";
import { useRouter } from "expo-router";
import { Button } from "@/components/Button";

const EmailScreen = () => {
  const [email, setEmail] = useState("");
  const router = useRouter();

  const handlePress: NonNullable<
    ComponentProps<typeof Button>["onPress"]
  > = async () => {
    const trimmedEmail = email.trim().toLowerCase();

    // TODO: Handle error!
    await supabase.auth.signInWithOtp({
      email: trimmedEmail,
    });

    router.push({
      pathname: "/auth/verify-token",
      params: { email: trimmedEmail },
    });
  };

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <TextInput
        value={email}
        onChangeText={setEmail}
        autoCapitalize="none"
        autoComplete="email"
        autoCorrect={false}
        autoFocus
        inputMode="email"
        placeholder="you@email.com"
      />
      <Button title="Send me a code" onPress={handlePress} />
    </View>
  );
};

export default EmailScreen;
