-- Create the table with specific column names
CREATE TABLE staging_table (
	"Depth" TEXT, 
	"POINTID" TEXT, 
	"pH_CaCl2" TEXT, 
	"pH_H2O" TEXT, 
	"EC" TEXT, 
	"OC" TEXT, 
	"CaCO3" TEXT, 
	"P" TEXT, 
	"N" TEXT, 
	"K" TEXT, 
	"OC (20-30 cm)" TEXT, 
	"CaCO3 (20-30 cm)" TEXT, 
	"Ox_Al" TEXT, 
	"Ox_Fe" TEXT, 
	"NUTS_0" TEXT, 
	"NUTS_1" TEXT, 
	"NUTS_2" TEXT, 
	"NUTS_3" TEXT, 
	"TH_LAT" TEXT, 
	"TH_LONG" TEXT, 
	"SURVEY_DATE" TEXT, 
	"Elev" TEXT, 
	"LC" TEXT, 
	"LU" TEXT, 
	"LC0_Desc" TEXT, 
	"LC1_Desc" TEXT, 
	"LU1_Desc" TEXT
);

COPY staging_table
FROM '/Users/maxsonntag/Documents/GitHub/SOC_predictor/data/lucas_db/LUCAS-SOIL-2018.csv'
DELIMITER ',' 
CSV HEADER;

-- Create the table with specific column names
CREATE TABLE lucas_main (
	"Depth" VARCHAR NOT NULL, 
	"POINTID" INTEGER NOT NULL, 
	"pH_CaCl2" DOUBLE PRECISION, 
	"pH_H2O" DOUBLE PRECISION, 
	"EC" DOUBLE PRECISION, 
	"OC" DOUBLE PRECISION, 
	"CaCO3" DOUBLE PRECISION, 
	"P" TEXT, 
	"N" TEXT, 
	"K" TEXT, 
	"OC (20-30 cm)" TEXT, 
	"CaCO3 (20-30 cm)" TEXT, 
	"Ox_Al" DOUBLE PRECISION, 
	"Ox_Fe" DOUBLE PRECISION, 
	"NUTS_0" VARCHAR NOT NULL, 
	"NUTS_1" VARCHAR NOT NULL, 
	"NUTS_2" VARCHAR NOT NULL, 
	"NUTS_3" VARCHAR NOT NULL, 
	"TH_LAT" DOUBLE PRECISION NOT NULL, 
	"TH_LONG" DOUBLE PRECISION NOT NULL, 
	"SURVEY_DATE" DATE NOT NULL, 
	"Elev" INTEGER NOT NULL, 
	"LC" VARCHAR NOT NULL, 
	"LU" VARCHAR NOT NULL, 
	"LC0_Desc" VARCHAR NOT NULL, 
	"LC1_Desc" VARCHAR NOT NULL, 
	"LU1_Desc" VARCHAR NOT NULL
);

-- Insert from staging table with transformation to date
INSERT INTO lucas_main ("Depth", 
	"POINTID", 
	"pH_CaCl2", 
	"pH_H2O", 
	"EC", 
	"OC", 
	"CaCO3", 
	"P", 
	"N", 
	"K", 
	"OC (20-30 cm)", 
	"CaCO3 (20-30 cm)", 
	"Ox_Al", 
	"Ox_Fe", 
	"NUTS_0", 
	"NUTS_1", 
	"NUTS_2", 
	"NUTS_3", 
	"TH_LAT", 
	"TH_LONG", 
	"SURVEY_DATE",
	"Elev", 
	"LC", 
	"LU", 
	"LC0_Desc", 
	"LC1_Desc", 
	"LU1_Desc"
)
SELECT
    "Depth",
    "POINTID"::INTEGER,
    CASE WHEN "pH_CaCl2" IN ('', 'NA') THEN NULL ELSE "pH_CaCl2"::DOUBLE PRECISION END,
    CASE WHEN "pH_H2O" IN ('', 'NA') THEN NULL ELSE "pH_H2O"::DOUBLE PRECISION END,
    CASE WHEN "EC" IN ('', 'NA') THEN NULL ELSE "EC"::DOUBLE PRECISION END,
    CASE WHEN "OC" IN ('', 'NA', '< LOD', '<0.0') THEN NULL ELSE "OC"::DOUBLE PRECISION END,
    CASE WHEN "CaCO3" IN ('', 'NA', '<  LOD') THEN NULL ELSE "CaCO3"::DOUBLE PRECISION END,
    "P",
    "N",
    "K",
    "OC (20-30 cm)",
    "CaCO3 (20-30 cm)",
    CASE WHEN "Ox_Al" IN ('', 'NA') THEN NULL ELSE "Ox_Al"::DOUBLE PRECISION END,
    CASE WHEN "Ox_Fe" IN ('', 'NA') THEN NULL ELSE "Ox_Fe"::DOUBLE PRECISION END,
    "NUTS_0",
    "NUTS_1",
    "NUTS_2",
    "NUTS_3",
    CASE WHEN "TH_LAT" IN ('', 'NA') THEN NULL ELSE "TH_LAT"::DOUBLE PRECISION END,
    CASE WHEN "TH_LONG" IN ('', 'NA') THEN NULL ELSE "TH_LONG"::DOUBLE PRECISION END,
    TO_DATE("SURVEY_DATE", 'DD-MM-YY'),
    CASE WHEN "Elev" IN ('', 'NA') THEN NULL ELSE "Elev"::INTEGER END,
    "LC",
    "LU",
    "LC0_Desc",
    "LC1_Desc",
    "LU1_Desc"
FROM staging_table;