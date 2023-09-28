"
Class: I am a Generic Algorithm Object.

Responsibility: I hold a random number generator 

Public API and Key Messages

- random, random:, randomNumber
- checkForRandomBumber

Instance Variables:
	random:		Random Number Generator
"
Class {
	#name : #GAObject,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #testing }
GAObject >> checkForRandomNumber [
	"Ensure that a random number generator is set"
	
	self assert: [ random notNil ]
			description: 'Need to provide a random number generator'
			
		
]

{ #category : #accessing }
GAObject >> random [ 
	"Return the random number generator associated with the object"
		
	^ random
]

{ #category : #accessing }
GAObject >> random: aRandomNumberGenerator [ 
	"Set the random number generator associated with the object.
	The argument must be an instance of Random"
	
	random := aRandomNumberGenerator 
]

{ #category : #accessing }
GAObject >> randomNumber [
	"Return a number between 0.0. and 1.0"
	
	^ random next
]
