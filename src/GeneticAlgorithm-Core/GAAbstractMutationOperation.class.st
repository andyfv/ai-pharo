Class {
	#name : #GAAbstractMutationOperation,
	#superclass : #GAOperation,
	#instVars : [
		'mutationRate'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #initialization }
GAAbstractMutationOperation >> doMutate: individual [
	"To be overriden"
	self subclassResponsibility 
]

{ #category : #initialization }
GAAbstractMutationOperation >> geneFactoryBlock: oneArgBlock [
	"Do nothing. May be override if necessary"
	
]

{ #category : #initialization }
GAAbstractMutationOperation >> initialize [

	super initialize.

	self mutationRate: 0.01
]

{ #category : #initialization }
GAAbstractMutationOperation >> mutate: individual [
	"Return a new individual (different object tahn the argument),
	result of a mutation from the individual provided as an argument"
	
	| newIndividual |
	newIndividual := GAIndividual new.
	newIndividual random: random.
	newIndividual genes: individual genes copy.
	self doMutate: newIndividual.
	^ newIndividual 
]

{ #category : #initialization }
GAAbstractMutationOperation >> mutationRate [
	"Return the used mutation rate. Tipically it is a small positive 
	number, close to 0.0 and significantly less than 1.0"
	
	^ mutationRate 
]

{ #category : #initialization }
GAAbstractMutationOperation >> mutationRate: aFloat [
	"Set the mutation rate. Tipically it is a small positive 
	number, close to 0.0 and significantly less than 1.0"

	mutationRate := aFloat 
]
