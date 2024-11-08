-- Deploy climb-pg:climb-yds-grades to pg
-- requires: climbs
-- requires: yds-letter-enum

BEGIN;

CREATE TABLE climb_yds_grades (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE cascade,
    value INTEGER NOT NULL CHECK (value >= 1),
    letter YDS_LETTER,
    UNIQUE (climb_id, value, letter)
);

CREATE FUNCTION check_yds_letter()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.value > 9 AND NEW.letter IS NULL THEN
        RAISE EXCEPTION 'all grades >5.9 must have a letter';
    ELSIF NEW.value <= 9 AND NEW.letter IS NOT NULL THEN
        RAISE EXCEPTION 'all grades <5.10a must not have a letter';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_letter_constraint
    BEFORE INSERT OR UPDATE ON climb_yds_grades
    FOR EACH ROW EXECUTE FUNCTION check_yds_letter();

COMMIT;
