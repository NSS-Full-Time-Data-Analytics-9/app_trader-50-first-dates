--App Trader
--Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made 
--available through the Apple App Store and Android Play Store.   

--App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchases. --The apps' developers retain all money from users purchasing the app from the relevant app store, and they retain half of the
--money made from in-app purchases. App Trader will be solely responsible for marketing any apps they purchase the rights to.

--Unfortunately, the data for Apple App Store apps and the data for Android Play Store apps are located in separate tables with no --referential integrity.

--1. Loading the data
	--a. Launch PgAdmin and create a new database called app_trader.

	--b. Right-click on the app_trader database and choose Restore...

	--c. Use the default values under the Restore Options tab.

	--d. In the Filename section, browse to the backup file app_store_backup.backup in the data folder of this repository.

	--e. Click Restore to load the database.

	--f. Verify that you have two tables:
		-- app_store_apps with 7197 rows
		-- play_store_apps with 10840 rows

--2. Assumptions
--Based on research completed prior to launching App Trader as a company, you can assume the following:

	--a. App Trader will purchase the rights to apps for 10,000 times the list price of the app on the Apple App Store/Google Play --Store, however the minimum price to purchase the rights to an app is $25,000. For example, a $3 app would cost $30,000 (10,000 x --the price) and a free app would cost $25,000 (The minimum price). NO APP WILL EVER COST LESS THEN $25,000 TO PURCHASE.

	--b. Apps earn $5000 per month on average from in-app advertising and in-app purchases regardless of the price of the app.

	--c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader
	---owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

	--d. For every quarter-point that an app gains in rating, its projected lifespan increases by 6 months, in other words, an app --with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an --app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.25 to evaluate an app's
	--likely longevity.

	--e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can 
	--market both for the same $1000 per month.

--3. Deliverables
	--a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that --the company should target.

	--b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole
	--priority.

	--c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically
	--appropriate for next months's Pi Day themed campaign.

	--c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of --their cost and potential profits. All analysis work must be done using PostgreSQL, however you may export query results to
	--create charts in Excel for your report.
	
	SELECT name, play_store_apps.rating AS play_store, app_store_apps.rating AS app_store, play_store_apps.price, app_store_apps.price
	FROM app_store_apps
	INNER JOIN play_store_apps
	USING (name)
	WHERE play_store_apps.rating >4.5 OR app_store_apps.rating >4.5

WITH app_store AS
	(SELECT name, price, rating, review_count::numeric
	FROM app_store_apps
	WHERE rating > 4.4 
	ORDER by rating DESC)
SELECT name, play_store_apps.price, play_store_apps.rating, play_store_apps.review_count
	FROM play_store_apps
	INNER JOIN app_store
	USING (name)
	WHERE play_store_apps.rating > 4.4
	ORDER by rating DESC
	
	
	SELECT app_store_apps.name, app_store_apps.price, app_store_apps.rating, play_store_apps.name, play_store_apps.price, 			play_store_apps.rating
	FROM app_store_apps
	INNER JOIN play_store_apps
	USING(name)
	WHERE rating >4.5 AND price < 0.50 
	ORDER by review_count DESC
	
	
	SELECT name, rating, app_store_apps.review_count::integer, play_store_apps.review_count
	FROM app_store_apps
	INNER JOIN play_store_apps
	USING(name, rating)
	ORDER BY rating DESC
	
	SELECT name, rating
	FROM app_store_apps
	INNER JOIN play_store_apps
	USING(name)
	ORDER BY rating DESC
	
	SELECT *
	FROM app_store_apps
	ORDER BY rating DESC
	-- ratings go from 5 down to 4.5. There is no 4.75 in this app
	
	SELECT *
	FROM play_store_apps
	ORDER BY rating DESC NULLS LAST
	
	
	WITH app_store AS
	(SELECT name, price, rating, review_count::numeric
	FROM app_store_apps
	WHERE rating > 4.4 AND price < 2.51
	ORDER by rating DESC)
SELECT name, play_store_apps.price, play_store_apps.rating, play_store_apps.review_count
	FROM play_store_apps
	INNER JOIN app_store
	USING (name)
	WHERE play_store_apps.rating > 4.4
	GROUP by name, play_store_apps.price, play_store_apps.rating, play_store_apps.review_count
	ORDER by rating DESC
	LIMIT 15;
	
	
	SELECT DISTINCT name, 
	   asa.rating AS asa_rating, 
	   psa.rating AS psa_rating, 
	   (asa.rating + psa.rating)/2 AS avg_rating,
	   asa.price,
	   psa.price
   	  FROM app_store_apps AS asa
