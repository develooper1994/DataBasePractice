USE [School]
GO

DECLARE @lang VARCHAR(4) = 'tr';
SELECT dbo.NumbersToWords_v2 (1472172, @lang)  --  Bir Million, Dört Yüz Yetmiþ Ýki Bin,  Yüz, Yetmiþ Ýki
SELECT dbo.NumbersToWords_v2 (14721472, @lang)  -- On Dört Million, Yedi Yüz Yirmi Bir Bin, Dört Yüz, Yetmiþ Ýki

SELECT dbo.NumbersToWords_v2 (0, @lang)
SELECT dbo.NumbersToWords_v2 (1, @lang)
SELECT dbo.NumbersToWords_v2 (18, @lang)
SELECT dbo.NumbersToWords_v2 (67, @lang)
SELECT dbo.NumbersToWords_v2 (947, @lang)
SELECT dbo.NumbersToWords_v2 (9472, @lang)
SELECT dbo.NumbersToWords_v2 (11, @lang)
SELECT dbo.NumbersToWords_v2 (111, @lang)
SELECT dbo.NumbersToWords_v2 (1111, @lang)  -- TODO: !!!BUG(Remove 'Bir' word)!!!  Bir Bin,  Yüz, On Bir
SELECT dbo.NumbersToWords_v2 (11111, @lang)
SELECT dbo.NumbersToWords_v2 (111111, @lang)
-- Nine Hundred Forty-Seven
SELECT dbo.NumbersToWords_v2 (940007, @lang)  -- I solved the "middle zeros" bug by reserting @sentence and @hundVal variables
-- Nine Hundred Forty Thousand, Seven
SELECT dbo.NumbersToWords_v2 (984261, @lang)
-- Nine Hundred Eighty-Four Thousand Two Hundred Sixty-One
SELECT dbo.NumbersToWords_v2 (777999888, @lang)
/* Seven Hundred Seventy-Seven Million Nine Hundred Ninety-Nine Thousand
   Eight Hundred Eighty-Eight */
--SELECT dbo.NumbersToWords_v2 (222777999888, @lang)
--SELECT dbo.NumbersToWords_v2 (555222777999888, @lang)
--SELECT dbo.NumbersToWords_v2 (7446744073709551616, @lang)

-- only way to run extremly big numbers
DECLARE	@return_value VarChar(1024)

EXEC	@return_value = [dbo].[NumbersToWords_v2]
		@NumericValue = 222777999888,
		@lang = @lang

SELECT	@return_value as 'Return Value'

EXEC	@return_value = [dbo].[NumbersToWords_v2]
		@NumericValue = 555222777999888,
		@lang = @lang

SELECT	@return_value as 'Return Value'

EXEC	@return_value = [dbo].[NumbersToWords_v2]
		@NumericValue = 7446744073709551616,
		@lang = @lang

SELECT	@return_value as 'Return Value'
--  Seven Quintillion, Four Hundred Forty Six Quadrillion, Seven Hundred Forty Four Trillion,  Seventy Three Billion, Seven Hundred Nine Million, Five Hundred Fifty One Thousand, Six Hundred, Sixteen