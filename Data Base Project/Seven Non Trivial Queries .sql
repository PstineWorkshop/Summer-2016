
/*For each query I have a description followed by the actual query. After the actual query I have small sample of what the result sets would look like if you ran the query.

--First Query
/*
This query gives shows the position players that have more 30 or more home runs in a season and driven in 100 or more runs in a season.
It also shows how many games they played that year in addition to batting average. The year in which the stats come from is listed as well.
This is important because it shows which position players from an offensive perspective are worth keeping down the road.
This query can be used to help figure out who is the most valuable player for each season. 
*/
SELECT  p.player_first_name, p.player_last_name,s.years, s.stat_hr, 
   s.stat_rbi,s.stat_g,TO_CHAR (s.stat_avg,9.999) AS stat_avg_fixed
FROM STATS s
  JOIN PLAYER p
      ON s.player_id=p.player_id
  WHERE s.stat_hr >=30  AND s.stat_rbi >=100
 
  ORDER BY s.years DESC, s.stat_hr DESC;
--Sample Result Sets
/*
Charlie	Beard	2014	77	233	162	  .445
Philip	Howell	2014	76	175	148	  .400
Rick	Brinkman	2014	66	154	159	  .435
Omar	Infante	2014	64	160	150	  .393
Miguel	Cabrera	2014	58	164	145	  .413
Rocco	Baldelli	2014	57	129	160	  .376
Patrick	Smith	2014	37	113	113	  .426
Omar	Infante	2013	73	182	147	  .417
Philip	Howell	2013	71	188	147	  .463
Miguel	Cabrera	2013	70	175	152	  .407
Rocco	Baldelli	2013	63	162	147	  .461
Charlie	Beard	2013	57	161	162	  .400
Rick	Brinkman	2013	53	161	153	  .416
Patrick	Smith	2013	45	119	119	  .444
Philip	Howell	2012	83	213	147	  .441
Miguel	Cabrera	2012	74	161	154	  .418
Rocco	Baldelli	2012	68	180	158	  .419
Omar	Infante	2012	55	173	157	  .377
Garret	Anderson	2012	46	143	162	  .424
Charlie	Beard	2012	44	151	162	  .412
Rick	Brinkman	2012	42	113	137	  .386
*/


--Second Query
/*
	This select statements gives the totals number of selected stats for the players. 
It is filtered by only showing players who total runs batted in are 100 and above, or have 60 or more total career strikeouts.
To make this more interesting it also shows the total amount of years that the player has played for the respective team.
This gives perspective on how much a player accomplishes in his amount of time with the club.
This table is a great way to show who are the best players to have played for this team. 
*/
SELECT 
	p.player_first_name, 
	p.player_last_name,
	COUNT(s.years) AS total_number_of_seasons,
	SUM(stat_hr) AS total_home_runs,
	SUM(s.stat_rbi)AS total_runs_batted_in,
	TO_CHAR(AVG(s.stat_avg),9.999) AS average_batting_average,
	SUM(s.stat_w) AS total_wins,
	SUM(s.stat_sop) AS total_strikeouts,
	TO_CHAR(AVG(s.stat_era),9.99) AS average_earn_runs,
	SUM(s.stat_g) || '' AS total_games_played 
FROM STATS s
  JOIN PLAYER p
    ON p.player_id=s.player_id
GROUP BY p.player_first_name, p.player_last_name
HAVING SUM(s.stat_sop) >=60 OR SUM(s.stat_rbi)>=100
ORDER BY sum(s.stat_sop) DESC, SUM(s.stat_rbi) DESC;

--Sample Result Sets
/*
Philip	Howell	3	230	576	  .435				442
Charlie	Beard	3	178	545	  .419				486
Omar	Infante	3	192	515	  .396				454
Miguel	Cabrera	3	202	500	  .413				451
Rocco	Baldelli	3	188	471	  .419				465
Rick	Brinkman	3	161	428	  .412				449
Patrick	Smith	3	109	330	  .422				345
Garret	Anderson	1	46	143	  .424				162
Gavin	Floyd	3	6	36	  .238	102	1286	  .96	101
Johan	Santana	3	2	32	  .287	88	698	 1.86	101
Roy	Walters	3	4	33	  .216	87	452	 2.64	99
Doug	Borland	2	6	30	  .302	54	400	 2.01	62
Bob	Mccormick	2	0	7	  .584	41	335	 2.27	54
Jake	Peavy	1	3	16	  .198	33	236	 1.16	37
Charlie	Sager	3	0	1	  .292	1	82	 1.74	94
Tim	Flaherty	1	1	5	  .462	0	68	  .51	44
Jack	Cox	3	0	0	  .250	5	62	 2.43	67
Carl	Herndon	1	0	3	  .660	2	60	  .21	31      
*/  
  
