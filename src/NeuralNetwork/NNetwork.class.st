"
Class: 
	I am an Neuron Network  

Responsibility: 
	I hold neural layers. I also have erros inst variable that will be 
	useful for tracing the evolution of error during the learning phase.

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
	#name : #NNetwork,
	#superclass : #Object,
	#instVars : [
		'layers',
		'errors',
		'precisions'
	],
	#category : #NeuralNetwork
}

{ #category : #update }
NNetwork >> addLayer: aNeuronLayer [
"Add a neural layer. The added layer is linked to the already added layers"

layers ifNotEmpty: [ 
	aNeuronLayer previousLayer: layers last. 
	layers last nextLayer: aNeuronLayer 
	].
	
layers add: aNeuronLayer.
]

{ #category : #backpropagation }
NNetwork >> backwardPropagateError: expectedOutputs [
"expectedOutputs corresponds to the outputs we are training the network against"

self outputLayer backwardPropagateError: expectedOutputs 
]

{ #category : #update }
NNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2  nbOfOutputs: nbOfOutput [
"Configure the network with the given parameters. The network has only one hidden layer"

| random |
random := Random seed: 42.

self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons1 nbOfWeights: nbOfInputs using: random ).
self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons2 nbOfWeights: nbOfNeurons1 using: random ).
self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput nbOfWeights: nbOfNeurons2 using: random ).
]

{ #category : #update }
NNetwork >> configure: nbOfInputs hidden: nbOfNeurons nbOfOutputs: nbOfOutput [
"Configure the network with the given parameters. The network has only one hidden layer"

| random |
random := Random seed: 42.

self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons nbOfWeights: nbOfInputs using: random ).
self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput nbOfWeights: nbOfNeurons using: random ).
]

{ #category : #initialization }
NNetwork >> feed: someInputValues [
"Feed the first layer with the provided inputs"
^ layers first feed: someInputValues 
]

{ #category : #initialization }
NNetwork >> initialize [ 

super initialize .
layers := OrderedCollection new.
errors := OrderedCollection new.
precisions := OrderedCollection new.
]

{ #category : #update }
NNetwork >> learningRate: aFloat [
"Set the learning rate for all the layers"

layers do: [ :l | l learningRate: aFloat ]
]

{ #category : #accessing }
NNetwork >> numberOfOutputs [
"Return the number of output of the network"

^ layers last numberOfNeurons
]

{ #category : #accessing }
NNetwork >> outputLayer [
"Return the output layer, which is also the last layer"

^ layers last
]

{ #category : #update }
NNetwork >> train: someInputs desiredOutputs: desiredOutputs [
"Train the neural network with a set of inputs and
some expected output"

self feed: someInputs.
self backwardPropagateError: desiredOutputs.
self updateWeight: someInputs. 
]

{ #category : #update }
NNetwork >> updateWeight: initialInputs [
"Update the weights of the neurons using the initial inputs"

layers first updateWeight: initialInputs .
]
