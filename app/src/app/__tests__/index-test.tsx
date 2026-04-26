import { render } from "@testing-library/react-native";

import HomeScreen from "@/src/app/index";

describe("<HomeScreen />", () => {
  test("Text renders correctly on HomeScreen", () => {
    const { getByText } = render(<HomeScreen />);

    expect(getByText("Edit app/index.tsx to edit this screen.")).toBeVisible();
  });
});