--Third Query
/*
	This select statement gives an abbreviated version of the war stat. 
This stat is responsible for telling the general manger how valuable the player is to the team. 
This select statement calculates, how much a pitcher's win total for a given season contributes to the team's overall wins for that season. 
But since I rounded the numbers to make output readable, the numbers only add to 95 percent instead of 100 percent. 
This statement is important because it shows who is pulling their weight in helping the team reach their win total. 
That kind of information is useful when discussing extensions, higher contracts and if necessary releasing a player from the team.
*
*
*/
SELECT DISTINCT
  p.player_first_name,
  p.player_last_name,
 (s.years - TO_NUMBER(TO_CHAR(p.player_birth_date, 'yyyy'))) AS age,
  s.stat_w,
  s.years,
  r.wins AS season_wins,
  TO_CHAR((s.stat_w/r.wins*100),999) AS WAR
FROM PLAYER p
  JOIN STATS s
    ON p.player_id=s.player_id
 JOIN RESULTS r
    ON r.years=s.years
WHERE s.stat_w>0 
ORDER BY TO_CHAR((s.stat_w/r.wins*100),999);

--Sample Result Sets
/*
Gavin	Floyd	29	38	2012	155	  25
Gavin	Floyd	31	38	2014	155	  25
Johan	Santana	33	36	2012	155	  23
Roy	Walters	25	34	2012	155	  22
Jake	Peavy	31	33	2012	155	  21
Doug	Borland	26	29	2014	155	  19
Gavin	Floyd	30	26	2013	144	  18
Roy	Walters	26	26	2013	144	  18
Doug	Borland	25	25	2013	144	  17
Johan	Santana	34	25	2013	144	  17
Johan	Santana	35	27	2014	155	  17
Roy	Walters	27	27	2014	155	  17
Bob	Mccormick	26	22	2013	144	  15
Bob	Mccormick	27	19	2014	155	  12
Ray	Wilson	33	6	2012	155	   4
Jack	Cox	27	4	2013	144	   3
Earl	Estrada	25	5	2013	144	   3
Earl	Estrada	26	4	2014	155	   3
Alan	Rivera	25	3	2013	144	   2
Rip	Bernard	27	2	2013	144	   1
Bernie	Cooper	29	2	2012	155	   1
Bernie	Cooper	31	1	2014	155	   1
Jack	Cox	26	1	2012	155	   1
Earl	Estrada	24	1	2012	155	   1
Carl	Herndon	25	2	2014	155	   1
Brandon	Mccarthy	30	2	2013	144	   1
Milt	Ryan	30	2	2014	155	   1
Charlie	Sager	29	1	2014	155	   1
*/


--Fourth Query
/*
	This query shows the total amount of home runs for all the players that bat on both sides of the plate (switch hitter).
 Switch hitters are a unique brand of hitter, so evaluating how well they hit like most stats gives the general manger a good idea about who actually hits well as a switch hitter and who does not.
 Also helps the manager so he knows which players to put in for certain match ups. Obviously having a switch hitter gives you even more flexibility than normal especially if they are a good hitter.

*/
SELECT 
  first_name,
  last_name,
  MAX(total_hr) AS max_hr,
  bats
FROM 
  (SELECT 
    SUM(s.stat_hr)AS total_hr,
    p.player_first_name AS first_name, 
    p.player_last_name AS last_name,
    p.player_bats AS bats
    FROM STATS s
  JOIN PLAYER p
    ON p.player_id=s.player_id
  GROUP BY
    p.player_first_name,
    p.player_last_name,
    p.player_bats)
WHERE bats='switch'
GROUP BY first_name,last_name,bats

--Sample Result Sets
/*
FIRST_NAME   LAST_NAME  MAX_HR  BATS
Dick			Johnson		13	switch
Rick			Brinkman	161	switch
Rip				Bernard		 0	switch
Carl			Herndon		 0	switch
Jose			Reyes		10	switch
Philip			Howell		230	switch
*/

