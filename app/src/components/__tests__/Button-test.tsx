import { render } from "@testing-library/react-native";
import { Button } from "@/components/Button";

describe("<Button />", () => {
  test("renders the text as-written verbatim on every platform (without automatic capitalization on android)", () => {
    const { getByText } = render(<Button title="Send me a code" />);

    expect(getByText("Send me a code")).toBeVisible();
  });

  test("is exposed as a button via accessibility roles", () => {
    const { getByRole } = render(<Button title="Send me a code" />);

    expect(getByRole("button")).toBeVisible();
    expect(getByRole("button")).toHaveTextContent("Send me a code");
  });
});
