# Recipe pricing and Kroger worker

## Apply the migration

From the repository root, run:

```sh
docker compose exec backend npx typeorm-ts-node-commonjs migration:run -d src/data-source.ts
```

The migration adds a Kroger location ID to store locations, a per-product sync opt-in, and a source field on price observations (existing rows are marked `manual`).

## Configure and run the worker

Add `KROGER_CLIENT_ID` and `KROGER_CLIENT_SECRET` to `backend/.env.dev`. The API URLs, sync interval, and item limit have production defaults in `backend/.env.example`; override them only when needed. Keep `backend/.env.dev` out of version control. Use the Kroger API host/token URL that matches the app credentials you received. Then restart/start the worker:

```sh
docker compose up -d --build worker
docker compose logs -f worker
```

The worker reads products whose `kroger_sync_enabled` flag is true and whose UPC is set, and store locations whose `kroger_location_id` is set under the Kroger retailer. It queries one product at one location per request, records the promotional price when present (otherwise regular price), and adds an observation only when the price changes. It is idle when credentials are missing. The per-cycle cap and interval limit how quickly requests are made.

To opt a product in, enter its UPC and select **Sync prices from Kroger** in the product form. To map a store, select the Kroger location ID when adding a Kroger store or use **Map store** / **Edit mapping** in the product's price view. Syncing requires both a mapped Kroger store and an opted-in product with a UPC.

## Recipe pricing endpoint

Call the authenticated endpoint:

```http
GET /api/recipes/{recipeId}/pricing?storeLocationId={storeLocationId}
```

For each recipe line it uses the newest price observation for each linked product at the selected store, converts the recipe quantity to the product's package unit, and chooses the lowest calculated line cost. Matching unit types use their shared base conversion; cross-type conversions require a saved ingredient-specific conversion. The response includes per-line issues, a known subtotal, and `totalCost`/`costPerServing` only when every line can be priced.
