USE [School]
GO
/****** Object:  UserDefinedFunction [dbo].[NumbersToWords3]    Script Date: 11/6/2020 6:25:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[NumbersToWords_v2] (@NumericValue NUMERIC(38,2), @lang NVARCHAR(4) = 'en')
	RETURNS NVARCHAR(1024)
as
BEGIN
/*
DIVIDE AND "HUMANIZE"
- Numbers must be divided by three
- I can convert and divide numbers into substrings
and then replace string equivalents
*/
SET @lang = TRIM(@lang)
SET @lang = lower(@lang)

DECLARE @zero NVARCHAR(10) = 'Zero';
-- Give special numbers until 100
DECLARE @numericDetails TABLE (
		Number	INT,
		Word	NVARCHAR(20)
		)
-- Give digit values
DECLARE @digitDetails TABLE (
		DigitPlace	int,
		PlaceName	NVARCHAR(30)
		)
IF(@lang = 'en') begin
	SET @zero = 'Zero';
	-- Give special numbers until 100
	INSERT into @numericDetails values (1,'One'),(2,'Two'),( 3,'Three'),(4,'Four'),( 5,'Five'),
	(6,'Six'),(7,'Seven'),(8,'Eight'),(9,'Nine'),(10,'Ten'),
	(11,'Eleven'),(12,'Twelve'),(13,'Thirteen'),(14,'Fourteen'),
	(15,'Fifteen'),(16,'Sixteen'),(17,'Seventeen'),(18,'Eighteen'),
	(19,'Nineteen'),(20,'Twenty'),(30,'Thirty'),(40,'Forty'),
	(50,'Fifty'),(60,'Sixty'),(70,'Seventy'),(80,'Eighty'),(90,'Ninety')

	-- Give digit values
	INSERT INTO @digitDetails values 
	-- Odd Digits
	(1,'Hundred'),(2,'Thousand'),(4,'Billion'),(6,'Quadrillion'),
	(8,'Sextillion'),(10,'Octillion'),(12,'Decillion'),(14,'DuoDecillion'),
	(16,'QuattuorDecillion'),
	-- Even Digits
	(17,'QuinDecillion'),(19,'SepDecillion'),(21,'NovemDecillion'),
	(3,'Million'),(5,'Trillion'),(7,'Quintillion'),(9,'Septillion'),
	(11,'Nonillion'),(13,'UnDecillion'),(15,'TreDecillion'),(18,'SexDecillion'),
	(20,'OctoDecillion'),(22,'Vigintillion')
end
ELSE IF(@lang = 'tr') begin
	SET @zero = 'Sýfýr';
	-- Give special numbers until 100
	INSERT into @numericDetails values (1,'Bir'),(2,'Ýki'),( 3,'Üç'),(4,'Dört'),( 5,'Beþ'),
	(6,'Altý'),(7,'Yedi'),(8,'Sekiz'),(9,'Dokuz'),(10,'On'),
	(11,'On Bir'),(12,'On Ýki'),(13,'On Üç'),(14,'On Dört'),
	(15,'On Beþ'),(16,'On Altý'),(17,'On Yedi'),(18,'On Sekiz'),
	(19,'On Dokuz'),(20,'Yirmi'),(30,'Otuz'),(40,'Kýrk'),
	(50,'Elli'),(60,'Altmýþ'),(70,'Yetmiþ'),(80,'Seksen'),(90,'Doksan')

	-- Give digit values
	INSERT INTO @digitDetails values 
	-- Odd Digits
	(1,'Yüz'),(2,'Bin'),(4,'Milyar'),(6,'Katrilyon'),
	(8,'Sextillion'),(10,'Octillion'),(12,'Desilyon'),(14,'DuoDecillion'),
	(16,'QuattuorDecillion'),
	-- Even Digits
	(17,'QuinDecillion'),(19,'SepDecillion'),(21,'NovemDecillion'),
	(3,'Million'),(5,'Trillion'),(7,'Quintillion'),(9,'Septillion'),
	(11,'Nonillion'),(13,'UnDecillion'),(15,'TreDecillion'),(18,'SexDecillion'),
	(20,'OctoDecillion'),(22,'Vigintillion')
end

-- Important variables
DECLARE	@strNum			NVARCHAR(60)		= ABS(@NumericValue),  -- Get absulute value and convert to varchar. I can set sign later.
		@largeNum		NVARCHAR(60),  -- Last 3 numbers
		@smallNum		NVARCHAR(10),  -- remain numbers
		@decimalNum		NVARCHAR(10)		= '',
		@sentence		NVARCHAR(50)		= '',
		@lastDigitVal	int,
		@tenthVal		int,
		@unitVal		int,
		@hundVal		int				= 0,
		@strFinal		NVARCHAR(1024)	= '',
		@strLen			int,
		@digitLoop		int				= 2

