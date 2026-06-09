import { render } from "@testing-library/react-native";
import LoggedOutLandingScreen from "@/app/(public)/index";
import { Link } from "expo-router";

jest.mock("expo-router", () => ({ Link: jest.fn() }));

describe("<LoggedOutLandingScreen />", () => {
  test("links to the email auth screen", () => {
    render(<LoggedOutLandingScreen />);

    expect(Link).toHaveBeenCalledTimes(1);
    expect(jest.mocked(Link).mock.calls[0][0]).toEqual({
      href: "/auth/email",
      children: "Continue with email",
    });
  });
});
