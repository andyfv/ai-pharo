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

{ #category : #accessing }
NMLayer >> b [
	"Return the bias vector"
	
	^ b 
]

{ #category : #accessing }
NMLayer >> b: biasVector [
	"Set a vector, instance of Matrix, as the bias vector"
	
	b := biasVector 
]

{ #category : #accessing }
NMLayer >> delta [
	
	^ delta 
]

{ #category : #accessing }
NMLayer >> delta: deltaMatrix [
	delta := deltaMatrix 
]

{ #category : #accessing }
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

{ #category : #accessing }
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

{ #category : #accessing }
NMLayer >> next [
	"Return the next layer"
	
	^ next
]

{ #category : #accessing }
NMLayer >> next: aLayer [
	"Set the next layer"
	
	next := aLayer
]

{ #category : #accessing }
NMLayer >> numberOfExamples [
	^ numberOfExamples
]

{ #category : #accessing }
NMLayer >> numberOfExamples: aNumber [
	numberOfExamples := aNumber
]

{ #category : #accessing }
NMLayer >> output [ 
	"Return the output matrix, computed during the feed forward phase"
	
	^ output
]

{ #category : #accessing }
NMLayer >> previous [
	"Return the previous layer"
	
	^ previous
]

{ #category : #accessing }
NMLayer >> previous: aLayer [
	"Set the previous layer"
	
	previous := aLayer
]

{ #category : #accessing }
NMLayer >> update [
	"Update the weights and biases using the delta value"
	
	w := w - ( (delta +* previous output transposed) * lr / numberOfExamples ).
	b := b - (delta sumHorizontal * lr / numberOfExamples ).
	
	next ifNotNil: [ next update ]
]

{ #category : #accessing }
NMLayer >> update: input [
	"Update the weights and biases using the input value"
	
	w := w - ( (delta +* input transposed) * lr / numberOfExamples ).
	b := b - (delta sumHorizontal * lr / numberOfExamples ).
	
	next update
]

{ #category : #accessing }
NMLayer >> w [
	"Return the Matrix representing the weights"
	
	^ w  
]

{ #category : #accessing }
NMLayer >> w: matrixForWeights [
	"Take a Matrix as argument"
	
	w := matrixForWeights 
]
