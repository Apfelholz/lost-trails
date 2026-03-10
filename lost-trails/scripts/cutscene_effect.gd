class_name CutsceneEffect
extends Resource

## Alle verfügbaren Effekttypen
enum Type {
	WAIT,        ## Wartezeit ohne visuellen Effekt (z.B. Bild anzeigen)
	FADE_IN,     ## Blendet ein: Schwarz → Transparent
	FADE_OUT,    ## Blendet aus:  Transparent → Schwarz
	IRIS_OPEN,   ## Iris öffnet sich von der Mitte nach außen
	IRIS_CLOSE,  ## Iris schließt sich von den Rändern zur Mitte
	BLINK,       ## Bildschirm blinkt mehrmals, endet in Schwarz
}

## Art des Effekts
@export var type: Type = Type.WAIT

## Dauer dieses Effekts in Sekunden
@export var duration: float = 1.0

## Anzahl der Blinker (nur relevant bei BLINK)
@export var blink_count: int = 3
