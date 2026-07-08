import { Pressable, Text, PressableProps } from "react-native";

type Props = PressableProps & { title: string };

/*
 Note that, on Android, the RN Button puts the button text in all caps by default.
 So this button is created instead to ensure the text is not capitalized.
 TODO: Replace with a component from a component library.
*/
export const Button = ({ title, ...props }: Props) => (
  <Pressable accessibilityRole="button" {...props}>
    <Text>{title}</Text>
  </Pressable>
);
