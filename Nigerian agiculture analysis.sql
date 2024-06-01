
SELECT *
FROM nigeria_agricultural_exports

--a.) SALES PERFOMANCE

--What are top selling products ?
	SELECT Product_Name,FORMAT(SUM(Units_Sold*Unit_Price),'c','ng-ng') AS Revenue
	FROM nigeria_agricultural_exports
	GROUP BY Product_Name
	ORDER BY 2 DESC;


--Which company has the highest sales revenue?
	SELECT Company,FORMAT(SUM(Units_Sold*Unit_Price),'c','ng-ng') AS Revenue
	FROM nigeria_agricultural_exports
	GROUP BY Company
	ORDER BY 2 DESC;


--How do sales vary across different export countries?
SELECT Export_Country,FORMAT(SUM(Export_Value),'c') AS Sales
FROM nigeria_agricultural_exports
GROUP BY Export_Country
ORDER BY 2 DESC;

--Product category
--Average revenue per country 
--Total units sold
SELECT Product_Name,FORMAT(AVG(Export_Value),'c')AS Avg_Revenue,SUM(Units_Sold) AS Total_Units_Sold
FROM nigeria_agricultural_exports
GROUP BY Product_Name
ORDER BY 3 DESC;
	
--b.) GEOGRAPHICAL Data	

--Which destination ports receive the highest volume of exports?
		SELECT Destination_Port,SUM(Units_Sold) AS Volume_Of_Exports
		FROM nigeria_agricultural_exports
		GROUP BY Destination_Port
		ORDER BY 2 DESC;

--Rank the destination port by the export value.
--Show the top export product for each port
			WITH Port_Export_Value AS(
			SELECT Destination_Port,
			Product_Name,
			Export_Value,
			Units_Sold,
			RANK() OVER(
						PARTITION BY Product_Name ORDER BY Export_Value DESC )
			AS Rank
			FROM  nigeria_agricultural_exports)

			SELECT Destination_Port,
			Product_Name,
			Export_Value,
			Units_Sold
FROM Port_Export_Value
WHERE Rank=1
ORDER BY 3 DESC;


--c.)COST ANALYSIS

--What is the cost of goods sold as a percentage of revenue?
	SELECT ROUND(SUM(Units_Sold*(Unit_Price-Profit_per_unit))/SUM(Export_Value)*100,2) AS Percentage_of_Revenue
	FROM nigeria_agricultural_exports;

--How does the COGS vary across different products?
	SELECT Product_Name,ROUND(SUM(
	Units_Sold*(Unit_Price-Profit_per_unit))/
	SUM(Export_Value)*100,2) AS Percentage_of_Revenue
	FROM nigeria_agricultural_exports
	GROUP BY Product_Name
	ORDER BY 2 desc;

	--d.)Perfomance_Comparison
	--How does each product perform in terms of profit margin?
	SELECT Product_Name,ROUND(SUM(Units_Sold*Profit_per_unit)/SUM(Export_Value)*100,2) AS Profit_Margin
	FROM nigeria_agricultural_exports
	GROUP BY Product_Name
	ORDER BY 2 DESC;

	--Can we compare the perfomance of different companies based on units sold and profit generated?
	SELECT Company,SUM(Units_Sold)AS Total_Sales,FORMAT(ROUND(sum(Units_Sold*Profit_per_unit),2),'c','ng-ng') AS Profit
	FROM nigeria_agricultural_exports
	GROUP BY Company
	ORDER BY 2 DESC;

	
--d.) TIME SERIES
--How do sales vary annually?
	WITH Yearly_Sales AS(
	SELECT
	year,
	SUM(Units_Sold)AS Total_Sales
	FROM nigeria_agricultural_exports
	GROUP BY year)

	SELECT *,
	LAG(Total_Sales) OVER( ORDER BY year) last_Year_Sales,
	LAG(Total_Sales) OVER( ORDER BY year)-Total_Sales diff_Of_sales
	FROM Yearly_Sales;


--Extracting  year and month from  date
	ALTER TABLE nigeria_agricultural_exports add month varchar (50);
	UPDATE nigeria_agricultural_exports set month=MONTH(DATE);

	ALTER TABLE nigeria_agricultural_exports add year VarChar(50);
	UPDATE nigeria_agricultural_exports set year=YEAR(Date);
