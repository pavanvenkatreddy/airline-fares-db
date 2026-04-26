-- Seed data for fare_predictions table

INSERT INTO fare_predictions (
    origin, 
    destination, 
    departure_date, 
    return_date, 
    predicted_price, 
    current_price, 
    lowest_price, 
    highest_price, 
    airline, 
    cabin_class, 
    prediction_confidence
) VALUES
-- New York to Los Angeles routes
('JFK', 'LAX', '2026-06-15', '2026-06-22', 325.00, 349.00, 289.00, 425.00, 'Delta', 'economy', 87.5),
('JFK', 'LAX', '2026-06-15', '2026-06-22', 315.00, 329.00, 289.00, 425.00, 'American Airlines', 'economy', 85.2),
('JFK', 'LAX', '2026-07-04', '2026-07-11', 485.00, 499.00, 425.00, 650.00, 'United', 'economy', 92.1),
('JFK', 'LAX', '2026-08-20', '2026-08-27', 295.00, 310.00, 275.00, 380.00, 'JetBlue', 'economy', 88.7),

-- San Francisco to New York routes
('SFO', 'JFK', '2026-05-10', '2026-05-17', 285.00, 299.00, 265.00, 375.00, 'United', 'economy', 89.3),
('SFO', 'JFK', '2026-05-10', '2026-05-17', 275.00, 289.00, 265.00, 375.00, 'Delta', 'economy', 86.8),
('SFO', 'EWR', '2026-06-01', '2026-06-08', 305.00, 319.00, 285.00, 395.00, 'United', 'economy', 90.5),

-- Chicago to Miami routes
('ORD', 'MIA', '2026-06-20', '2026-06-27', 245.00, 259.00, 225.00, 325.00, 'American Airlines', 'economy', 84.2),
('ORD', 'MIA', '2026-07-15', '2026-07-22', 295.00, 310.00, 275.00, 385.00, 'United', 'economy', 87.9),
('ORD', 'MIA', '2026-12-20', '2026-12-28', 425.00, 449.00, 395.00, 575.00, 'Delta', 'economy', 91.4),

-- London to New York routes
('LHR', 'JFK', '2026-09-05', '2026-09-15', 625.00, 649.00, 575.00, 825.00, 'British Airways', 'economy', 88.6),
('LHR', 'JFK', '2026-09-05', '2026-09-15', 595.00, 619.00, 575.00, 825.00, 'Virgin Atlantic', 'economy', 86.3),
('LHR', 'JFK', '2026-10-12', '2026-10-19', 485.00, 509.00, 445.00, 625.00, 'American Airlines', 'economy', 89.8),

-- Business class routes
('JFK', 'LAX', '2026-06-15', '2026-06-22', 1250.00, 1299.00, 1150.00, 1650.00, 'Delta', 'business', 85.4),
('SFO', 'JFK', '2026-05-10', '2026-05-17', 1175.00, 1225.00, 1095.00, 1550.00, 'United', 'business', 87.2),
('LHR', 'JFK', '2026-09-05', '2026-09-15', 3250.00, 3399.00, 2950.00, 4200.00, 'British Airways', 'business', 90.1),

-- One-way flights
('LAX', 'LAS', '2026-05-25', NULL, 89.00, 99.00, 79.00, 150.00, 'Southwest', 'economy', 83.5),
('ATL', 'ORD', '2026-06-10', NULL, 145.00, 159.00, 135.00, 210.00, 'Delta', 'economy', 86.7),
('DEN', 'PHX', '2026-07-08', NULL, 125.00, 139.00, 115.00, 185.00, 'Southwest', 'economy', 85.1),

-- International routes
('JFK', 'CDG', '2026-08-15', '2026-08-25', 725.00, 759.00, 675.00, 950.00, 'Air France', 'economy', 88.9),
('LAX', 'NRT', '2026-09-20', '2026-10-05', 875.00, 925.00, 795.00, 1250.00, 'Japan Airlines', 'economy', 87.5),
('SFO', 'SYD', '2026-11-10', '2026-11-25', 1150.00, 1225.00, 1050.00, 1550.00, 'Qantas', 'economy', 89.2);

-- Add some historical data points
INSERT INTO fare_predictions (
    origin, 
    destination, 
    departure_date, 
    return_date, 
    predicted_price, 
    current_price, 
    lowest_price, 
    highest_price, 
    airline, 
    cabin_class, 
    prediction_confidence,
    predicted_at
) VALUES
('JFK', 'LAX', '2026-05-01', '2026-05-08', 305.00, 299.00, 275.00, 395.00, 'Delta', 'economy', 86.5, '2026-04-01 10:00:00'),
('JFK', 'LAX', '2026-05-01', '2026-05-08', 310.00, 299.00, 275.00, 395.00, 'Delta', 'economy', 88.2, '2026-04-10 10:00:00'),
('JFK', 'LAX', '2026-05-01', '2026-05-08', 298.00, 299.00, 275.00, 395.00, 'Delta', 'economy', 90.1, '2026-04-20 10:00:00');
