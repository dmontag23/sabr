import { render } from "@testing-library/react-native";
import Index from "@/app/index";

describe("<Index />", () => {
  test("Text renders correctly on HomeScreen", () => {
    const { getByText } = render(<Index />);

    expect(getByText("Edit app/index.tsx to edit this screen.")).toBeVisible();
  });
});