INNER JOIN play_store_apps AS psa 
		   USING (name)
WHERE asa.price < 2.5
GROUP BY name, asa_rating, psa_rating, asa.price, psa.price
ORDER BY avg_rating DESC, asa_rating DESC, psa_rating DESC;






SELECT name, rating,
CASE WHEN rating = 5 THEN 198000
     WHEN rating > 4.7 THEN 189000
	 WHEN rating >+ 4.5 THEN 180000
	 ELSE 0 END AS asa_profit
FROM app_store_apps
ORDER by asa_profit DESC

SELECT name, rating,
CASE WHEN rating = 5 THEN 198000
     WHEN rating > 4.7 THEN 189000
	 WHEN rating >+ 4.5 THEN 180000
	 ELSE 0 END AS psa_profit
FROM play_store_apps
ORDER by play_profit DESC

SELECT *
FROM app_store_apps

CASE WHEN asa.price <= 2.50 THEN 25000
     WHEN asa.price >2.50 THEN asa.price * 10000 
     WHEN psa.price::numeric <= 2.5 THEN 25000
	 WHEN psa.price::numeric >2.5 THEN psa.price::numeric * 10000 END AS cost_to_purchase,
CASE WHEN (asa.rating + psa.rating)/2 >= 4.75 THEN 504000
     WHEN (asa.rating + psa.rating)/2 >= 4.5 THEN 480000
	 WHEN (asa.rating + psa.rating)/2 >= 4.25 THEN 456000 ELSE 0 END AS cumaltive_income



SELECT DISTINCT name, 
	   asa.rating AS asa_rating, 
	   psa.rating AS psa_rating, 
	   (asa.rating + psa.rating)/2 AS avg_rating,
	   asa.price,
	   psa.price, asa.primary_genre, psa.category, psa.genres, asa.content_rating, psa.content_rating,
CASE WHEN asa.price <= 2.50 THEN 25000
     WHEN asa.price >2.50 THEN asa.price * 10000 
	  WHEN psa.price::numeric <= 2.5 THEN 25000
	 WHEN psa.price::numeric >2.5 THEN psa.price::numeric * 10000 END AS cost_to_purchase,
CASE WHEN (asa.rating + psa.rating)/2 >= 4.75 THEN 504000
     WHEN (asa.rating + psa.rating)/2 >= 4.5 THEN 480000
	 WHEN (asa.rating + psa.rating)/2 >= 4.25 THEN 456000 ELSE 0 END AS cumalative_income
FROM app_store_apps AS asa
INNER JOIN play_store_apps AS psa 
		   USING (name)
WHERE ((asa.rating + psa.rating)/2) >= 4.5
AND asa.price <= 2.50
GROUP BY name, asa_rating, psa_rating, asa.price, psa.price, asa.review_count, psa.review_count, asa.primary_genre, psa.genres, psa.category, asa.content_rating, psa.content_rating
ORDER BY avg_rating
LIMIT 50


WITH roys_table AS
(SELECT DISTINCT name,
	   asa.rating AS asa_rating,
	   psa.rating AS psa_rating,
	   (asa.rating + psa.rating)/2 AS avg_rating,
	   asa.price::money AS asa_price,
	   psa.price::money AS psa_price,
	   (((FLOOR (((asa.rating + psa.rating)/2)/0.25)*0.25)/.25*6)+12) AS months,
	   (((((FLOOR (((asa.rating + psa.rating)/2)/0.25)*0.25)/.25*6)+12) * 4000)-25000)::money AS potential_profit, asa.primary_genre, psa.category, psa.genres
FROM app_store_apps AS asa
INNER JOIN play_store_apps AS psa
		   USING (name)
WHERE ((asa.rating + psa.rating)/2) >= 4.5
GROUP BY name, asa_rating, psa_rating, asa.price, psa.price, asa.review_count, psa.review_count, asa.primary_genre, psa.category, psa.genres
ORDER BY potential_profit DESC, avg_rating DESC, asa_rating DESC, psa_rating DESC)

SELECT primary_genre, COUNT(primary_genre) AS count_primary, genres, COUNT(genres) AS count_genres, COUNT(category) AS play_store, category
FROM roys_table
GROUP by primary_genre, genres
ORDER BY count_primary DESC, count_genres DESC, DESC



	
		
	
	
	
