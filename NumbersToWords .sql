ALTER FUNCTION NumbersToWords (@NumericValue NUMERIC(38,2))
	RETURNS VARCHAR(1024)
as
BEGIN
/*
DIVIDE AND "HUMANIZE"
- Numbers must be divided by three
- I can convert and divide numbers into substrings
and then replace string equivalents
- 
*/

-- Give special numbers until 100
DECLARE @numericDetails TABLE (
		Number	INT,
		Word	VARCHAR(20)
		)
INSERT into @numericDetails values (1,'One'),(2,'Two'),( 3,'Three'),(4,'Four'),( 5,'Five'),
(6,'Six'),(7,'Seven'),(8,'Eight'),(9,'Nine'),(10,'Ten'),
(11,'Eleven'),(12,'Twelve'),(13,'Thirteen'),(14,'Fourteen'),
(15,'Fifteen'),(16,'Sixteen'),(17,'Seventeen'),(18,'Eighteen'),
(19,'Nineteen'),(20,'Twenty'),(30,'Thirty'),(40,'Forty'),
(50,'Fifty'),(60,'Sixty'),(70,'Seventy'),(80,'Eighty'),(90,'Ninety')

-- Give digit values
DECLARE @digitDetails TABLE (
		DigitPlace	int,
		PlaceName	varchar(30)
		)
INSERT INTO @digitDetails values (1,'Hundred'),(2,'Thousand'),(4,'Billion'),(6,'Quadrillion'),
(8,'Sextillion'),(10,'Octillion'),(12,'Decillion'),(14,'DuoDecillion'),
(16,'QuattuorDecillion'),(17,'QuinDecillion'),(19,'SepDecillion'),(21,'NovemDecillion'),
(3,'Million'),(5,'Trillion'),(7,'Quintillion'),(9,'Septillion'),
(11,'Nonillion'),(13,'UnDecillion'),(15,'TreDecillion'),(18,'SexDecillion'),
(20,'OctoDecillion'),(22,'Vigintillion')

-- Important variables
DECLARE	@strNum			VARCHAR(60)		= ABS(@NumericValue),  -- Get absulute value and convert to varchar. I can set sign later.
		@largeNum		VARCHAR(60),  -- Last 3 numbers
		@smallNum		VARCHAR(10),  -- remain numbers
		@decimalNum		VARCHAR(10)		= '',
		@sentence			VARCHAR(50)	= '',
		@lastDigitVal		int,
		@tenthVal		int,
		@unitVal		int,
		@hundVal		int				= 0,
		@strFinal		VARCHAR(1024)	= '',
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
	RETURN 'Zero'
END

SET @strLen = LEN(@strNum)

/*
If "@strLen > 3" => there is 3 checks to make
*/
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
			SELECT @sentence = WORD FROM @numericDetails
				WHERE NUMBER = @hundVal
			SET @sentence = @sentence + ' ' + 'Hundred'
			-- SET @strFinal = @sentence + @strFinal
			SET @lastDigitVal = @lastDigitVal%100  -- Get penultimate two digits
		END
		-- Check penultimate two digits
		IF (@lastDigitVal > 20)
		BEGIN
			SET @tenthVal	= (@lastDigitVal/10)*10  -- get rid of the first number of bigget 3 digists. I can make it "seventy" or something like later.
			SET @unitVal	= @lastDigitVal%10  -- get the first of bigget 3 digists.
			SELECT @sentence	= @sentence +' '+ WORD FROM @numericDetails
				WHERE NUMBER= @tenthVal
			SELECT @sentence	= @sentence +' '+ WORD FROM @numericDetails
				WHERE NUMBER= @unitVal
			SELECT @sentence	= @sentence+' '+PlaceName FROM @digitDetails
				WHERE DigitPlace = @digitLoop
			SET @strFinal	= @sentence + ', ' + @strFinal
			SET @strLen	= LEN(@largeNum)
			SET @largeNum= SUBSTRING(@largeNum, -2, @strLen)
			SET @digitLoop	= @digitLoop + 1
		END
		ELSE
		BEGIN
			SELECT @sentence=@sentence +' '+ WORD FROM @numericDetails
				WHERE NUMBER		= @lastDigitVal
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
*/
IF(@strLen = 3)
BEGIN
	SET @sentence = ''
	SET @smallNum		= RIGHT(@strNum, 3)
	SET @lastDigitVal	= CAST(LEFT(@smallNum, 1) AS INT)
	IF (@lastDigitVal > 0)
	BEGIN
		SELECT @sentence= Word+' '+'Hundred' FROM @numericDetails
			WHERE NUMBER= @lastDigitVal
		IF(@strFinal <> '')
			SET @strFinal= @strFinal +', ' + @sentence
		ELSE
			SET @strFinal= @sentence
	END
	SET @strLen = 2
