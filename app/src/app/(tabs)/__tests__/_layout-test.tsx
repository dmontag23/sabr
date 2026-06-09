import { render } from "@testing-library/react-native";
import TabsLayout from "@/app/(tabs)/_layout";
import { Tabs } from "expo-router";

jest.mock("expo-router", () => ({ Tabs: jest.fn() }));

describe("<TabsLayout />", () => {
  test("renders a Tabs navigator with no props", () => {
    render(<TabsLayout />);

    expect(Tabs).toHaveBeenCalledTimes(1);
    expect(jest.mocked(Tabs).mock.calls[0][0]).toEqual({});
  });
});
