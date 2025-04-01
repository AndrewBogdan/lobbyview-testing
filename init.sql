/*
 Initialization for mock LobbyView database. This is run when the dockerfile is run if
 the data volume is empty.
 */

/* =====================================================================================
   ----- Create the reports table ------------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS reports
(
    report_uuid        uuid PRIMARY KEY,
    lob_id             uuid,
    registrant_id      int,
    registrant_name    text,
    filing_year        int,
    filing_period_code text,
    /* In the codebook, amount is an int because the data is rounded to the nearest $10k
       However, it's stored in the csv with .00 at the end, so I can't simply copy it
       TODO: Figure out how to typecast to int properly. */
    amount             numeric,
    is_no_activity     bool,
    is_self_filer      bool,
    is_amendment       bool,
    filing_url         text
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


/* =====================================================================================
   ----- Create the bills table --------------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS bills
(
    bill_id             text PRIMARY KEY,
    bill_chamber        text,
    bill_type           text,
    bill_number         int,
    congress_number     int,
    introduced_date     date,
    last_updated_status text,
    summary_text        text,
    bioguide_id         text,
    first_name          text,
    last_name           text
);

COPY bills (
            bill_id,
            bill_chamber,
            bill_type,
            bill_number,
            congress_number,
            introduced_date,
            last_updated_status,
            summary_text,
            bioguide_id,
            first_name,
            last_name
    )
    FROM '/data/bills.csv'
    DELIMITER ','
    CSV HEADER;


/* =====================================================================================
   ----- Create the clients table ------------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS clients
(
    lob_id      uuid PRIMARY KEY,
    gvkey       text,
    bvdid       text,
    naics       text,
    client_name text
);

COPY clients (
              lob_id,
              gvkey,
              bvdid,
              naics,
              client_name
    )
    FROM '/data/clients.csv'
    DELIMITER ','
    CSV HEADER;


/* =====================================================================================
   ----- Create the issue_text table ---------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS issue_text
(
    id                     int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    report_uuid            uuid,
    general_issue_code     text,
    issue_ordinal_position int,
    bill_id_agg            text[],
    issue_text             text
);

COPY issue_text (
                 report_uuid,
                 general_issue_code,
                 issue_ordinal_position,
                 bill_id_agg,
                 issue_text
    )
    FROM '/data/issue_text.csv'
    DELIMITER ','
    CSV HEADER;


/* =====================================================================================
   ----- Create the issues table -------------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS issues
(
    id                     int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    report_uuid            uuid,
    general_issue_code     text,
    issue_ordinal_position int,
    government_entity_ids  int[]
);

COPY issues (
             report_uuid,
             general_issue_code,
             issue_ordinal_position,
             government_entity_ids
    )
    FROM '/data/issues.csv'
    DELIMITER ','
    CSV HEADER;


/* =====================================================================================
   ----- Create the lobbyists table ----------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS lobbyists
(
    lobbyist_id      uuid PRIMARY KEY,
    first_name       text,
    middle_name      text,
    last_name        text,
    full_name        text,
    gov_agencies     text[],
    committees       text[],
    legislators      text[],
    gender           text,
    ethnicity        text,
    party            text,
    all_filing_years int[]
);

COPY lobbyists (
                lobbyist_id,
                first_name,
                middle_name,
                last_name,
                full_name,
                gov_agencies,
                committees,
                legislators,
                gender,
                ethnicity,
                party,
                all_filing_years
    )
    FROM '/data/lobbyists.csv'
    DELIMITER ','
    CSV HEADER;


/* =====================================================================================
   ----- Create the network table ------------------------------------------------------
   ================================================================================== */

CREATE TABLE IF NOT EXISTS network
(
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lob_id      uuid,
    bioguide_id text,
    year        int,
    n_bills     int
);

COPY network (
              lob_id,
              bioguide_id,
              year,
              n_bills
    )
    FROM '/data/network.csv'
    DELIMITER ','
    CSV HEADER;
