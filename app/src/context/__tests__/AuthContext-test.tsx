import { renderHook, act } from "@testing-library/react-native";
import { PropsWithChildren } from "react";
import type { Session } from "@supabase/supabase-js";
import { AuthContextProvider, useAuthContext } from "@/context/AuthContext";
import { supabase } from "@/utils/supabase";

jest.mock("@/utils/supabase", () => ({
  supabase: { auth: { onAuthStateChange: jest.fn() } },
}));

const MOCK_UNSUBSCRIBE = jest.fn();

describe("AuthContext", () => {
  beforeEach(() => {
    jest.mocked(supabase.auth.onAuthStateChange).mockReturnValue({
      data: {
        subscription: {
          id: "",
          callback: () => {},
          unsubscribe: MOCK_UNSUBSCRIBE,
        },
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

  const wrapper = ({ children }: PropsWithChildren) => (
    <AuthContextProvider>{children}</AuthContextProvider>
  );

  test("defaults to no logged in user", () => {
    const { result } = renderHook(() => useAuthContext(), { wrapper });

    expect(result.current.isLoggedIn).toBe(false);
  });

  test("logs in and out after supabase emits SIGNED_IN and SIGNED_OUT events (respectively)", async () => {
    const { result } = renderHook(() => useAuthContext(), { wrapper });
    await emitAuthEvent("SIGNED_IN", { user: { id: "user-1" } } as Session);

    expect(result.current.isLoggedIn).toBe(true);

    await emitAuthEvent("SIGNED_OUT", null);

    expect(result.current.isLoggedIn).toBe(false);
  });

  test("onAuthStateChange subscription unsubscribes on unmount", () => {
    const { unmount } = renderHook(() => useAuthContext(), { wrapper });
    unmount();

    expect(MOCK_UNSUBSCRIBE).toHaveBeenCalledTimes(1);
  });
});
