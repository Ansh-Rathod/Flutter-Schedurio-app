# Dart frog server for Uploading media to twitter.

NOTE: this server is only to upload the media to twitter. since edge_http_client package doesn't provide multipart/form-data request in edge-runtime i have hosted this server on <code>https://schedurio.anshrathod.com/api/upload_media</code>

## Example

Method: POST
Route_name: /upload_media
header:

```
'Authorization': 'Bearer <supabase service role key/anon key>'
```

body:

```
{

    "supabaseUrl":"https://<project-ref-id>.supabase.co",
    "queueId":"<queue id>",
    "userId":"<user id from info table>"
}

```
