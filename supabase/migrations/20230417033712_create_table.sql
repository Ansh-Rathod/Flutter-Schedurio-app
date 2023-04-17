set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.schedule_tweet_post(name text, expression text, queue_id integer, user_id integer, headers_input text, url text, body text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    PERFORM cron.schedule (
        name, -- name of the cron job with dynamic value
        expression, -- Saturday at 3:30am (GMT)
         'select net.http_post(
            url:='''||url||''',
            headers:='''|| headers_input||'''::jsonb,
            body:='''||body|| '''::jsonb,
            timeout_milliseconds:=10000
        ) as request_id;' 
    );
END;
$function$
;


