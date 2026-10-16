# Kroger API feasibility spike

**Date:** 2026-10-15  
**Status:** OpenAPI review complete; live access check pending developer credentials.

## Question

Can a self-service Kroger API app retrieve store-specific product prices and package sizes for a worker to use alongside manually entered prices?

## Findings

- Kroger's public developer setup requires an account and a registered application to obtain OAuth credentials. The product and location endpoints require OAuth.
- The supplied Kroger public Products API OpenAPI spec is version 1.3.0, with production and certification servers. It documents OAuth client credentials with the `product.compact` scope.
- The spec explicitly says a `filter.locationId` is required for store-specific price, availability, aisle, and inventory fields. The public item schema includes `price.regular`, `price.promo`, `regularPerUnitEstimate`, `promoPerUnitEstimate`, and price effective/expiration dates when available. It also includes package `size`, `soldBy` (typically `weight` or `unit`), item ID/UPC, stock level, and fulfillment flags.
- The spec notes that seasonal items only have a price when available, and some items lack national prices. The price per-unit estimate is described as estimated, so recipe costing should use package price and package size when they can be parsed reliably, and preserve the returned estimate as a separate field otherwise.
- The supplied spec documents a Public Products API quota of 10,000 calls per day across operations on `/products` and fuzzy search whose ordering can change between requests.
- Kroger's separate **Partner APIs** documentation says Partner API access requires a contractual agreement and is not available through self-service app registration. This is distinct from the supplied public Products API spec, which explicitly includes local price fields.
- A live call with this project's credentials has not been made, so account-level access, actual response completeness, and current rate-limit behavior remain unverified.
- No Kroger credentials or Kroger-specific environment variables are configured in this workspace. I could not make an authenticated call to check actual account access or response data.

## Decision

The documented public API supports the data the worker needs, so a limited proof of concept is justified. Before enabling scheduled refreshes or persisting recurring price observations, make a live public-app call and review Kroger's current acceptable-use terms for the intended automated use, display, persistence, and retention behavior. If the account does not return prices or the terms do not allow the planned usage, do not build the worker on that assumption.

## Live verification checklist

Using credentials kept locally and never committed:

1. Request an OAuth client-credentials token with the product-read scope shown in Kroger's current public setup guide.
2. Search locations near a ZIP code and retain a real `locationId`.
3. Search a common product at that location, then inspect each returned `items[]` entry for `itemId`, `size`, `soldBy`, `price.regular`, `price.promo`, per-unit estimates, dates, UPC, and availability. Do not assume the first item is the right package or that every price field is present.
4. Verify the app receives those fields and note any 401/403 response, missing fields, and observed quota headers.
5. Review Kroger's current Public API acceptable-use terms for automated refreshes, displaying prices, storing observations, and retention before enabling a worker.

## Sources

- [Kroger Public APIs setup and collection](https://www.postman.com/kroger/the-kroger-co-s-public-workspace/documentation/ki6utqb/kroger-public-apis)
- Supplied [Kroger Products API OpenAPI specification](</home/simon/Documents/Projects/openapi.json>) (v1.3.0)
- [Kroger Partner APIs documentation](https://www.postman.com/kroger/the-kroger-co-s-public-workspace/documentation/nryx3kn/kroger-partner-apis)
- [Kroger Public API account and application setup](https://www.postman.com/kroger/the-kroger-co-s-public-workspace/overview)
- [Kroger Public API acceptable-use policy](https://developer.kroger.com/documentation/public/getting-started/acceptable-use)
