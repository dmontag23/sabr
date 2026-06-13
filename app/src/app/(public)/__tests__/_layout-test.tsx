import { render } from "@testing-library/react-native";
import PublicLayout from "@/app/(public)/_layout";
import { Stack } from "expo-router";

jest.mock("expo-router", () => ({ Stack: jest.fn() }));

describe("<PublicLayout />", () => {
  test("renders a Stack navigator with no props", () => {
    render(<PublicLayout />);

    expect(Stack).toHaveBeenCalledTimes(1);
    expect(jest.mocked(Stack).mock.calls[0][0]).toEqual({});
  });
});