END

/*
If there is some left less then 3, get them
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
SELECT NumberInEnglish=dbo.NumbersToWords ( 18)  -- eighteen
SELECT NumberInEnglish=dbo.NumbersToWords ( 67)
SELECT NumberInEnglish=dbo.NumbersToWords ( 947)
-- Nine Hundred Forty-Seven
SELECT NumberInEnglish=dbo.NumbersToWords ( 984261)
-- Nine Hundred Eighty-Four Thousand Two Hundred Sixty-One
SELECT NumberInEnglish=dbo.NumbersToWords ( 777999888)
/* Seven Hundred Seventy-Seven Million Nine Hundred Ninety-Nine Thousand
   Eight Hundred Eighty-Eight */
SELECT NumberInEnglish=dbo.NumbersToWords ( 222777999888)
SELECT NumberInEnglish=dbo.NumbersToWords ( 555222777999888)
SELECT NumberInEnglish=dbo.NumbersToWords ( 7446744073709551616)





--  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*- NumbersToWords2 -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 18)
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 67)
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 947)
-- Nine Hundred Forty-Seven
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 984261)
-- Nine Hundred Eighty-Four Thousand Two Hundred Sixty-One
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 777999888)
/* Seven Hundred Seventy-Seven Million Nine Hundred Ninety-Nine Thousand
   Eight Hundred Eighty-Eight */
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 222777999888)
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 555222777999888)
SELECT NumberInEnglish=dbo.NumbersToWords2 ( 7446744073709551616)





--  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*- NumbersToWords3 -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
SELECT NumberInEnglish=dbo.NumbersToWords3 (0)  -- 
SELECT NumberInEnglish=dbo.NumbersToWords3 (1)
SELECT NumberInEnglish=dbo.NumbersToWords3 (18)
SELECT NumberInEnglish=dbo.NumbersToWords3 (67)
SELECT NumberInEnglish=dbo.NumbersToWords3 (947)
-- Nine Hundred Forty-Seven
SELECT NumberInEnglish=dbo.NumbersToWords3 (940007)  -- I solved the "middle zeros" bug by reserting @sentence and @hundVal variables
-- Nine Hundred Forty Thousand, Seven
SELECT NumberInEnglish=dbo.NumbersToWords3 (984261)
-- Nine Hundred Eighty-Four Thousand Two Hundred Sixty-One
SELECT NumberInEnglish=dbo.NumbersToWords3 (777999888)
/* Seven Hundred Seventy-Seven Million Nine Hundred Ninety-Nine Thousand
   Eight Hundred Eighty-Eight */
SELECT NumberInEnglish=dbo.NumbersToWords3 (222777999888)
SELECT NumberInEnglish=dbo.NumbersToWords3 (555222777999888)
SELECT dbo.NumbersToWords3 (7446744073709551616)

-- only way to run extremly big numbers
DECLARE	@return_value VarChar(1024)

EXEC	@return_value = [dbo].[NumbersToWords3]
		@NumericValue = 7446744073709551616

SELECT	@return_value as 'Return Value'
--  Seven Quintillion, Four Hundred Forty Six Quadrillion, Seven Hundred Forty Four Trillion,  Seventy Three Billion, Seven Hundred Nine Million, Five Hundred Fifty One Thousand, Six Hundred, Sixteen

*/
