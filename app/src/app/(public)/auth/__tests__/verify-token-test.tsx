import { render } from "@testing-library/react-native";
import VerifyTokenScreen from "@/app/(public)/auth/verify-token";
import { supabase } from "@/utils/supabase";
import { useLocalSearchParams } from "expo-router";

jest.mock("expo-router", () => ({ useLocalSearchParams: jest.fn() }));
jest.mock("@/utils/supabase", () => ({
  supabase: { auth: { verifyOtp: jest.fn() } },
}));

describe("<VerifyTokenScreen />", () => {
  beforeEach(() => {
    jest
      .mocked(useLocalSearchParams)
      .mockReturnValue({ token_hash: "token-hash" });
  });

  test("renders the waiting instruction", () => {
    const { getByText } = render(<VerifyTokenScreen />);

    expect(getByText("Tap the link we just sent you")).toBeVisible();
  });

  test("does not call the verify function when token_hash is absent", () => {
    jest.mocked(useLocalSearchParams).mockReturnValueOnce({ token_hash: "" });

    render(<VerifyTokenScreen />);

    expect(supabase.auth.verifyOtp).not.toHaveBeenCalled();
  });

  test("verifies the token when the token_hash is provided", () => {
    render(<VerifyTokenScreen />);

    expect(supabase.auth.verifyOtp).toHaveBeenCalledTimes(1);
    expect(supabase.auth.verifyOtp).toHaveBeenCalledWith({
      token_hash: "token-hash",
      type: "email",
    });
  });
});
