extends Resource
class_name Person

enum Trade {
	CARPENTER,
	PHAROH,
	CHEF,
	FARMER,
	BREWER
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


@export var weight:int
@export var constellation:Constellation
@export var trade:Trade
@export var wealth:int
@export_range(0,3) var belongings:int
