"
Class:
	I am an Sigmoid Activation Function.

Responsibility:
	I have to main responsibilities:
		1) Computing the activation value
		2) Computing the transfer derivative
		
Collaborators:


Public API and Key Messages:

	- eval: z
	- derivative: output  			""represents the mathematical derivative of eval: ""
		

Internal Representation and Key Implementation Points""


    Implementation Points
"
Class {
	#name : #SigmoidAF,
	#superclass : #ActivationFunction,
	#category : #NeuralNetwork
}

{ #category : #evaluation }
SigmoidAF >> derivative: output [
"sigma(z)' = sigma(z) * (1 - sigma(z))"
	^ output * ( 1 - output )
]

{ #category : #evaluation }
SigmoidAF >> eval: z [
	^ 1 / (1 + z negated exp)
	
]
