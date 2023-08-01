"
Class: 
	I am an absract Activation Function.

Responsibility: 
	I have to main responsibilities:
	1) Computing the activation value
	2) Computing the transfer derivative
	
Public API and Key Messages:
	- eval: z
	- derivative: output  			""represents the mathematical derivative of eval: ""
	
"
Class {
	#name : #ActivationFunction,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #evaluation }
ActivationFunction >> derivative: output [
	^ self subclassResponsibility 
]

{ #category : #evaluation }
ActivationFunction >> eval: z [
	^ self subclassResponsibility 
]
