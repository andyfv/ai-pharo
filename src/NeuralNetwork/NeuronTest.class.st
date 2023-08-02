Class {
	#name : #NeuronTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'tests - compare' }
NeuronTest >> compareLearningRate [
"Visualize the difference in learning rate between the perceptron and the sigmoid neuron"
"Run the example to see the results: 

	NeuronTest new compareLearningRate 
	
	"

| learningCurveNeuron learningCurvePerceptron chart plot1 plot2 |

learningCurveNeuron := OrderedCollection new.
0 to: 1000 do: [ :nbOfTrained |
	| p res |
	p := Neuron new.
	p sigmoid.
	p weights: #(-1 -1).
	p bias: 2. 
	
	nbOfTrained timesRepeat: [ 
		p train: #(0 0) desiredOutput: 0.
		p train: #(0 1) desiredOutput: 0.
		p train: #(1 0) desiredOutput: 0.
		p train: #(1 1) desiredOutput: 1.
		].
	
	res := ((p feed: #(0 0)) - 0 ) abs +
				((p feed: #(0 1)) - 0 ) abs +
				((p feed: #(1 0)) - 0 ) abs +
				((p feed: #(1 1)) - 1 ) abs.
				
	learningCurveNeuron add: res / 4.
	].

learningCurvePerceptron := OrderedCollection new.
0 to: 1000 do: [ :nbOfTrained |
	| p res |
	p := Neuron new.
	p step.
	p weights: #(-1 -1).
	p bias: 2. 
	
	nbOfTrained timesRepeat: [ 
		p train: #(0 0) desiredOutput: 0.
		p train: #(0 1) desiredOutput: 0.
		p train: #(1 0) desiredOutput: 0.
		p train: #(1 1) desiredOutput: 1.
		].
	
	res := ((p feed: #(0 0)) - 0 ) abs +
				((p feed: #(0 1)) - 0 ) abs +
				((p feed: #(1 0)) - 0 ) abs +
				((p feed: #(1 1)) - 1 ) abs.
				
	learningCurvePerceptron add: res / 4.
	].

chart := RSCompositeChart new.
plot1  := RSLinePlot new y: learningCurveNeuron.
plot1 removeAllTicks .
plot1 color: Color blue.
chart add: plot1.

plot2 := RSLinePlot new y: learningCurvePerceptron .
plot2 removeAllTicks.
plot2 color: Color green.
chart add: plot2.

chart addDecoration: (RSHorizontalTick new doNotUseNiceLabel asFloat: 1).
chart addDecoration: (RSVerticalTick new doNotUseNiceLabel asFloat: 2).
chart xlabel: 'Epoch'.
chart ylabel: 'Error'.
chart build.

^ chart canvas open
]

{ #category : #tests }
NeuronTest >> testTrainingAND [
| p |
p := Neuron new.
p weights: #(-1 -1).
p bias: 2.

5000 timesRepeat: [ 
	p train: #(0 0) desiredOutput: 0.
	p train: #(0 1) desiredOutput: 0.
	p train: #(1 0) desiredOutput: 0.
	p train: #(1 1) desiredOutput: 1. 
	].

self assert: ( (p feed: #(0 0)) closeTo: 0 precision: 0.1 ).
self assert: ( (p feed: #(0 1)) closeTo: 0 precision: 0.1 ).
self assert: ( (p feed: #(1 0)) closeTo: 0 precision: 0.1 ).
self assert: ( (p feed: #(1 1)) closeTo: 1 precision: 0.1 ).
]

{ #category : #tests }
NeuronTest >> testTrainingNOR [
| p |
p := Neuron new.
p weights: #(-1 -1).
p bias: 2.

5000 timesRepeat: [ 
	p train: #(0 0) desiredOutput: 1.
	p train: #(0 1) desiredOutput: 0.
	p train: #(1 0) desiredOutput: 0.
	p train: #(1 1) desiredOutput: 0.
	].

self assert: ( (p feed: #(0 0)) closeTo: 1 precision: 0.1 ).
self assert: ( (p feed: #(0 1)) closeTo: 0 precision: 0.1 ).
self assert: ( (p feed: #(1 0)) closeTo: 0 precision: 0.1 ).
self assert: ( (p feed: #(1 1)) closeTo: 0 precision: 0.1 ).
]

{ #category : #tests }
NeuronTest >> testTrainingNOT [
| p |
p := Neuron new.
p weights: #(-1).
p bias: 2.

5000 timesRepeat: [ 
	p train: #(0) desiredOutput: 1.
	p train: #(1) desiredOutput: 0. 
	].

self assert: ( (p feed: #(0)) closeTo: 1 precision: 0.1 ).
self assert: ( (p feed: #(1)) closeTo: 0 precision: 0.1 ).
]

{ #category : #tests }
NeuronTest >> testTrainingOR [
| p |
p := Neuron new.
p weights: #(-1 -1).
p bias: 2.

5000 timesRepeat: [ 
	p train: #(0 0) desiredOutput: 0.
	p train: #(0 1) desiredOutput: 1.
	p train: #(1 0) desiredOutput: 1.
	p train: #(1 1) desiredOutput: 1. 
	].

self assert: ( (p feed: #(0 0)) closeTo: 0 precision: 0.1 ).
self assert: ( (p feed: #(0 1)) closeTo: 1 precision: 0.1 ).
self assert: ( (p feed: #(1 0)) closeTo: 1 precision: 0.1 ).
self assert: ( (p feed: #(1 1)) closeTo: 1 precision: 0.1 ).
]
