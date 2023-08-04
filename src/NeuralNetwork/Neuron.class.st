"
Representation of an artificial neuron to model the behaviour of a biological neuron.

"
Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'bias',
		'weights',
		'learningRate',
		'activationFunction',
		'delta',
		'output'
	],
	#category : #NeuralNetwork
}

{ #category : #update }
Neuron >> adjustBias [
	bias := bias + (learningRate * delta)
]

{ #category : #update }
Neuron >> adjustDeltaWith: anError [
delta := anError * (activationFunction derivative: output).
]

{ #category : #update }
Neuron >> adjustWeightWithInput: inputs [ 
	inputs withIndexDo: [ :anInput :index |
		weights at: index put: ((weights at: index) + (learningRate * delta * anInput)) ].
]

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

{ #category : #accessing }
Neuron >> delta [
"Return the delta value computed wen propagating the error"
	^ delta
]

{ #category : #example }
Neuron >> example [ 
"Run the example to see the results:

	Neuron new example
	
	"

| somePoints x y f chart plot dots |
somePoints := OrderedCollection new.
x := OrderedCollection new.
y := OrderedCollection new.
50 timesRepeat: [ 
	| xValue yValue |
	xValue := (50 atRandom - 25).
	yValue := (50 atRandom - 25).
	somePoints add: { xValue . yValue }.
	x add: xValue.
	y add: yValue.
	].

f := [ :i | (-2 * i) - 3 ].

"Plot points "

chart := RSCompositeChart new.
plot := RSScatterPlot new x: x y: y.

dots := RSCircle models: somePoints.
chart add: plot.
dots @ RSPopup.

RSNormalizer color
	shapes: dots;
	normalize: [ :s | (s second) > (f value: s first) 
						ifTrue: [ Color red translucent ]
						ifFalse: [ Color blue translucent ] ].
					
^ chart canvas


]

{ #category : #computation }
Neuron >> feed: inputs [
| z |
z := (inputs with: weights collect: [:x :w | x * w]) sum + bias.
output := activationFunction eval: z.
^ output
]

{ #category : #initialization }
Neuron >> initialize [ 
	super initialize.
	
	learningRate := 0.1.
	self sigmoid.
]

{ #category : #accessing }
Neuron >> learningRate [
	"Return the learning rate of the neuron"
	
	^ learningRate
]

{ #category : #accessing }
Neuron >> learningRate: aFloat [
	"Set the learning rate of the neuron. The argument should be a small floating value.
	For example 0.01"
	
	learningRate := aFloat
]

{ #category : #example }
Neuron >> measurePrecision [
"Run the example to see the results:

	Neuron new measurePrecision
	
	"


| learningCurve f r p trainedOutput nbOfGood nbOfTries realOutput chart plot xVals yVals |
learningCurve := OrderedCollection new.
f := [ :x | (-2 * x) -3 ].
0 to: 2000 by: 10 do: [ :nbOfTrained |
	r := Random new seed: 42.
	p := Neuron new.
	p weights: #(1 2).
	p bias: -1.
	
	nbOfTrained timesRepeat: [ 
		| anX anY |
		anX := (r nextInteger: 50) - 25.
		anY := (r nextInteger: 50) - 25.
		
		trainedOutput := (f value: anX) >= anY ifTrue: [ 1 ] ifFalse: [ 0 ].
		p train: (Array with: anX with: anY) desiredOutput: trainedOutput 
		].
	
	nbOfGood := 0.
	nbOfTries := 1000.
	nbOfTries timesRepeat: [ 
		| anX anY |
		anX := (r nextInteger: 50) - 25.
		anY := (r nextInteger: 50) - 25.
		realOutput := (f value: anX) >= anY
							ifTrue: [ 1 ]
							ifFalse: [ 0 ].
		( (p feed: { anX . anY } ) - realOutput ) abs < 0.2
			ifTrue: [ nbOfGood := nbOfGood + 1 ]. 
		].
		learningCurve add: { nbOfTrained . (nbOfGood / nbOfTries ) }.
		
	].

	xVals := OrderedCollection new.
	yVals := OrderedCollection new.
	
	learningCurve do: [ :i |
		xVals add: i first.
		yVals add: i second. 
		].

	chart := RSCompositeChart new.
	plot  := RSLinePlot new.
	plot x: xVals y: yVals.
	chart add: plot.

	
	chart addDecoration: RSHorizontalTick new.
	chart addDecoration: RSVerticalTick new.
	chart build.
	^ chart canvas open
]

{ #category : #computation }
Neuron >> output [
"Return the output value, previous computed when doing a feed:"

^ output
]

{ #category : #example }
Neuron >> predicting [
" Run the example to see the results:
	
	Neuron new predicting
	
	"
	
| canvas f dots p r anX anY designedOutput testPoints |
testPoints := OrderedCollection new.
canvas := RSCanvas new.
f := [ :x | (-2 * x) - 3 ].

p := Neuron new.
p weights: { 1 . 2 }.
p bias: -1.
r := Random new seed: 42.

"Training the perceptron:"
500 timesRepeat: [ 
	anX := (r nextInteger: 50) - 25.
	anY := (r nextInteger: 50) - 25.
	designedOutput := (f value: anX) >= anY
							ifTrue: [ 1 ]
							ifFalse: [ 0 ].
	p train: { anX . anY } desiredOutput: designedOutput.
	].

"Test points:"
500 timesRepeat: [ 
	testPoints add: { ( (r nextInteger: 50) - 25 ) . ( (r nextInteger: 50) - 25)  }
	].

dots := RSCircle models: testPoints forEach: [ :shape :point | 
	shape color: ( (p feed: point) > 0.5	
		ifTrue: [ Color red translucent ] 
		ifFalse: [ Color blue translucent ] )] .
	
canvas addAll: dots.
dots @ RSPopup.
	
RSNormalizer position 
	shapes: dots;
	from: -250 @ 250;
	to: 250 @ -250;
	normalize: [ :aPoint | aPoint first @ aPoint second ].
	
canvas add: (RSLine new from: 0 @ -250;  to: 0 @ 250 ).
canvas add: (RSLine new from: -250 @ 0; to: 250 @ 0).
canvas add: (RSLine new from: (-250 @ (f value: -250) negated); 
								to: (250 @ (f value: 250) negated );
								color: Color red;
								width: 3 ).

canvas zoomToFit.
canvas @ RSCanvasController .
canvas open.
]

{ #category : #initialization }
Neuron >> sigmoid [
"Use the sigmoid activation function"

activationFunction := SigmoidAF new.
]

{ #category : #initialization }
Neuron >> step [
"Use the step activation function"

activationFunction := StepAF new.
]

{ #category : #update }
Neuron >> train: inputs desiredOutput: desiredOutput [
	| diff output delta|
	
	output := self feed: inputs.
	diff  := desiredOutput - output.
	delta := diff * (activationFunction derivative: output).
	
	inputs withIndexDo: [ :anInput :index |
		weights at: index put: ( (weights at: index) + (learningRate * delta * anInput) )
		].
	bias := bias + (learningRate * delta).
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

weights := someWeightsAsNumbers asOrderedCollection.
]
