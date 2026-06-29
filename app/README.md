# sabr mobile app

This is an [Expo](https://expo.dev) project created with [`create-expo-app`](https://www.npmjs.com/package/create-expo-app).

## Installing Node, Node Version Manager (nvm), Corepack, and pnpm

[Node.js](https://nodejs.org/en) is a JavaScript runtime environment that allows developers to run JavaScript code outside of the browser. Many tools - such as frameworks like React and package managers like pnpm - run on Node, and so Node needs to be installed on your machine in order to write or run Expo code locally.

Node is installed via [nvm](https://github.com/nvm-sh/nvm). nvm can be installed by following instructions [here](https://github.com/nvm-sh/nvm/?tab=readme-ov-file#installing-and-updating). The [.nvmrc file](.nvmrc) manages the global Node version. Run `nvm install` in this directory to use the correct node version.

This project uses [pnpm](https://pnpm.io/) as the package manager. To install pnpm, Corepack (which automatically comes with Node) needs to be enabled. This is done by running `corepack enable` in the terminal. Enabling Corepack allows pnpm to be automatically installed the first time a you use a `pnpm` command.

After enabling corepack, run `pnpm i` from this directory to install the necessary dependencies.

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

## Running code from PRs on your phone

Every PR opened against the `develop` branch gets a comment with a QR code. Scanning it on your phone loads the app with that code. The app communicates with a **local** Supabase instance running on your laptop.

All PR builds are hardcoded to reach http://sabr-dev.local:54321, so you need to ensure your laptop can be reached at that URL.

To do so:

1. On a Mac, run

```bash
sudo scutil --set LocalHostName sabr-dev
```

Or got to System Settings → General → Sharing and scroll down to "Local hostname". Click "Edit..." to set the name to `sabr-dev`.

2. Start a local supabase instance:

```bash
supabase start
```

3. Confirm the backend is reachable by inputting the following URL into a browser on your phone

```bash
http://sabr-dev.local:54321/auth/v1/health
```

## Distributing builds to testers

3 different versions of the app - called "variants" - can exist on the same physical device. The variant describes the environment, and each variant is given its own identifier, set in [app.config.ts](app.config.ts):

| Variant (`APP_VARIANT`) | Identifier             | How testers download this app version                                                                                         |
| ----------------------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| development             | `app.sabr.development` | PR QR codes (downloaded via the internal dev client).                                                                         |
| staging                 | `app.sabr.staging`     | iOS: TestFlight. Android: EAS [internal distribution link](https://docs.expo.dev/tutorial/eas/internal-distribution-builds/). |
| production              | `app.sabr`             | iOS: App Store. Android: Google Play.                                                                                         |

`APP_VARIANT` is a Terraform-managed GitHub environment variable in ([infra/github/secrets.tf](/infra/github/secrets.tf)) pushed to EAS by the [create-and-push-env-file](/.github/actions/create-and-push-env-file/action.yml) action. When not set, [app.config.ts](app.config.ts) defaults `APP_VARIANT` to `development`.

Most of the time, merging to the `develop` branch publishes an EAS Update to the `staging` channel, which is auto-delivered to installed staging apps on both platforms. When the native fingerprint changes, CI builds a new version of the app; the iOS app is submitted to TestFlight automatically, and the new Android APK is available via its EAS build link (TODO: Make this available to testers on the `internal` track of the Play Store - note this requires an additional Android build).

### iOS staging app (TestFlight) — one-time setup

1. Enroll in the [Apple Developer Program](https://developer.apple.com/programs/).
2. Create two [App Store Connect](https://appstoreconnect.apple.com/) apps: `app.sabr` and `app.sabr.staging`. Put each Apple ID into the matching `ascAppId` in [eas.json](eas.json).
3. Create and store the App Store Connect API key on EAS by running `eas credentials --platform ios` in the `app` directory.
4. On App Store Connect, in the `app.sabr.staging` app, go to the TestFlight tab → INTERNAL TESTING, create a group named `Staging Testers` and add testers.
