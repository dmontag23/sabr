import { render, fireEvent } from "@testing-library/react-native";
import EmailScreen from "@/app/(public)/auth/email";
import { supabase } from "@/utils/supabase";

const MOCK_PUSH = jest.fn();
jest.mock("expo-router", () => ({ useRouter: () => ({ push: MOCK_PUSH }) }));
jest.mock("@/utils/supabase", () => ({
  supabase: { auth: { signInWithOtp: jest.fn() } },
}));

describe("<EmailScreen />", () => {
  test("normalizes the email, sends an OTP, and navigates to verify-token on submit", async () => {
    const { getByText, getByPlaceholderText } = render(<EmailScreen />);

    fireEvent.changeText(
      getByPlaceholderText("you@email.com"),
      "  foO@emAil.com  ",
    );
    await fireEvent.press(getByText("Send me a code"));

    expect(supabase.auth.signInWithOtp).toHaveBeenCalledTimes(1);
    expect(supabase.auth.signInWithOtp).toHaveBeenCalledWith({
      email: "foo@email.com",
    });
    expect(MOCK_PUSH).toHaveBeenCalledTimes(1);
    expect(MOCK_PUSH).toHaveBeenCalledWith({
      pathname: "/auth/verify-token",
      params: { email: "foo@email.com" },
    });
  });
});
