# Explanation

## What was the bug?

When `api: true`, `HttpClient.request()` mutated the caller-provided `opts.headers` object by adding an `Authorization` key. This caused surprising side effects when the same headers object was reused across requests.

Additionally, if `oauth2Token` was a plain object (e.g. from JSON), it could not be used to build an authorization header.

## Why did it happen?

`opts.headers` was assigned directly to a local variable and then modified in-place. Because objects are passed by reference, callers saw their input object changed.

For the token case, the code relied on `instanceof OAuth2Token`. A plain object is truthy but fails the `instanceof` check, so it must be treated as invalid and refreshed.

## Why does your fix solve it?

The fix clones `opts.headers` before adding `Authorization`, so the returned request headers include auth without mutating the caller’s object.

It also treats any non-`OAuth2Token` value as invalid for API requests and forces a refresh, ensuring an `Authorization` header can be set.

## Edge case not covered

One edge case not covered is concurrent API requests that race and trigger multiple refreshes; the current code is not designed for deduping refresh calls.