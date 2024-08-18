extends Resource
class_name Person

enum Trade {
	CARPENTER,
	PRIEST,
	PHAROH,
	BAKER,
	FARMER,
	MERCHANT,
	FISHER,
	LABOURER,
	SCRIBE
}

enum Constellation {
	ARIES,
	TAURUS,
	GEMINI,
	CANCER,
	LEO,
	VIRGO,
	LIBRA,
	SCORPIO,
	SAGITTARIUS,
	CAPRICORN,
	AQUARIUS,
	PISCES
}

var Texture_Ref:Array = [
	[1, 2, 3],
	[4, 5, 6],
	[7, 8, 9],
	[10, 11, 12],
	[13, 14, 15],
	[16, 17, 18],
	[19, 20, 21],
	[22, 23, 24],
	[25, 26, 27]
]

@export var weight:int
@export var constellation:Constellation
@export var trade:Trade
@export var wealth:int
@export_range(0,3) var belongings:int
