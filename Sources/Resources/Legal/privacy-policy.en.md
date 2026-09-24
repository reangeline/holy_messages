# Missale Privacy Policy

**Last updated: 25 September 2026**

This policy describes the Missale app for iPhone and iPad. It was written from
the app's source code rather than from a template: everything the app stores is
listed in `Sources/Models/LocalData.swift`, and an automated test fails if the
app starts storing something that is not in this policy.

## The short version

Missale asks for an account, created with Sign in with Apple. That account is
the only thing the app sends to a server of ours: the identifier Apple gives us
and, if you choose to share it, your email (which may be an Apple relay
address).

**Nothing you write or log leaves your device.** Your notes, the Examen, your
"Today I am…" log, your rosaries and your progress stay only on your iPhone, as
they always have.

## What is stored on your device

Everything below stays in the app's local storage, on your device.

**What you write and log**

- Your "Today I am…" log: the state you chose, the date, and the optional note
  you type.
- Your written answers in the daily Examen: gratitude, request for light,
  review, and response.
- The rosaries you log, with the mystery, the mode, and the intention when you
  write one.
- Your Formation progress: which parts you completed, and in what order.
- In the Bible, the verses you highlighted and the chapter marked as "where I
  stopped".
- What you completed of "Your day with God" each day (for the last 60 days),
  what you wrote you hope for each day in the Morning Offering, and how far
  you've read in the New Testament.
- The days you completed "Your day with God" (the date only), used to ask for
  an App Store rating once, on the third day.
- The name you type in Settings, used only to greet you by name in the app.

**Your preferences**

- The language you chose for the app.
- The regional liturgical calendar you chose.
- Whether the Rosary's beginner mode is on.
- Whether you have finished the introduction.
- The times you chose for the daily reading notice.

The language setting lives in storage shared between the app and its widgets,
so the widget appears in the same language. That sharing is local, on your
device.

## What the app does not do

- **It does not send what you write.** Notes, the Examen, your log and your
  progress stay on your device.
- **No sync.** Nothing is copied to another device by us.
- **No analytics, telemetry, or third-party trackers.** No analytics,
  advertising, or attribution SDK is included.
- **No ads.**
- **We do not sell, rent, or share data.**
- **No access** to your contacts, calendar, photos, microphone, camera, or
  location.

## Your account

To use Missale you sign in with **Sign in with Apple**. There is no password of
ours: Apple is the one confirming it is you.

**What our server receives and keeps**

- The identifier Apple creates for you in Missale (a code that works in no
  other app).
- Your email, only if you choose to share it on Apple's screen. Apple lets you
  hide your email; in that case we receive a relay address.
- The date the account was created.

**On your device**, the account session (the keys that prove to the server
that you signed in) is kept in the iPhone Keychain, encrypted, on this device
only, outside backups and iCloud.

**Where it lives.** The server runs on Amazon Web Services (AWS), in the United
States, which processes this data on our behalf. By creating the account you
agree to this international transfer, made to provide the service you asked
for.

**For how long.** Until you delete the account. We do not use this data for
advertising, do not sell it and do not combine it with anything.

**The app only talks to the Missale server**, and only to sign in, keep the
session and delete the account. An automated test fails if networking code
appears anywhere else in the app.

## Notifications

If you allow it, the app schedules the Angelus reminders on your iPhone, at
6am, noon, and 6pm. Those reminders are created and fired by the iPhone itself,
from the liturgical calendar that ships inside the app. There is no
notification server, nothing is sent to us, and we do not learn whether you
received, opened, or ignored a reminder. You can withdraw permission at any
time in iPhone Settings.

## Links to sources

Saint records, the Examen, the apparitions, and the readings name the editions
and documents their text came from, and some carry a link. Tapping a link opens
that source's website in your browser — the Holy See, a shrine, a public
archive. From there, that site's privacy policy applies, not this one. The app
sends none of your data through those links.

## Subscription

Missale offers an optional subscription. Purchase, billing, renewal, and
cancellation are handled entirely by the **Apple App Store**. We never see or
store your billing name, card, address, or any payment detail. The app asks the
App Store only whether an active subscription exists on this device, in order
to unlock the corresponding content.

Apple's handling of your payment data is governed by Apple's privacy policy.

## Deleting your data

**Deleting the account**: in **Settings › Account › Delete account**. This
erases from our server everything it keeps about you (the Apple identifier, the
email if any, and the creation date) and ends the session on this device. It
does not cancel a subscription: that belongs to the App Store and is cancelled
there.

**Deleting the app from your device removes everything it saved there** — your
notes, your log, your progress, your name and the session. The account on the
server remains until you delete it, in the app or by writing to the contact
below.

In **Settings › Your data** you can also:

- **Export your data**: a JSON file with everything you wrote and recorded,
  handed to the iOS share sheet for you to keep or send wherever you want. The
  file is made on the device and only leaves it if you send it.
- **Delete your data**: removes from the device, at once, everything listed
  under "What you write and log" above. Your preferences (language,
  calendar, times) stay. It cannot be undone.

## Children

Missale is not directed at children and does not knowingly collect data from
anyone under 13. If you learn of an account created by a child, write to the
contact below and it will be deleted.

## Your rights (GDPR, CCPA, LGPD)

For the account data described above, **we are the controller**. The GDPR, CCPA
and LGPD give you rights of access, correction, deletion and portability over
it. You can delete the account at any time in the app, and ask for access,
correction or deletion through the contact below.

What you write and log never reaches us: it stays under your own control, on
your device, and goes with the app when you delete it.

## Changes to this policy

If the app begins storing or sending anything different, this policy will be
updated before the version that does so reaches the App Store, and the date at
the top will change.

## Contact

ola@missale.app
