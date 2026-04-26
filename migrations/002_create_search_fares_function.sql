CREATE OR REPLACE FUNCTION search_fares(
    p_origin VARCHAR(3) DEFAULT NULL,
    p_destination VARCHAR(3) DEFAULT NULL,
    p_departure_date_from DATE DEFAULT NULL,
    p_departure_date_to DATE DEFAULT NULL,
    p_return_date_from DATE DEFAULT NULL,
    p_return_date_to DATE DEFAULT NULL,
    p_cabin_class VARCHAR(20) DEFAULT NULL,
    p_airline VARCHAR(100) DEFAULT NULL,
    p_max_predicted_price DECIMAL(10, 2) DEFAULT NULL,
    p_limit INTEGER DEFAULT 50
)
RETURNS TABLE (
    id INTEGER,
    origin VARCHAR(3),
    destination VARCHAR(3),
    departure_date DATE,
    return_date DATE,
    predicted_price DECIMAL(10, 2),
    current_price DECIMAL(10, 2),
    lowest_price DECIMAL(10, 2),
    highest_price DECIMAL(10, 2),
    airline VARCHAR(100),
    cabin_class VARCHAR(20),
    prediction_confidence DECIMAL(5, 2),
    predicted_at TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        fp.id,
        fp.origin,
        fp.destination,
        fp.departure_date,
        fp.return_date,
        fp.predicted_price,
        fp.current_price,
        fp.lowest_price,
        fp.highest_price,
        fp.airline,
        fp.cabin_class,
        fp.prediction_confidence,
        fp.predicted_at,
        fp.created_at,
        fp.updated_at
    FROM fare_predictions fp
    WHERE (p_origin IS NULL OR fp.origin = UPPER(p_origin))
      AND (p_destination IS NULL OR fp.destination = UPPER(p_destination))
      AND (p_departure_date_from IS NULL OR fp.departure_date >= p_departure_date_from)
      AND (p_departure_date_to IS NULL OR fp.departure_date <= p_departure_date_to)
      AND (
          p_return_date_from IS NULL
          OR (fp.return_date IS NOT NULL AND fp.return_date >= p_return_date_from)
      )
      AND (
          p_return_date_to IS NULL
          OR (fp.return_date IS NOT NULL AND fp.return_date <= p_return_date_to)
      )
      AND (p_cabin_class IS NULL OR LOWER(fp.cabin_class) = LOWER(p_cabin_class))
      AND (p_airline IS NULL OR LOWER(fp.airline) = LOWER(p_airline))
      AND (p_max_predicted_price IS NULL OR fp.predicted_price <= p_max_predicted_price)
    ORDER BY fp.departure_date ASC, fp.predicted_price ASC, fp.predicted_at DESC
    LIMIT GREATEST(COALESCE(p_limit, 50), 1);
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION search_fares(VARCHAR, VARCHAR, DATE, DATE, DATE, DATE, VARCHAR, VARCHAR, DECIMAL, INTEGER)
IS 'Search fare_predictions with optional filters for route, dates, cabin class, airline, and max predicted price.';
