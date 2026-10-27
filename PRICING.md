# Recipe pricing and USDA density

The pricing service calculates ingredient costs using product package sizes,
the latest recorded store prices, unit conversions, and a user-confirmed USDA
density when a recipe and package use different weight and volume units.

## Local setup

1. Add `USDA_FDC_API_KEY` and `PRICING_SERVICE_TOKEN` to the root `.env`. The
   pricing service and backend must receive the same token. Keep the USDA key
   on the server; the frontend never receives it.
2. Configure the backend database and session settings in
   `backend/.env.dev` using `backend/.env.example` as a reference.
3. Start the application with `docker compose up --build`.
4. Apply the new density table migration with
   `docker compose exec backend npm run migration:run`.

## Use the feature

1. Open an ingredient and use **Volume to weight conversion** to search USDA
   FoodData Central.
2. Select the matching food, review one of its supported volume portions, and
   confirm it. The backend saves the USDA food and portion provenance with the
   derived grams-per-milliliter value for the signed-in user.
3. Add product package sizes and store prices as usual. On a recipe page, select
   a store and calculate the recipe cost.
4. If a line cannot be priced, the cost panel identifies whether a product,
   price, or unit conversion is missing. Weight-to-volume conversion uses the
   confirmed density; same-type conversions use the unit definitions.

Density is only used when a recipe unit and product package unit have different
unit types of weight and volume. Count conversions still need an
ingredient-specific conversion.
