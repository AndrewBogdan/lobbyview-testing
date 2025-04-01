/* =====================================================================================
   ----- Create the reports table ------------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS reports (
    report_uuid UUID PRIMARY KEY,
    lob_id UUID,
    registrant_id INT,
    registrant_name TEXT,
    filing_year INT,
    filing_period_code TEXT,
    /* In the codebook, amount is an INT because the data is rounded to the nearest $10k
       However, it's stored in the csv with .00 at the end, so I can't simply copy it
       TODO: Figure out how to typecast to INT properly. */
    amount FLOAT,
    is_no_activity BOOL,
    is_self_filer BOOL,
    is_amendment BOOL,
    filing_url TEXT
);

COPY reports (
    report_uuid,
    lob_id,
    registrant_id,
    registrant_name,
    filing_year,
    filing_period_code,
    amount,
    is_no_activity,
    is_self_filer,
    is_amendment,
    filing_url
)
FROM '/data/reports.csv'
DELIMITER ','
CSV HEADER;
