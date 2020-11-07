SELECT NumberInEnglish=dbo.NumbersToWords (0)
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