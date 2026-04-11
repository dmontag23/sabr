# sabr mobile app

This is an [Expo](https://expo.dev) project created with [`create-expo-app`](https://www.npmjs.com/package/create-expo-app).

## Installing Node, Node Version Manager (nvm), Corepack, and pnpm

[Node.js](https://nodejs.org/en) is a JavaScript runtime environment that allows developers to run JavaScript code outside of the browser. Many tools - such as frameworks like React and package managers like pnpm - run on Node, and so Node needs to be installed on your machine in order to write or run Expo code locally.

Node is installed via [nvm](https://github.com/nvm-sh/nvm). nvm can be installed by following instructions [here](https://github.com/nvm-sh/nvm/?tab=readme-ov-file#installing-and-updating). The [.nvmrc file](.nvmrc) manages the global Node version. Run `nvm install` in this directory to use the correct node version.

This project uses [pnpm](https://pnpm.io/) as the package manager. To install pnpm, Corepack (which automatically comes with Node) needs to be enabled. This is done by running `corepack enable` in the terminal. Enabling Corepack allows pnpm to be automatically installed the first time a you use a `pnpm` command.

After enabling corepack, run `pnpm i` from the [frontend](/frontend) directory to install the necessary frontend dependencies.

## Get started

Start the app buy running

```bash
npx expo start
```

In the output, you'll find options to open the app in a

- [development build](https://docs.expo.dev/develop/development-builds/introduction/)
- [Android emulator](https://docs.expo.dev/workflow/android-studio-emulator/)
- [iOS simulator](https://docs.expo.dev/workflow/ios-simulator/)
- [Expo Go](https://expo.dev/go), a limited sandbox for trying out app development with Expo

## Learn more

To learn more about developing your project with Expo, look at the following resources:

- [Expo documentation](https://docs.expo.dev/): Learn fundamentals, or go into advanced topics with our [guides](https://docs.expo.dev/guides).
- [Learn Expo tutorial](https://docs.expo.dev/tutorial/introduction/): Follow a step-by-step tutorial where you'll create a project that runs on Android, iOS, and the web.

## Join the community

Join our community of developers creating universal apps.

- [Expo on GitHub](https://github.com/expo/expo): View our open source platform and contribute.
- [Discord community](https://chat.expo.dev): Chat with Expo users and ask questions.
