create table "public"."tweets" (
    "id" character varying not null,
    "scraped_at" timestamp with time zone default now(),
    "posted_at" timestamp with time zone,
    "content" text,
    "media" jsonb,
    "polls" jsonb,
    "public_metrics" jsonb,
    "author_id" character varying
);


CREATE UNIQUE INDEX tweets_pkey ON public.tweets USING btree (id);

alter table "public"."tweets" add constraint "tweets_pkey" PRIMARY KEY using index "tweets_pkey";