/*
There is left and right parts of the input number.
Get the precition "character('.')"
*/
-- expression, startingIndex, lenght
SET @strNum = SUBSTRING(@strNum, 1, CASE
WHEN 
	CHARINDEX('.', @strNum)=0 THEN LEN(@strNum)
ELSE
	CHARINDEX('.', @strNum)-1 
END)

IF(@strNum=0)
BEGIN
	RETURN @zero
END

SET @strLen = LEN(@strNum)

/*
If "@strLen > 3" => there is 3 checks to make
>=10000
*/
DECLARE @HUNDREDstr NVARCHAR(10);
IF(@strLen > 3)
BEGIN
	-- Get last 3 numbers
	SET @largeNum = SUBSTRING(@strNum,-2,@strLen)
	SET @strLen  = LEN(@strNum)
	WHILE LEN(@largeNum) > 0
	BEGIN
		SET @sentence	= ''
		SET @hundVal	= 0
		SET @lastDigitVal	= CAST(RIGHT(@largeNum, 3) AS INT)
		-- Check last 3 digits
		IF (@lastDigitVal >= 100)
		BEGIN
			SET @hundVal = @lastDigitVal/100  -- Get last digit
			-- SET @hundVal = CAST(LEFT(@largeNum,1) AS INT)
			SELECT @sentence = WORD FROM @numericDetails WHERE NUMBER = @hundVal
			SELECT @HUNDREDstr=PlaceName from @digitDetails where DigitPlace=1
			if(@lang='tr' and @hundVal=1) begin
				SET @sentence = ' ' + @HUNDREDstr
			end
			else begin
				SET @sentence = @sentence + ' ' + @HUNDREDstr
			end

			-- SET @strFinal = @sentence + @strFinal
			SET @lastDigitVal = @lastDigitVal%100  -- Get penultimate two digits
		END
		-- Check penultimate two digits
		IF (@lastDigitVal > 20)
		BEGIN
			SET @tenthVal	= (@lastDigitVal/10)*10  -- get rid of the first number of bigget 3 digists. I can make it "seventy" or something like later.
			SET @unitVal	= @lastDigitVal%10  -- get the first of bigget 3 digists.
			-- ten thosands
			if(@lang='tr' and @tenthVal=1) begin
				SELECT @sentence	= ' '+ WORD FROM @numericDetails
				WHERE NUMBER= @tenthVal
			end
			else begin
				SELECT @sentence	= @sentence +' '+ WORD FROM @numericDetails
				WHERE NUMBER= @tenthVal
			end
			-- thosands
			--if(@lang='tr' and @unitVal=1) begin
			--	SELECT @sentence	= ' '+ WORD FROM @numericDetails
			--	WHERE NUMBER= @unitVal
			--end
			--else begin
			--	SELECT @sentence	= @sentence +' '+ WORD FROM @numericDetails
			--	WHERE NUMBER= @unitVal
			--end

			-- TODO: !!!BUG(Remove 'Bir' word)!!!  Bir Bin,  Yüz, On Bir
			SELECT @sentence	= @sentence +' '+ WORD FROM @numericDetails
				WHERE NUMBER= @unitVal
			-- TODO: !!!BUG(Remove 'Bir' word)!!!  Bir Bin,  Yüz, On Bir



			SELECT @sentence	= @sentence+' '+PlaceName FROM @digitDetails
				WHERE DigitPlace = @digitLoop
			SET @strFinal	= @sentence + ', ' + @strFinal
			SET @strLen	= LEN(@largeNum)
			SET @largeNum= SUBSTRING(@largeNum, -2, @strLen)
			SET @digitLoop	= @digitLoop + 1
		END
		ELSE BEGIN
			if(@lang='tr' and @lastDigitVal=1) begin
				SELECT @sentence = ' '+ WORD FROM @numericDetails
				WHERE NUMBER	= @lastDigitVal
			end
			else begin
				SELECT @sentence = @sentence +' '+ WORD FROM @numericDetails
				WHERE NUMBER	= @lastDigitVal
			end

			SELECT @sentence=@sentence+' '+PlaceName FROM @digitDetails
				WHERE DigitPlace	= @digitLoop
			IF(@lastDigitVal > 0 OR @hundVal > 0)
			SET @strFinal			= @sentence + ', ' + @strFinal
			SET @strLen				= LEN(@largeNum)
			SET @largeNum			= SUBSTRING(@largeNum,-2,@strLen)
			SET @digitLoop			= @digitLoop + 1
		END
	END
	SET @strLen		= 3
	SET @strFinal	= RTRIM(@strFinal)  -- right trim
	SET @strFinal	= STUFF(@strFinal,LEN(@strFinal),1,'')