--Fifth Query
/*
	This shows the total payroll for the team per year and give results for that same team during that same year. 
This shows if the team did better or worse with a smaller or larger payroll.
*/

  SELECT 'HOME RUN' AS kind_of_stat, TO_CHAR(SUM(stat_hr),999) AS totals,years
  FROM STATS 
  WHERE stat_hr<500
  GROUP BY years,'HOME RUN'
    UNION
  SELECT 'WINS' AS kind_of_stat, TO_CHAR((wins),999) AS totals, years
  FROM RESULTS
  WHERE wins <479
    UNION
  SELECT 'PAYROLL' AS kind_of_stat, TO_CHAR(SUM(assignment_salary),'$999,999,999.999') AS totals, years
  FROM  ASSIGNMENT
  WHERE assignment.assignment_salary >500
  GROUP BY years,'PAYROLL'
    UNION
  SELECT 'WS' AS kind_of_stat, ws,years
  FROM RESULTS
  ORDER BY years;


--Sample Result Sets
/*
KIND_OF_STAT   TOTALS           YEARS
HOME RUN       492              2012
PAYROLL        $78,300,000.000  2012
WINS           155              2012
WS             yes              2012
HOME RUN	   479	            2013
PAYROLL	       $78,010,000.000	2013
WINS	 	   144	            2013
WS	           yes	            2013
HOME RUN	   482	            2014
PAYROLL	       $80,670,000.000	2014
WINS	       155	            2014
WS	           yes	            2014
*/   
  
--Sixth Query
/*
This select statement gives all the stats for the players and specifically gives how much each player averages a year for a specific stat.
This is a good way to keep tract of the player's progress and it is a good way to make predictions about what they will do in the future. 
That information comes in handy when many players on the team have only one year left on their contract and the general manager must decide on which players to resign and which ones to let go.
*/

SELECT  
	p.player_first_name, 
	p.player_last_name,
	TO_CHAR(AVG(s.stat_w),999) avg_wins,
	TO_CHAR(AVG(s.stat_era),9.99) AS avg_era, 
	TO_CHAR(AVG(s.stat_sop),999.99) AS avg_sop,
	TO_CHAR(AVG(s.stat_sv),99) AS avg_sv,
	TO_CHAR(AVG(s.stat_hr),99.99) AS avg_hr , 
	TO_CHAR(AVG(s.stat_avg),.999) As avg_avg ,
	TO_CHAR(AVG(s.stat_rbi),999.99) As avg_rbi,
	TO_CHAR(AVG(s.stat_g),999) AS avg_g,
	a.assignment_position
FROM PLAYER p
  JOIN STATS s
    ON p.player_id=s.player_id
  JOIN ASSIGNMENT a
    ON a.player_id=p.player_id
 GROUP BY a.assignment_position, p.player_first_name, p.player_last_name
 ORDER BY p.player_last_name;    

