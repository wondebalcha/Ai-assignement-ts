# Explanation

## What was the bug?

When `api: true`, the `HttpClient.request()` method only refreshed the token if it was missing or an expired `OAuth2Token`. If the token was a plain object (for example from JSON), the refresh did not run and the `Authorization` header was never added to the request.

## Why did it happen?

The code relied on `instanceof OAuth2Token` to check whether the token could be validated and used to build the authorization header. A plain object is still truthy, but it does not pass the `instanceof` check. Because of this, the code skipped both the refresh logic and the header creation.

## Why does your fix solve it?

The fix treats any value that is not an `OAuth2Token` instance as invalid for API requests and forces a token refresh. After refreshing, the token becomes a valid `OAuth2Token`, allowing the `Authorization` header to be set correctly.

## Edge case not covered

One edge case not covered is when `opts.headers` is reused across multiple requests. The tests do not verify whether modifying the same headers object could cause side effects.