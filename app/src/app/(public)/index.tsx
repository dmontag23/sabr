import { Link } from "expo-router";
import { View } from "react-native";

const LoggedOutLandingScreen = () => (
  <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
    <Link href="/auth/email">Continue with email</Link>
  </View>
);

export default LoggedOutLandingScreen;
