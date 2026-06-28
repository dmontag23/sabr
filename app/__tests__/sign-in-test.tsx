import { renderRouter, fireEvent, act } from "expo-router/testing-library";
import { supabase } from "@/utils/supabase";
import { Session } from "@supabase/supabase-js";

jest.mock("@/utils/supabase", () => ({
  supabase: {
    auth: {
      onAuthStateChange: jest.fn(),
      signInWithOtp: jest.fn(),
      verifyOtp: jest.fn(),
    },
  },
}));

describe("sign in flow", () => {
  beforeEach(() => {
    jest.mocked(supabase.auth.onAuthStateChange).mockReturnValue({
      data: {
        subscription: { id: "", callback: () => {}, unsubscribe: () => {} },
      },
    });
  });

  const emitAuthEvent: Parameters<
    typeof supabase.auth.onAuthStateChange
  >[0] = async (event, session) =>
    act(async () => {
      await jest
        .mocked(supabase.auth.onAuthStateChange)
        .mock.calls[0][0](event, session);
    });

  test("user can sign in via email", async () => {
    const { getByText, getByPlaceholderText, findByText } = renderRouter(
      "src/app",
      { initialUrl: "/" },
    );

    fireEvent.press(getByText("Continue with email"));
    fireEvent.changeText(
      getByPlaceholderText("you@email.com"),
      "  tESt@test.com  ",
    );
    fireEvent.press(getByText("Send me a code"));
    expect(supabase.auth.signInWithOtp).toHaveBeenCalledTimes(1);
    expect(supabase.auth.signInWithOtp).toHaveBeenCalledWith({
      email: "test@test.com",
    });
    expect(await findByText("Tap the link we just sent you")).toBeVisible();

    /* In the flow, the user would open the link we just sent them. Without doing that, there's
    no real way to continue the flow. So we just assume that the user is magically able to log in
    correctly via emitting a SIGNED_IN event from Supabase. The actual "click the link" flow is
    tested below. */
    await emitAuthEvent("SIGNED_IN", { user: { id: "user-1" } } as Session);
    expect(await findByText("Home")).toBeVisible();
  }, 10000);

  test("user can sign in by following a magic link", async () => {
    const { findByText } = renderRouter("src/app", {
      initialUrl: "/auth/verify-token?token_hash=token-hash",
    });

    expect(await findByText("Tap the link we just sent you")).toBeVisible();
    expect(supabase.auth.verifyOtp).toHaveBeenCalledTimes(1);
    expect(supabase.auth.verifyOtp).toHaveBeenCalledWith({
      token_hash: "token-hash",
      type: "email",
    });
    await emitAuthEvent("SIGNED_IN", { user: { id: "user-1" } } as Session);
    expect(await findByText("Home")).toBeVisible();
  });
});
