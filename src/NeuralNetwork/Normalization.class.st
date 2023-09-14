"
I normalize data before training a network.

Responsibility: Transform data to use the same input range between 0 and 1.
Collaborators: NNetwork
Public API and Key Messages:
	- normalizeData:
"
Class {
	#name : #Normalization,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #transformation }
Normalization >> normalizeData: aData [
	"Normalize the data provided as argument"

	| nbOfColumns min max |
	
	"We exclude the expected output"
	nbOfColumns := aData first size - 1.
	min := OrderedCollection new.
	max := OrderedCollection new.
	
	1 to: nbOfColumns do: [ :index |
		| column |
		column := aData collect: 
			[ :row | row at: index ].
		min add: column min.
		max add: column max.
		].
	^ self normalizeData: aData min: min max: max
	
]

{ #category : #transformation }
Normalization >> normalizeData: aData min: minValues max: maxValues [
	"Normalize the data provided as argument"

	| nbOfColumns result min max |
	
	"We exclude the expected output"
	nbOfColumns := aData first size - 1.
	result := OrderedCollection new.

	aData do: [ :row |
		| t v |
		t := OrderedCollection new.
		1 to: nbOfColumns do: [ :index |
			v := row at: index.
			min := minValues at: index.
			max := maxValues at: index.
			t add: ( v - min / ( max - min ) ) asFloat
			].
		t add: row last.
		result add: t asArray
		].
	^ result asArray
]
