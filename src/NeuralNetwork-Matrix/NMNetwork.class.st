Class {
	#name : #NMNetwork,
	#superclass : #Object,
	#instVars : [
		'random',
		'errors',
		'layers'
	],
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #accessing }
NMNetwork >> addLayer: aLayer [
	"Add a layer to the network. Note that layers form a bidirectional chain"
	
	layers ifNotEmpty: [ 
		layers last next: aLayer.
		aLayer previous: layers last 
		].
	
	layers add: aLayer.
]

{ #category : #initialization }
NMNetwork >> backwardX: x y: y [
	"Compute and backpropagate the error"
		
	| lastLayer dz currentLayer |
	lastLayer := layers last.
	dz := lastLayer output - y.
	lastLayer delta: dz.
	currentLayer := lastLayer previous.
	
	[ currentLayer notNil ] whileTrue: [ 
		dz := (currentLayer next w transposed +* dz)
					multiplyPerElement: (currentLayer output collect: [ :v |
						v * (1 - v) ]).
		currentLayer delta: dz.
		currentLayer := currentLayer previous.
		].
]

{ #category : #initialization }
NMNetwork >> computeCost: v1 and: v2 [

	"Compute the cost function for two provided vectors"
	^ ((v1 - v2) collect: [ :v | v * v]) sum
]

{ #category : #initialization }
NMNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2 nbOfOutputs: nbOfOutputs [

	"Configure the network with the given parameters. The network has two hidden layers"
	
	self addLayer: (NMLayer new 
									nbInputs: nbOfInputs
									nbOutputs: nbOfNeurons1 
									random: random
								).
	self addLayer: (NMLayer new
									nbInputs: nbOfNeurons1
									nbOutputs: nbOfNeurons2
									random: random
								).
	self addLayer: (NMLayer new
									nbInputs: nbOfNeurons2
									nbOutputs: nbOfOutputs 
									random: random
								).
	
]

{ #category : #initialization }
NMNetwork >> configure: nbOfInputs hidden: nbOfNeurons nbOfOutputs: nbOfOutputs [
	"Configure the network with the given parameters.
	The network has only one hidden layer"
	
	self addLayer: (NMLayer new 
									nbInputs: nbOfInputs 
									nbOutputs: nbOfNeurons 
									random: random
								).
								
	self addLayer: (NMLayer new
									nbInputs: nbOfNeurons
									nbOutputs: nbOfOutputs 
									random: random
								).
	
]

{ #category : #initialization }
NMNetwork >> feed: inputs [
	"Feed the network with the provided inputs vector.
	Return the output value as a matrix"
	
	| mat |
	mat := inputs.
	layers do: [ :l | mat := l feed: mat ].
	^ mat
]

{ #category : #initialization }
NMNetwork >> initialize [ 
	"Initialize the network with no layer and a proper random generator"
	
	super initialize.
	
	layers := OrderedCollection new.
	random := Random seed: 42.
]

{ #category : #visualization }
NMNetwork >> inspectorViewLearningCurve [
	<inspectorPresentationOrder: 90 title: 'Learning Curve'>
	
	^ SpRoassal3InspectorPresenter new
			canvas: self viewLearningCurve;
			yourself.
	
]

{ #category : #visualization }
NMNetwork >> inspectorViewLearningCurveContext: aContext [
	aContext withoutEvaluator 
]

{ #category : #accessing }
NMNetwork >> lr: aLearningRateAsFloat [
	"Globally set the learning rate"
	
	layers do: [ :l | l lr: aLearningRateAsFloat ]
]

{ #category : #initialization }
NMNetwork >> predict: inputs [
	"Make a prediction. This method assumes that the number of outputs
	is the same as the number of different values the network can output"
	
	| outputs |
	outputs := self feed: inputs.
	^ (outputs asArray indexOf: (outputs max)) - 1
]

{ #category : #initialization }
NMNetwork >> train: data nbEpochs: nbEpochs [
	 "Data is provided as a collection of arrays.
	The example data needs to be labeled using a numerical value"
	
	| x y labels numberOfOutputs |
	x := (Matrix newFromArrays: (data collect: #allButLast)) transposed.
	layers do: [ :l | l numberOfExamples: data size ].
	labels := data collect: #last.
	numberOfOutputs := labels asSet size.
	labels := labels collect: [ :row |
		| expectedOutput |
		expectedOutput := Array new: numberOfOutputs withAll: 0.
		expectedOutput at: row + 1 put: 1.
		expectedOutput 
		].
	y := (Matrix newFromArrays: labels) transposed.
	^ self trainX: x y: y nbOfEpochs: nbEpochs
	
]

{ #category : #initialization }
NMNetwork >> trainX: x y: y nbOfEpochs: nbEpochs [
	"Train the network with a set of inputs against the expected values"
		
	| cost output |
	
	"We need to teel to each layer of inputs against the expected values"
	layers do: [ :l | l numberOfExamples: y nbColumns ].
	errors := OrderedCollection new.
	nbEpochs timesRepeat: [ 
		output := self feed: x.
		cost := self computeCost: output and: y.
		self backwardX: x y: y.
		self update: x.
		errors add: cost.
		].
	^ cost
]

{ #category : #initialization }
NMNetwork >> update: input [

	"update the weights and bias using the provided input vector"
	layers first update: input
]

{ #category : #visualization }
NMNetwork >> viewLearningCurve [
	| canvas plot |
	
	canvas := RSCanvas new.
	
	errors ifEmpty: [ ^ canvas add: (RSLabel new text: 'Should first run the network'; fontSize: 15); 
					yourself ].
		
	canvas extent: 500 @ 300.
	
	plot := RSLinePlot new y: errors.
	plot ylabel: 'Error'.
	plot xlabel: 'Epoch'.
	plot horizontalTick integer.
	plot build.
	
	canvas add: (plot canvas asShape).
	canvas @ RSCanvasController.
	^ canvas

]
