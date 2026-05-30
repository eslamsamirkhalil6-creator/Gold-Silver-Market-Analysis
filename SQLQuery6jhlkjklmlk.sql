USE GOLD_SILVER_PAT

GO
EXEC SILVER_LOAD_ST
  
GO
CREATE OR ALTER PROCEDURE SILVER_LOAD_ST AS
BEGIN
 DECLARE @START_LOAD DATETIME , @END_LOAD DATETIME ,@BATCHST DATETIME ,@BATCHED DATETIME ;

  BEGIN TRY
  SET @BATCHST = GETDATE();

    PRINT'----BIGEN LOAD -------------------';
	PRINT'>>TRUNCATE TABLE:SILVER.GOLD--';
	TRUNCATE TABLE Silver.GOLD;
	PRINT'>>>INSERTING DATA IN :SILVER.GOLD--';
	SET @START_LOAD = GETDATE() ;
		insert into Silver.GOLD(
		[DATE]  ,
		[CLOSE] ,
		[HIGH],
		[LOW] ,
		[OPEN] ,
		[VOLUME],
		[ASSET_TYPE]
		)
		SELECT
		[Price] ,
		cast (isnull ([Close] , 0) as decimal(18,2)),
		cast (isnull ([High],0) as decimal(18,2)),
		cast (isnull ([Low],0) as decimal(18,2)),
		cast (isnull([Open],0) as decimal(18,2)) ,
		isnull([Volume],0) ,
		trim([Asset_Type])
		from Gold
		PRINT '-------LOAD TABLE IS DONE------'
		SET @END_LOAD = GETDATE();
		PRINT 'LOAD TABLE TIME : ' +CAST(DATEDIFF(SECOND,@START_LOAD,@END_LOAD)AS VARCHAR) + 'SECOND'
		------insert into table silver

	PRINT'>>TRUNCATE TABLE:SILVER.SILVER--';
	TRUNCATE TABLE Silver.SILVER;
	PRINT'>>>INSERTING DATA IN :SILVER.SILVER--';
	SET @START_LOAD = GETDATE() ;
		insert into Silver.SILVER(
		[DATE]  ,
		[CLOSE] ,
		[HIGH],
		[LOW] ,
		[OPEN] ,
		[VOLUME],
		[ASSET_TYPE]
		)
		SELECT
		  cast ([Price] as date),
		  cast ([Close] as decimal(18,2)),
		  cast ([High]as decimal(18,2)) ,
		  cast([Low] as decimal(18,2)) ,
		  cast ([Open] as decimal(18,2)),
		  cast([Volume] as decimal(18,2)),
		  trim([Asset_Type])
		from silver
	  PRINT '-------LOAD TABLE IS DONE------'
		SET @END_LOAD = GETDATE();
		PRINT 'LOAD TABLE TIME : ' +CAST(DATEDIFF(SECOND,@START_LOAD,@END_LOAD)AS VARCHAR) + 'SECOND'
		PRINT 'THE HOLE LOAD DONE';
		SET @BATCHED = GETDATE();
		PRINT'THE LOAD TIME FOR ALL: ' +CAST(DATEDIFF(SECOND,@BATCHST,@BATCHED) AS VARCHAR) + 'SECOND'
   END TRY
     BEGIN CATCH
	 END CATCH
END