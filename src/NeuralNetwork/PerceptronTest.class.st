Class {
	#name : #PerceptronTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'instance creation' }
PerceptronTest >> digitalComparator: inputs [ 
	"Receive two elements as inputs.
	Return an array of three elements."
	
	|not and nor a b aGb aEb aLb notA notB|
	
	a := inputs first.
	b := inputs second.
	
	and := self newNeuron weights: #(1 1); bias: -1.5.
	not := self newNeuron weights: #(-1);  bias: 0.5.
	nor := self newNeuron weights: #(-1 -1); bias: 0.5.
	
	notA := not feed: { a }.
	notB := not feed: { b }.
	
	aLb := and feed: { notA . b }. 	"A = 0, B = 1, A < B"
	aGb := and feed: { a . notB }.		"A = 1, B = 0, A > B"
	aEb := nor feed: { aGb . aLb }.	"A = 0, B = 0, A = B  or
												 A = 1, B = 1, A = B"
	
	^ { aGb . aEb . aLb }
]

{ #category : #'instance creation' }
PerceptronTest >> newNeuron [
"Return a new neuron"

^ Neuron new step.
]

{ #category : #tests }
PerceptronTest >> testAND [
	|p|
	p := self newNeuron.
	p weights: #(1 1).
	p bias: -1.5.
	
	self assert: (p feed: #(0 0)) equals: 0.
	self assert: (p feed: #(0 1)) equals: 0.
	self assert: (p feed: #(1 0)) equals: 0.
	self assert: (p feed: #(1 1)) equals: 1.
	
]

{ #category : #tests }
PerceptronTest >> testAddingWeightsAsDynamicCollection [
	"Test that the weights instance variable 
	is not stored as a literal array but as a
	dynamic one."
	
	|p|
 	p := self newNeuron.
	p weights: #(1 2).
	
	p weights at: 1 put: 3.
	p weights at: 2 put: 4.
	
	self assert: (p weights at: 1) equals: 3.
	self assert: (p weights at: 2) equals: 4.
]

{ #category : #tests }
PerceptronTest >> testDidigitalComparator [
	self assert: (self digitalComparator: #(0 0)) equals: #(0 1 0).
	self assert: (self digitalComparator: #(0 1)) equals: #(0 0 1).
	self assert: (self digitalComparator: #(1 0)) equals: #(1 0 0).
	self assert: (self digitalComparator: #(1 1)) equals: #(0 1 0).	
]

{ #category : #tests }
PerceptronTest >> testNOR [
	"Negating the weights and the bias results in a negated logic gate"
	|p|
	p := self newNeuron.
	p weights: #(-1 -1).
	p bias: 0.5.
	
	self assert: (p feed: #(0 0)) equals: 1.
	self assert: (p feed: #(0 1)) equals: 0.
	self assert: (p feed: #(1 0)) equals: 0.
	self assert: (p feed: #(1 1)) equals: 0.
	
]

{ #category : #tests }
PerceptronTest >> testNOT [
	|p|
	p := self newNeuron.
	p weights: #(-1).
	p bias: 0.5.
	
	self assert: (p feed: #(0)) equals: 1.
	self assert: (p feed: #(1)) equals: 0.
	
]

{ #category : #tests }
PerceptronTest >> testOR [
	|p|
	p := self newNeuron.
	p weights: #(1 1).
	p bias: -0.5.
	
	self assert: (p feed: #(0 0)) equals: 0.
	self assert: (p feed: #(0 1)) equals: 1.
	self assert: (p feed: #(1 0)) equals: 1.
	self assert: (p feed: #(1 1)) equals: 1.
	
]

{ #category : #tests }
PerceptronTest >> testSmallExample [
|p result|

p := self newNeuron.
p weights: #(1 2).
p bias: -2.
result := p feed: #(5 2).

self assert: result equals: 1.
]

{ #category : #tests }
PerceptronTest >> testSmallExampleWithOppositeValues [
|p result|

p := self newNeuron.
p weights: #(1 2).
p bias: -2.
result := p feed: #(2 -2).

self assert: result equals: 0.
]

{ #category : #'tests-Training Logic Gates' }
PerceptronTest >> testTrainingAND [
	| p |
	p := self newNeuron.
	p weights: #(-1 -1).
	p bias: 2.
	
	40 timesRepeat: [ 
		p train: #(0 0) desiredOutput: 0.
		p train: #(0 1) desiredOutput: 0.
		p train: #(1 0) desiredOutput: 0.
		p train: #(1 1) desiredOutput: 1. 
		].
	
	self assert: (p feed: #(0 0)) equals: 0.
	self assert: (p feed: #(0 1)) equals: 0.
	self assert: (p feed: #(1 0)) equals: 0.
	self assert: (p feed: #(1 1)) equals: 1.
]

{ #category : #'tests-Training Logic Gates' }
PerceptronTest >> testTrainingNOR [
	| p |
	p := self newNeuron.
	p weights: #(-1 -1).
	p bias: 2.
	
	40 timesRepeat: [ 
		p train: #(0 0) desiredOutput: 1.
		p train: #(0 1) desiredOutput: 0.
		p train: #(1 0) desiredOutput: 0.
		p train: #(1 1) desiredOutput: 0. 
		].
	
	self assert: (p feed: #(0 0)) equals: 1.
	self assert: (p feed: #(0 1)) equals: 0.
	self assert: (p feed: #(1 0)) equals: 0.
	self assert: (p feed: #(1 1)) equals: 0.
]

{ #category : #'tests-Training Logic Gates' }
PerceptronTest >> testTrainingNOT [
	"Test training a perceptron to model the NOT logical gate"
	| p |
	p := self newNeuron.
	p weights: #(-1).
	p bias: 2.
	
	5 timesRepeat: [ 
		p train: #(0) desiredOutput: 1.
		p train: #(1) desiredOutput: 0. 
		].
	
	self assert: (p feed: #(0)) equals: 1.
	self assert: (p feed: #(1)) equals: 0.
]

{ #category : #'tests-Training Logic Gates' }
PerceptronTest >> testTrainingOR [
	| p |
	p := self newNeuron.
	p weights: #(-1 -1).
	p bias: 2.
	
	40 timesRepeat: [ 
		p train: #(0 0) desiredOutput: 0.
		p train: #(0 1) desiredOutput: 1.
		p train: #(1 0) desiredOutput: 1.
		p train: #(1 1) desiredOutput: 1. 
		].
	
	self assert: (p feed: #(0 0)) equals: 0.
	self assert: (p feed: #(0 1)) equals: 1.
	self assert: (p feed: #(1 0)) equals: 1.
	self assert: (p feed: #(1 1)) equals: 1.
]

{ #category : #tests }
PerceptronTest >> testWrongFeeding [
"The number of inputs and weights should match. Returns an error if mismatched"
	|p|
	
	p := self newNeuron.
	p weights: #(-1).
	p bias: 0.5.
	
	self should: [ p feed: #(1 1) ] raise: Error.
]
