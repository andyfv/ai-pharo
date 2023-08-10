"
Class: 
	I am an Neuron Layer  

Responsibility: 
	I hold neurons. I also links that connect me to the previous and next layer in the neural network

Collaborators: 

Public API and Key Messages:

Internal Representation and Key Implementation Points:

    Instance Variables
	neurons:		<Object>
	nextLayer:		<Object>
	previousLayer:		<Object>


    Implementation Points
"
Class {
	#name : #NeuronLayer,
	#superclass : #Object,
	#instVars : [
		'previousLayer',
		'nextLayer',
		'neurons'
	],
	#category : #NeuralNetwork
}

{ #category : #backpropagation }
NeuronLayer >> backwardPropagateError [
"This is a recursive method.The backpropagation begins 
with the output layer (i.e., the last layer)"

"We are in a hidden layer"
neurons doWithIndex: [ :neuron :j |
	| theError |
	theError := 0.0.
	self nextLayer neurons do: [ :nextNeuron |
		theError := theError + ( (nextNeuron weights at: j) * nextNeuron delta) 
		].
	neuron adjustDeltaWith: theError 
	].

self previousLayer notNil 
	ifTrue: [ self previousLayer backwardPropagateError ].
]

{ #category : #backpropagation }
NeuronLayer >> backwardPropagateError: expected [
"This is a recursive method. The backpropagation begins 
with the output layer (i.e the last layer) and moves backward"

neurons with: expected do: [ :neuron :exp |
	| theError |
	theError := exp - neuron output.
	neuron adjustDeltaWith: theError. 
	].

"We iterate"
self previousLayer notNil
	ifTrue: [ self previousLayer backwardPropagateError ]
]

{ #category : #initialization }
NeuronLayer >> feed: someInputValues [
"Feed the neuron layer with some inputs"

| someOutputs |
someOutputs := neurons collect: [ :n | n feed: someInputValues ] as: Array.
^ self isOutputLayer
			ifTrue: [ someOutputs ]
			
			"If the layer is a hidden layer we feed-forward 
			the the compound values to the next layer"
			ifFalse: [ nextLayer feed: someOutputs ].
]

{ #category : #initialization }
NeuronLayer >> initializeNbOfNeurons: nbOfNeurons nbOfWeights: nbOfWeights using: random [ 
"Main method to initialize a neuron layer
	- nbOfNeurons : number of neurons the layer should be made of
	- nbOfWeights : number of weights each neuron should have. Reflects on the number of input values the layer is accepting
	- random : a random number generator"
	
| weights |
neurons := (1 to: nbOfNeurons ) collect: [ :i | 
	weights := (1 to: nbOfWeights ) collect: [ :ii | random next * 4 - 2 ].
	Neuron new sigmoid; weights: weights; bias: (random next * 4 - 2).
	].
self learningRate: 0.1

]

{ #category : #testing }
NeuronLayer >> isOutputLayer [
"Return true if the layer is the output layer (i.e the last layer in the network)"

^ self nextLayer isNil
]

{ #category : #update }
NeuronLayer >> learningRate: aFloat [
"Set the learnining rate for all the neurons in the layer.
The method should be called after configuring the network, 
and not before"

self assert: [ neurons notEmpty ] description: 'learningRate: should be invoked after configuring the layer'.
neurons do: [ :n | n learningRate: aFloat ].
]

{ #category : #accessing }
NeuronLayer >> neurons [ 
"Return the neurons I am composed of"

^ neurons 
]

{ #category : #accessing }
NeuronLayer >> nextLayer [
"Return the next layer connected to me"

^ nextLayer
]

{ #category : #accessing }
NeuronLayer >> nextLayer: aLayer [
"Set the next layer"

nextLayer := aLayer
]

{ #category : #accessing }
NeuronLayer >> numberOfNeurons [
"Return the number of neurons in the layer"

^ neurons size 
]

{ #category : #accessing }
NeuronLayer >> previousLayer [
"Return the previous layer connected to me"

^ previousLayer
]

{ #category : #accessing }
NeuronLayer >> previousLayer: aLayer [
"Return the previous layer connected to me"

previousLayer := aLayer
]

{ #category : #update }
NeuronLayer >> updateWeight [
"Update the weights of the neuron based on the set of initial input.
This method assumes that the receiver of the message invoking that 
method is the first hidden layer."

| inputs |
inputs := self previousLayer neurons collect: #output .

self updateWeight: inputs.

]

{ #category : #update }
NeuronLayer >> updateWeight: initialInputs [
"Update the weights of the neuron based on the set of initial input.
This method assumes that the receiver of the message invoking that 
method is the first hidden layer."

| inputs |
inputs := initialInputs .
neurons do: [ :n | 
	n adjustWeightWithInput: inputs.
	n adjustBias. 
	].

self nextLayer ifNotNil: [ self nextLayer updateWeight ]
]
