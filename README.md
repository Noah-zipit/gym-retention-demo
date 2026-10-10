# RetainFit — Gym Retention OS (pitch demo)

A Flutter demo built for pitching gym owners: a mobile-first retention
dashboard that turns the four problems every gym loses money to into four
screens they can see themselves using.

## The four screens

- **Dashboard** — the day's numbers at a glance with an animated hero visual
  (code-built, zero assets), and a shortcut into the Red List.
- **Red List** — members absent 10+ days, sorted by risk, with a
  one-tap "contacted" / reminder flow so nobody slips through.
- **Check-in** — QR check-in with streaks that keep members coming back.
- **Renewals** — memberships expiring soon, so renewals happen before the
  member leaves, not after.
- **Add-ons** — PT, diet-plan and protein upsells tracked per member.

Demo data is seeded relative to "today" (`lib/data/demo_data.dart`), so the
screens always look alive — no fixture dates to rot.

## Run it

```sh
flutter pub get
flutter run
```

Flutter web is the pitch target (phone browser):

```sh
flutter build web --wasm   # output lands in dist/, served by vercel.json
```

## Notes

- `publish_to: none` — private demo, not a pub.dev package.
- Custom theme in `lib/theme.dart`; all artwork is code-built.
