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

"Add the hidden layer"
self addLayer: 
	(NeuronLayer new 
		initializeNbOfNeurons: nbOfNeurons 
		nbOfWeights: nbOfInputs 
		using: random 
		).

"Add the output layer"
self addLayer: 
	(NeuronLayer new 
		initializeNbOfNeurons: nbOfOutput 
		nbOfWeights: nbOfNeurons 
		using: random 
		).
]

{ #category : #examples }
NNetwork >> exampleTrainingXOR [
"Run the example to see the results

	NNetwork new exampleTrainingXOR  
	
	"

| n data |

n := NNetwork new.
n configure: 2 hidden: 3 nbOfOutputs: 2.

data := 
	{ #(0 0 0)
	. #(0 1 1)
	. #(1 0 1)
	. #(1 1 0) 
	}.
	
n train: data nbEpochs: 20000. 

^ n predict: #(1 0).
]

{ #category : #update }
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

{ #category : #'inspector integration' }
NNetwork >> inspectorViewLearningCurve [
<inspectorPresentationOrder: 90 title: 'Learning Curve'>

^ SpRoassal3InspectorPresenter new
	canvas: self viewLearningCurve;
	yourself.
]

{ #category : #'inspector integration' }
NNetwork >> inspectorViewLearningCurveContext: aContext [
aContext withoutEvaluator 
]

{ #category : #'inspector integration' }
NNetwork >> inspectorViewNetwork [
<inspectorPresentationOrder: 90 title: 'Network'>

^ SpRoassal3InspectorPresenter new
	canvas: self viewNetwork;
	yourself.
]

{ #category : #'inspector integration' }
NNetwork >> inspectorViewNetworkContext: aContext [
	 aContext withoutEvaluator 
]

{ #category : #update }
NNetwork >> learningRate: aFloat [
"Set the learning rate for all the layers"

layers do: [ :l | l learningRate: aFloat ]
]

{ #category : #visualization }
NNetwork >> numberOfInputs [
"Return the number of inputs the network has"

^ layers first neurons size
]

{ #category : #visualization }
NNetwork >> numberOfNeurons [
"Return the total number of neurons the network has"

^ (layers collect: #numberOfNeurons) sum
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
NNetwork >> predict: inputs [ 
"Make a prediction. This method asumes that the number of outputs
is the same as the number of different values the network can output"

| outputs |
outputs := self feed: inputs.
^ (outputs indexOf: (outputs max)) - 1


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
NNetwork >> train: trainData nbEpochs: nbEpochs [
	"Train the neural network with the provided trainData for nbEpochs"

	| sumError outputs expectedOutput epochPrecision t normalizedData |
	
	normalizedData := Normalization new normalizeData: trainData.

	1 to: nbEpochs do: [ :epoch |
		sumError := 0.
		epochPrecision := 0.

		normalizedData do: [ :row |
			outputs := self feed: row allButLast.
			expectedOutput := ( 1 to: self numberOfOutputs ) collect: [
				                  :notUsed | 0 ].
			expectedOutput at: row last + 1 put: 1.
			row last = ( self predict: row allButLast ) ifTrue: [
				epochPrecision := epochPrecision + 1 ].
			t := ( 1 to: expectedOutput size ) collect: [ :i |
				     ( ( expectedOutput at: i ) - ( outputs at: i ) ) squared ].
			sumError := sumError + t sum.
			self backwardPropagateError: expectedOutput.
			self updateWeight: row allButLast
			].
		errors add: sumError.
		precisions add: ( epochPrecision / trainData size ) asFloat
		]
]

{ #category : #update }
NNetwork >> updateWeight: initialInputs [
"Update the weights of the neurons using the initial inputs"

layers first updateWeight: initialInputs .
]

{ #category : #visualization }
NNetwork >> viewLearningCurve [
"Draw the error and precision curve"

| chartErrors chartPrecisions plotErrors plotPrecision canvas |

canvas := RSCanvas new.

"Define the size of the charting area"
canvas extent: 500 @ 300.

"Don't draw anything if the network has not been run"
errors ifEmpty: [ ^ canvas add: (RSLabel new text: 'Should first run the network'; fontSize: 15); yourself ].

"Add the errors chart"
plotErrors := RSLinePlot new y: errors; color: Color red.
chartErrors := RSCompositeChart new.
chartErrors removeHorizontalTicks.
chartErrors verticalTick styler tickColor: Color red; textColor: Color red.
chartErrors ylabel: 'Errors'.
chartErrors add: plotErrors.
chartErrors build.

"Add the precisions chart"
plotPrecision := RSLinePlot new y: precisions; color: Color blue.
chartPrecisions := RSCompositeChart new.
chartPrecisions add: plotPrecision.
chartPrecisions removeVerticalTicks.
chartPrecisions addDecoration: (RSVerticalRightTick new values: {precisions min . precisions max}).
(chartPrecisions ylabelRight: 'Precisions') styler textColor: Color blue.
chartPrecisions horizontalTick integer.
chartPrecisions build.

canvas add: (chartErrors canvas asShape).
canvas add: (chartPrecisions canvas asShape).
canvas @ RSCanvasController.

^ canvas
]

{ #category : #visualization }
NNetwork >> viewNetwork [

| b lb |
b := RSMondrian new.

b nodes: layers forEach: [ :aLayer |
	b shape circle size: 20; color: Color darkGray.
	b nodes: aLayer neurons.
	b layout vertical. 
	].

b arrowedLine.
b orthoHorizontalline connectTo: #nextLayer.
b layout horizontal gapSize: 30.

b build.

lb := RSLegend new.
lb container: b canvas.
lb text: (self numberOfNeurons asString) description: ' neurons'.
lb text: (self numberOfInputs asString) description: ' inputs'.

lb build.

^ b canvas.
]
