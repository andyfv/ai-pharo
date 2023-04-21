"
Representation of an artificial neuron to model the behaviour of a biological neuron.

"
Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'bias',
		'weights'
	],
	#category : #NeuralNetwork
}

{ #category : #accessing }
Neuron >> bias [
"Return the bias of the neuron."

^ bias
]

{ #category : #accessing }
Neuron >> bias: aNumber [
"Set the bias of the neuron."

bias := aNumber  
]

{ #category : #computation }
Neuron >> feed: inputs [
| z |
z := (inputs with: weights collect: [:x :w | x * w]) sum + bias.
^ z > 0 ifTrue: [ 1 ] ifFalse: [ 0 ].
]

{ #category : #accessing }
Neuron >> weights [
"Return the weights of the neuron."

^ weights
]

{ #category : #accessing }
Neuron >> weights: someWeightsAsNumbers [
"Set the weights of the neuron.
Takes a collection of numbers as argument"

weights := someWeightsAsNumbers 
]
