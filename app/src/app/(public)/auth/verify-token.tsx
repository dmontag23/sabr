import { supabase } from "@/utils/supabase";
import { useLocalSearchParams } from "expo-router";
import { useEffect } from "react";
import { View, Text } from "react-native";

const VerifyTokenScreen = () => {
  const { token_hash } = useLocalSearchParams<{ token_hash: string }>();

  useEffect(() => {
    // TODO: Handle error!
    if (token_hash) supabase.auth.verifyOtp({ token_hash, type: "email" });
  }, [token_hash]);

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Tap the link we just sent you</Text>
    </View>
  );
};

export default VerifyTokenScreen;
