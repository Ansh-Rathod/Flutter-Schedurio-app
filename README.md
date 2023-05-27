# Schedurio

An open-source Tweet scheduler app for Twitter content creators. Built with [supabase](https://supabase.com/) and flutter.

# Team details

Solo Participate.

- [@Ansh-Rathod](https://github.com/Ansh-Rathod) on github Only.
- [@anshrathodfr](https://twitter.com/anshrathodfr) on twitter.

## About the app.

The app is very helpful for Twitter content creators who are paying monthly for services like Hypefury, Feedhive, and many others, now they can use the Schedurio open-source app on their desktop by adding their own API keys. currently available for the Macos and web.

**Features**

- Add your Twitter API keys and schedule tweets ahead of time.
- Write long threads.
- **Makes the Schedule more natural and less robotic**
  • If your schedule contains multiple round times, such as 9:00 AM, 1:30 PM, and 7:00 PM, it lacks realness and this will provide some variance and make it feel more authentic.
  • It will change every time slot of your schedule to a new time in a range of ± 5 minutes of the original time.
  • Example: 1:00 PM will be changed to a time between 12:55 PM and 1:05 PM.
- post instantly with the post now button.
- save to draft.
- analyze your daily tweet streak and find your best tweets.
- history (to check your previous status of tweets)
- for Twitter blue users it changes the characters limit to 10000.

## Link to hosted demo

NOTE: link to hosted demo is not available because it is an open-source project and Twitter API keys and (access tokens) should not be shared with anyone. you have to deploy your own supabase project (which is a very easy step) and edit the AppConfig file. View the demo or setup video for more details.

## Demo video


https://user-images.githubusercontent.com/67627096/232454769-b99192f9-35c2-42e0-98ea-ffef5f05af3a.mp4

# Use of supabase

The app has wide use of the supabase. services the app uses of supabase.

- supabase database.
  - Obviously supabase database for storing queues, tweets, and other info.
- supabase edge functions ( to post scheduled tweets).
  - supabase edge functions became very handy once you started writing them. created an edge function that can call the Twitter API and post tweets. (All edge functions are built using dart_edge by [https://docs.dartedge.dev/platform/supabase](https://docs.dartedge.dev/platform/supabase))
- supabase storage (to store scheduled media of tweets).
  - supabase storage is used for storing media files of tweets until they get uploaded to Twitter API.
- [pg_net](https://supabase.com/docs/guides/database/extensions/pgnet) extension to call the edge function from the DB.
  - This extension is very useful to call the Edge function from the database.

## Workflow (How scheduling works under the hood using supabase)

1. user added a tweet → it gets added to the queue table.
2. The queue table triggers the Postgres function which creates a cron task ([pg_cron](https://supabase.com/docs/guides/database/extensions/pgcron)) to schedule the tweet at the selected time.
3. when the cron job fires up the function it calls the supabase edge function using the pg_net extension.
4. And this is how the tweets get posted.

## How to run the app.

in order to run the app make you have all the requirements on your machine.

**Requirements**

- Git installed
- supabase cli.
- Twitter developer account.
- supabase account.
- docker (only if you like to test them on the localhost)
- flutter stable (3.7.9)

**Brief steps.**

- Clone the repo.
- Deploy supabase.
- Create bucket named `public` in supabase storage.
- Add supabase URL and **service key in the app/lib/config.dart file**
- Hit the flutter run.

# Setup video

## important links

[https://developer.twitter.com/en/portal/dashboard](https://developer.twitter.com/en/portal/dashboard)




[POST media/upload](https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload)

[POST /2/tweets](https://developer.twitter.com/en/docs/twitter-api/tweets/manage-tweets/api-reference/post-tweets)

[Dart Edge | Supabase Docs](https://supabase.com/docs/guides/functions/dart-edge)

[pg_net: Async Networking | Supabase Docs](https://supabase.com/docs/guides/database/extensions/pgnet)

[pg_cron: Job Scheduling | Supabase Docs](https://supabase.com/docs/guides/database/extensions/pgcron)

[https://supabase.com/docs/guides/cli/local-development](https://supabase.com/docs/guides/cli/local-development)
