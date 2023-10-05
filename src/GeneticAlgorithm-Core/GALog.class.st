"
Class: I represent a monitor for the execution of the evlution algorithm
Responsibility: 

Collaborators: GAIndividual

Public API and Key Messages:

Internal Representation and Key Implementation Points:

    Instance Variables
	averageFitness:		<Object>
	fittestIndividual:		<Object>
	generationNumber:		<Object>
	timeToProduceGeneration:		<Object>
	worseFitness:		<Object>

"
Class {
	#name : #GALog,
	#superclass : #Object,
	#instVars : [
		'generationNumber',
		'timeToProduceGeneration',
		'fittestIndividual',
		'averageFitness',
		'worstFitness'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #accessing }
GALog >> averageFitness [
	"Return the average fitness value of a generation I represent"
	
	^ averageFitness 
	
]

{ #category : #accessing }
GALog >> averageFitness: aNumber [
	"Set the average fitness value of a generation I represent"

	averageFitness := aNumber 
]

{ #category : #accessing }
GALog >> bestFitness [
	"Return the best finess value of a genertion I represent"
		
	^ fittestIndividual fitness
]

{ #category : #accessing }
GALog >> fittestIndividual [
	"Return the best individual of the generation I represent"
		
	^ fittestIndividual 
]

{ #category : #accessing }
GALog >> fittestIndividual: anIndividual [
	"Set the best individual of the generation I represent"

	fittestIndividual := anIndividual 
]

{ #category : #accessing }
GALog >> generationNumber [
	"Return the generation number I represent "
	
	^ generationNumber 
]

{ #category : #accessing }
GALog >> generationNumber: anInteger [
	"Set the generation number I represent "

	generationNumber := anInteger 
]

{ #category : #accessing }
GALog >> printOn: aStream [
	"Printing the log object"
	
	super printOn: aStream.
	
	aStream nextPut: $<.
	aStream nextPutAll: fittestIndividual genes asString.
	aStream nextPut: $>.
]

{ #category : #accessing }
GALog >> timeToProduceGeneration [
	"Time to produce a generation I represent"

	^ timeToProduceGeneration
]

{ #category : #accessing }
GALog >> timeToProduceGeneration: anInteger [
	"Set the time to produce a generation I represent. Set by the engine"

	timeToProduceGeneration := anInteger 
]

{ #category : #accessing }
GALog >> worstFitness [
	"Return the worst fitness of a generation I represent"

	^ worstFitness
]

{ #category : #accessing }
GALog >> worstFitness: aNumber [
	"Set the worst fitness of a generation I represent"

	worstFitness := aNumber
]
