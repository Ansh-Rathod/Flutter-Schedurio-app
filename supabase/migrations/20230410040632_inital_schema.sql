create table "public"."integrations" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone default now(),
    "platform" character varying,
    "keys" jsonb,
    "user" jsonb
);


alter table "public"."integrations" enable row level security;

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


CREATE UNIQUE INDEX integrations_pkey ON public.integrations USING btree (id);

CREATE UNIQUE INDEX tweets_pkey ON public.tweets USING btree (id);

alter table "public"."integrations" add constraint "integrations_pkey" PRIMARY KEY using index "integrations_pkey";

alter table "public"."tweets" add constraint "tweets_pkey" PRIMARY KEY using index "tweets_pkey";


