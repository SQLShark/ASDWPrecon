USE AdventureWorks;
GO

SELECT
    [Name]
	, Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace([Name],'Bikes','Brooms'),'Bikes','Brooms'),'Bike','Brrom'),'Components','Wands'),'Component','Wand'),'Clothing','Capes'),'Accessories','Runes'),'Road','Quiddich'),'Chains','Magic Accelarator'),'Mountain','Nimbus'),'Frame','Broom'),'Jerseys','cloaks'),'Vests','Capes'),'Hydration','Potion'),'Lights','Eluminators'),'Pumps','Leviation device')

FROM
    Production.ProductCategory;

-- #######################################################################################################################################
-- Update 
-- #######################################################################################################################################

UPDATE Production.ProductCategory SET [Name] = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace([Name],'Bikes','Brooms'),'Bikes','Brooms'),'Bike','Brrom'),'Components','Wands'),'Component','Wand'),'Clothing','Capes'),'Accessories','Runes'),'Road','Quiddich'),'Chains','Magic Accelarator'),'Mountain','Nimbus'),'Frame','Broom'),'Jerseys','cloaks'),'Vests','Capes'),'Hydration','Potion'),'Lights','Eluminators'),'Pumps','Leviation device')