Class {
	#name : #PerceptronTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'instance creation' }
PerceptronTest >> newNeuron [
"Return a new neuron"

^ Neuron new.
]

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
PerceptronTest >> testSmallExample [
|p result|

p:= self newNeuron.
p weights: #(1 2).
p bias: -2.
result := p feed: #(5 2).

self assert: result equals: 1.
]
