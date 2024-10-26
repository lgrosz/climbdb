-- Deploy climb-pg:climb-font-grades to pg
-- requires: climbs
-- requires: font-letter-enum

BEGIN;

CREATE TABLE climb_font_grades (
    id SERIAL PRIMARY KEY,
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE cascade,
    value INTEGER NOT NULL CHECK (value >= 1),
    plus BOOLEAN NOT NULL,
    letter FONT_LETTER,
    UNIQUE (climb_id, value, plus, letter)
);

CREATE FUNCTION check_font_letter()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.value > 5 AND NEW.letter IS NULL THEN
        RAISE EXCEPTION 'all grades >F5 must have a letter';
    ELSIF NEW.value <= 5 AND NEW.letter IS NOT NULL THEN
        RAISE EXCEPTION 'all grades <F6A must not have a letter';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_letter_constraint
    BEFORE INSERT OR UPDATE ON climb_font_grades
    FOR EACH ROW EXECUTE FUNCTION check_font_letter();

COMMIT;
