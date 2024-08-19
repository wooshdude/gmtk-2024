extends Resource
class_name Person

enum Purity {
	MAJOR_PURE,
	MEDIUM_PURE,
	MINOR_PURE,
	NEUTRAL,
	MINOR_SINNER,
	MEDIUM_SINNER,
	MAJOR_SINNER,
}

enum Trade {
	NONE,
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
	NONE,
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

@export var answer:GodManager.Gods
@export var purity: Purity
@export var constellation:Constellation
@export var trade:Trade
@export_multiline var dialogue:String
@export var memos:Array[Request]
@export_multiline var regulation:String

var weight: float :
	get():
		match purity:
			Purity.MAJOR_PURE:
				return -1
			Purity.MEDIUM_PURE:
				return -0.5
			Purity.MINOR_PURE:
				return -0.2
			Purity.NEUTRAL:
				return 0
			Purity.MINOR_SINNER:
				return 0.2
			Purity.MEDIUM_SINNER:
				return 0.5
			Purity.MAJOR_SINNER:
				return 1
		return 0