--Sample Result Sets for the player with no value for avg_era, avg_sop, avg_wins and avg_sv the values are null
/*
Garret	Anderson					 46.00	 .424	 143.00	 162	right field
Rocco	Baldelli					 62.67	 .419	 157.00	 155	center field
Charlie	Beard					 59.33	 .419	 181.67	 162	first base
Rip	Bernard	   1	 2.07	  19.00	  0	   .00	 .584	    .00	  26	Middle Relief
Doug	Borland	  27	 2.01	 200.00	  0	  3.00	 .302	  15.00	  31	Starting Left Hand Pitcher
Rick	Brinkman					 53.67	 .412	 142.67	 150	right field
Miguel	Cabrera					 67.33	 .413	 166.67	 150	left field
Bernie	Cooper	   1	  .92	  19.00	  2	   .00	 .111	    .00	  33	Set Up Man
Jack	Cox	   2	 2.43	  20.67	  0	   .00	 .250	    .00	  22	Set Up Man
George	Cross					 14.00	 .324	  73.00	 121	short stop
Rupert	Dowd					  2.67	 .324	  24.00	  64	short stop
Rupert	Dowd					  2.67	 .324	  24.00	  64	utility infielder
Earl	Estrada	   3	 1.69	  18.33	  0	   .00	 .209	   1.33	   8	Long Relief
Tim	Flaherty	   0	  .51	  68.00	 44	  1.00	 .462	   5.00	  44	Closer
Gavin	Floyd	  34	  .96	 428.67	  0	  2.00	 .238	  12.00	  34	Starting Right Hand Pitcher
Howie	Franklin					 13.00	 .353	  38.50	  65	first base
Scott	Gray					  7.00	 .352	  22.00	  46	third base
Carl	Herndon	   2	  .21	  60.00	  3	   .00	 .660	   3.00	  31	Middle Relief
Philip	Howell					 76.67	 .435	 192.00	 147	third base
Omar	Infante					 64.00	 .396	 171.67	 151	second base
Dick	Johnson	   0	 3.05	  54.00	  0	   .00	 .000	    .00	  55	Middle Relief
Dick	Johnson					  4.33	 .326	  20.33	  52	outfield
Johnny	Latham					  7.00	 .352	  20.00	  63	utility infielder
Brandon	Mccarthy	   2	  .00	   5.00	  0	   .00	 .000	    .00	   4	Long Relief
Bob	Mccormick	  21	 2.27	 167.50	  1	   .00	 .584	   3.50	  27	Starting Left Hand Pitcher
Yadier	Molina					 22.00	 .333	  50.00	 113	catcher
Jake	Peavy	  33	 1.16	 236.00	  0	  3.00	 .198	  16.00	  37	Starting Right Hand Pitcher
Brandon	Philips					  9.00	 .312	  49.00	 115	utility infielder
Jose	Reyes					 10.00	 .365	  40.00	  84	short stop
Alan	Rivera	   2	 1.99	  26.50	 12	   .00	 .200	    .00	  29	Set Up Man
Rene	Rivera					  2.00	 .211	  19.00	  55	catcher
Milt	Ryan	   2	  .68	   8.00	  1	   .00	 .000	    .00	   9	Long Relief
Charlie	Sager	   0	 1.74	  27.33	 16	   .00	 .292	    .33	  31	Closer
Charlie	Sager	   0	 1.74	  27.33	 16	   .00	 .292	    .33	  31	Middle Relief
Johan	Santana	  29	 1.86	 232.67	  0	   .67	 .287	  10.67	  34	Starting Left Hand Pitcher
Patrick	Smith					 36.33	 .422	 110.00	 115	catcher
Roy	Walters	  29	 2.64	 150.67	  0	  1.33	 .216	  11.00	  33	Starting Right Hand Pitcher
Ray	Wilson	   6	 5.30	  54.00	  0	   .00	 .125	    .00	  17	Long Relief

*/
 
 --Seventh Query  
/*
This select statement shows all the players who have made more than five million dollars in one season. 
It also shows what their age was when they got that money and what position they were being paid to play.
This gives a good perspective on what the team values more. You see this by which positions on team got paid more money
*/
SELECT DISTINCT 
  player_first_name, 
  player_last_name,  
  a.assignment_position,
 TO_CHAR(a.assignment_salary, '$999,999,999.999') AS assignment_salary_format,
  s.years, 
(s.years -TO_NUMBER(TO_CHAR(p.player_birth_date, 'yyyy'))) AS age

FROM PLAYER p
  JOIN ASSIGNMENT a
    ON p.player_id=a.player_id
  JOIN SEASON s
    ON a.years=s.years
  JOIN STATS s
    ON s.player_id= p.player_id
WHERE a.assignment_salary >= 5000000
ORDER BY TO_CHAR(a.assignment_salary, '$999,999,999.999')  DESC;
  
--Sample Result Sets
/*
Jake	Peavy	Starting Right Hand Pitcher	  $10,860,000.000	2012	31
Omar	Infante	second base	   $8,300,000.000	2012	30
Omar	Infante	second base	   $8,030,000.000	2013	31
Omar	Infante	second base	   $8,030,000.000	2014	32
Rocco	Baldelli	center field	   $7,440,000.000	2012	31
Rocco	Baldelli	center field	   $7,440,000.000	2013	32
Rocco	Baldelli	center field	   $7,440,000.000	2014	33
Johan	Santana	Starting Left Hand Pitcher	   $7,010,000.000	2014	35
Johan	Santana	Starting Left Hand Pitcher	   $6,710,000.000	2012	33
Johan	Santana	Starting Left Hand Pitcher	   $6,710,000.000	2013	34
Patrick	Smith	catcher	   $6,620,000.000	2013	28
Patrick	Smith	catcher	   $6,620,000.000	2014	29
Charlie	Sager	Closer	   $5,890,000.000	2013	28
Charlie	Sager	Closer	   $5,890,000.000	2014	29
Bernie	Cooper	Set Up Man	   $5,730,000.000	2013	30
Bernie	Cooper	Set Up Man	   $5,730,000.000	2014	31
Charlie	Beard	first base	   $5,600,000.000	2014	32
Miguel	Cabrera	left field	   $5,570,000.000	2013	30
Miguel	Cabrera	left field	   $5,570,000.000	2014	31
Tim	Flaherty	Closer	   $5,480,000.000	2012	27
*/  
  
  
  
  
    
  

   
  