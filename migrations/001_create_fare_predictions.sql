-- Create fare_predictions table
CREATE TABLE IF NOT EXISTS fare_predictions (
    id SERIAL PRIMARY KEY,
    origin VARCHAR(3) NOT NULL,
    destination VARCHAR(3) NOT NULL,
    departure_date DATE NOT NULL,
    return_date DATE,
    predicted_price DECIMAL(10, 2) NOT NULL,
    current_price DECIMAL(10, 2),
    lowest_price DECIMAL(10, 2),
    highest_price DECIMAL(10, 2),
    airline VARCHAR(100),
    cabin_class VARCHAR(20) DEFAULT 'economy',
    prediction_confidence DECIMAL(5, 2),
    predicted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for common queries
CREATE INDEX idx_fare_predictions_route ON fare_predictions(origin, destination);
CREATE INDEX idx_fare_predictions_departure ON fare_predictions(departure_date);
CREATE INDEX idx_fare_predictions_airline ON fare_predictions(airline);
CREATE INDEX idx_fare_predictions_predicted_at ON fare_predictions(predicted_at);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_fare_predictions_updated_at
    BEFORE UPDATE ON fare_predictions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create view for price analysis
CREATE OR REPLACE VIEW fare_price_analysis AS
SELECT 
    origin,
    destination,
    airline,
    cabin_class,
    DATE_TRUNC('month', departure_date) AS month,
    AVG(predicted_price) AS avg_predicted_price,
    AVG(current_price) AS avg_current_price,
    MIN(lowest_price) AS min_price,
    MAX(highest_price) AS max_price,
    COUNT(*) AS prediction_count
FROM fare_predictions
GROUP BY origin, destination, airline, cabin_class, DATE_TRUNC('month', departure_date);

COMMENT ON TABLE fare_predictions IS 'Stores airline fare predictions and historical pricing data';
COMMENT ON COLUMN fare_predictions.origin IS 'IATA airport code for departure';
COMMENT ON COLUMN fare_predictions.destination IS 'IATA airport code for arrival';
COMMENT ON COLUMN fare_predictions.prediction_confidence IS 'Confidence score (0-100) for the prediction';
