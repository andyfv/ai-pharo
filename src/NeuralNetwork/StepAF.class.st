"
Class:
	I am an Step Activation Function. I have a verticle step and therefore I am non-derivable

Responsibility:
	I have to main responsibilities:
		1) Computing the activation value. Either 1 or 0
		2) Computing the transfer derivative. 
		
Collaborators:


Public API and Key Messages:

	- eval: z
	- derivative: output  			""represents the mathematical derivative of eval: . Check implementation""
		

Internal Representation and Key Implementation Points""


    Implementation Points
"
Class {
	#name : #StepAF,
	#superclass : #ActivationFunction,
	#category : #NeuralNetwork
}

{ #category : #evaluation }
StepAF >> derivative: output [
	^ 1
]

{ #category : #evaluation }
StepAF >> eval: z [
	^ (z > 0) ifTrue: [ 1 ] ifFalse: [ 0 ]
]
