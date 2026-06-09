import { render } from "@testing-library/react-native";
import HomeScreen from "@/app/(tabs)/index";

describe("<HomeScreen />", () => {
  test("renders the home text", () => {
    const { getByText } = render(<HomeScreen />);

    expect(getByText("Home")).toBeVisible();
  });
});