END

/*
Check if the input number or rest of the "input number lenght = 3"
9999>=number>=1000
*/
IF(@strLen = 3)
BEGIN
	SET @sentence = ''
	SET @smallNum		= RIGHT(@strNum, 3)
	SET @lastDigitVal	= CAST(LEFT(@smallNum, 1) AS INT)
	IF (@lastDigitVal > 0)
	BEGIN
		if(@lang='tr' and @lastDigitVal=1) begin
			SELECT @HUNDREDstr=PlaceName from @digitDetails where DigitPlace=1
			SELECT @sentence= ' '+@HUNDREDstr FROM @numericDetails 
			WHERE NUMBER= @lastDigitVal
		end
		else begin
			SELECT @HUNDREDstr=PlaceName from @digitDetails where DigitPlace=1
			SELECT @sentence= Word+' '+@HUNDREDstr FROM @numericDetails 
			WHERE NUMBER= @lastDigitVal
		end

		IF(@strFinal <> '')
			SET @strFinal= @strFinal +', ' + @sentence
		ELSE
			SET @strFinal= @sentence
	END
	SET @strLen = 2
END

/*
If there is some left less then 3, get them
99>=number>=10
*/
IF(@strLen < 3 AND @strLen > 0)
BEGIN
	SET @sentence = ''
	SET @smallNum		= RIGHT(@strNum,2)
	SET @lastDigitVal	= CAST(LEFT(@smallNum,2) AS INT)
	IF (@lastDigitVal > 20)
	BEGIN
		SET @tenthVal	 = (@lastDigitVal/10)*10  -- get rid of the first number of bigget 3 digists. I can make it 
		SET @unitVal	 = @lastDigitVal%10  -- get the first of bigget 3 digists.
		SELECT @sentence = WORD FROM @numericDetails
			WHERE NUMBER = @tenthVal
		SELECT @sentence = @sentence+' '+WORD FROM @numericDetails
			WHERE NUMBER = @unitVal
		IF(@strFinal <> '')
			SET @strFinal = @strFinal +', ' + @sentence
		ELSE
			SET @strFinal = @sentence
	END
	ELSE IF(@lastDigitVal <= 20 AND @lastDigitVal > 0)
	BEGIN
		SELECT @sentence = WORD FROM @numericDetails
			WHERE NUMBER = @lastDigitVal
		IF(@strFinal <> '')
			SET @strFinal = @strFinal +', ' + @sentence
		ELSE
			SET @strFinal = @sentence
	END
END
	SELECT @strFinal = ISNULL(@strFinal,'')
	RETURN @strFinal
END

/*
--  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*- NumbersToWords -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
SELECT NumberInEnglish=dbo.NumbersToWords (0)  --
SELECT NumberInEnglish=dbo.NumbersToWords (1)
SELECT NumberInEnglish=dbo.NumbersToWords (18)
SELECT NumberInEnglish=dbo.NumbersToWords (67)
SELECT NumberInEnglish=dbo.NumbersToWords (947)
-- Nine Hundred Forty-Seven
SELECT NumberInEnglish=dbo.NumbersToWords (940007)  -- I solved the "middle zeros" bug by reserting @sentence and @hundVal variables
-- Nine Hundred Forty Thousand, Seven
SELECT NumberInEnglish=dbo.NumbersToWords (984261)
-- Nine Hundred Eighty-Four Thousand Two Hundred Sixty-One
SELECT NumberInEnglish=dbo.NumbersToWords (777999888)
/* Seven Hundred Seventy-Seven Million Nine Hundred Ninety-Nine Thousand
   Eight Hundred Eighty-Eight */
SELECT NumberInEnglish=dbo.NumbersToWords (222777999888)
SELECT NumberInEnglish=dbo.NumbersToWords (555222777999888)
SELECT dbo.NumbersToWords (7446744073709551616)

-- only way to run extremly big numbers
DECLARE	@return_value VarChar(1024)

EXEC	@return_value = [dbo].[NumbersToWords]
		@NumericValue = 7446744073709551616

SELECT	@return_value as 'Return Value'
--  Seven Quintillion, Four Hundred Forty Six Quadrillion, Seven Hundred Forty Four Trillion,  Seventy Three Billion, Seven Hundred Nine Million, Five Hundred Fifty One Thousand, Six Hundred, Sixteen

*/
