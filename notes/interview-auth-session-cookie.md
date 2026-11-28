# Interview story: login session lost through Firebase Hosting

## Situation

Recipe Cost uses a React frontend on Firebase Hosting and a Node/Express API on Cloud Run. Terraform manages the Cloud Run service, and Express stores sessions in PostgreSQL with `connect-pg-simple`.

## Symptom

Login returned successfully and the UI showed the user as signed in, but the ingredients request returned `401 Please log in.` The login UI state came from the user object in the login response; it did not confirm that the browser's session cookie was reaching the API.

## Root cause

Firebase Hosting rewrites `/api/**` requests to the Cloud Run backend. Firebase Hosting only forwards the specially named `__session` cookie to Cloud Run. The API had named its Express cookie `recipe.sid`, so the hosting proxy stripped it before the next authenticated request reached Express. The backend therefore could not associate that request with the session saved at login.

## Fix and deployment

- Renamed the Express session cookie to `__session` and used the same name when clearing it on logout.
- Kept the production cookie secure and Express proxy trust enabled for HTTPS traffic through Cloud Run.
- Built and pushed a uniquely tagged backend image to Artifact Registry, updated the backend image reference in Terraform, and applied Terraform to create a new Cloud Run revision.
- Left the Firebase Hosting rewrite unchanged; only the backend image needed redeployment.
- Corrected a typo in the registry hostname during the first push attempt: `use-east5-docker.pkg.dev` should be `us-east5-docker.pkg.dev`.

## Interview answer (about 45 seconds)

“I deployed a React app on Firebase Hosting with an Express API on Cloud Run. Users could log in and the UI looked authenticated, but the next API request failed with a 401. I traced it through the browser and backend: the UI trusted the login response, while the API depended on a session cookie. Firebase Hosting only forwards a cookie named `__session` to Cloud Run, but my Express session cookie had a custom name, so the proxy dropped it. I renamed the cookie and updated logout to clear the same cookie, then built a versioned backend image and used Terraform to roll out a new Cloud Run revision. After redeploying, the session cookie reached the API and authenticated requests worked.”

## Takeaways

- A signed-in UI does not prove the server will recognize the next request; verify the full cookie round trip.
- Check hosting proxy behavior and request/response headers when authentication works locally but fails after deployment.
- Use a new image tag when deploying through Terraform so the desired image change is explicit and produces a new Cloud Run revision.
