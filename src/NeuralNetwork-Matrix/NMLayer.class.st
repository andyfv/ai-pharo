Class {
	#name : #NMLayer,
	#superclass : #Object,
	#instVars : [
		'w',
		'b',
		'delta',
		'output',
		'previous',
		'next',
		'lr',
		'numberOfExamples'
	],
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #initialization }
NMLayer >> b [
	"Return the bias vector"
	
	^ b 
]

{ #category : #initialization }
NMLayer >> b: biasVector [
	"Set a vector, instance of Matrix, as the bias vector"
	
	b := biasVector 
]

{ #category : #initialization }
NMLayer >> delta [
	
	^ delta 
]

{ #category : #initialization }
NMLayer >> delta: deltaMatrix [
	delta := deltaMatrix 
]

{ #category : #initialization }
NMLayer >> feed: inputMatrix [
	"Feed the layer with the input matrix"
	
	output := (w +* inputMatrix + b) collect: [ :v |
		1 / (1 + v negated exp)
		].
	
	^ output
]

{ #category : #initialization }
NMLayer >> initialize [ 
	super initialize.
	
	lr := 0.1
]

{ #category : #initialization }
NMLayer >> lr: aLearningRate [
	lr := aLearningRate 
]

{ #category : #initialization }
NMLayer >> nbInputs: nbOfInputs nbOutputs: nbOfOutputs random: random [
	"Initialize the layer"
	
	w := Matrix newRows: nbOfOutputs columns: nbOfInputs.
	w random: random.
	b := Matrix newRows: nbOfOutputs columns: 1.
	b random: random.
]

{ #category : #initialization }
NMLayer >> next [
	"Return the next layer"
	
	^ next
]

{ #category : #initialization }
NMLayer >> next: aLayer [
	"Set the next layer"
	
	next := aLayer
]

{ #category : #initialization }
NMLayer >> numberOfExamples [
	^ numberOfExamples
]

{ #category : #initialization }
NMLayer >> numberOfExamples: aNumber [
	numberOfExamples := aNumber
]

{ #category : #initialization }
NMLayer >> output [ 
	"Return the output matrix, computed during the feed forward phase"
	
	^ output
]

{ #category : #initialization }
NMLayer >> previous [
	"Return the previous layer"
	
	^ previous
]

{ #category : #initialization }
NMLayer >> previous: aLayer [
	"Set the previous layer"
	
	previous := aLayer
]

{ #category : #initialization }
NMLayer >> update [
	"Update the weights and biases using the delta value"
	
	w := w - ( (delta +* previous output transposed) * lr / numberOfExamples ).
	b := b - (delta sumHorizontal * lr / numberOfExamples ).
	
	next ifNotNil: [ next update ]
]

{ #category : #initialization }
NMLayer >> update: input [
	"Update the weights and biases using the input value"
	
	w := w - ( (delta +* input transposed) * lr / numberOfExamples ).
	b := b - (delta sumHorizontal * lr / numberOfExamples ).
	
	next update
]

{ #category : #initialization }
NMLayer >> w [
	"Return the Matrix representing the weights"
	
	^ w  
]

{ #category : #initialization }
NMLayer >> w: matrixForWeights [
	"Take a Matrix as argument"
	
	w := matrixForWeights 
]
