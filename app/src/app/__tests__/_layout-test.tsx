import { render } from "@testing-library/react-native";
import RootLayout from "@/app/_layout";
import { useAuthContext } from "@/context/AuthContext";
import { Stack } from "expo-router";
import { PropsWithChildren } from "react";

jest.mock("@/context/AuthContext", () => ({
  AuthContextProvider: ({ children }: PropsWithChildren) => children,
  useAuthContext: jest.fn(),
}));

jest.mock("expo-router", () => ({
  Stack: Object.assign(({ children }: PropsWithChildren) => children, {
    Protected: ({ guard, children }: PropsWithChildren<{ guard: boolean }>) =>
      guard && children,
    Screen: jest.fn(),
  }),
}));

describe("<RootLayout />", () => {
  test("shows public group when logged out", () => {
    jest.mocked(useAuthContext).mockReturnValueOnce({ isLoggedIn: false });

    render(<RootLayout />);

    expect(Stack.Screen).toHaveBeenCalledTimes(1);
    expect(jest.mocked(Stack.Screen).mock.calls[0][0]).toEqual({
      name: "(public)",
      options: { headerShown: false },
    });
  });

  test("shows tabs group when logged in", () => {
    jest.mocked(useAuthContext).mockReturnValueOnce({ isLoggedIn: true });

    render(<RootLayout />);

    expect(Stack.Screen).toHaveBeenCalledTimes(1);
    expect(jest.mocked(Stack.Screen).mock.calls[0][0]).toEqual({
      name: "(tabs)",
      options: { headerShown: false },
    });
  });
});
