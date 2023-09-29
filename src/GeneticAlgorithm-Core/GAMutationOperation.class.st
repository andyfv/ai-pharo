Class {
	#name : #GAMutationOperation,
	#superclass : #GAAbstractMutationOperation,
	#instVars : [
		'geneFactoryBlock'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #testing }
GAMutationOperation >> checkForGeneFactory [
	self assert: [ geneFactoryBlock notNil ]
			description: 'Need to provide a block to create gene'
]

{ #category : #initialization }
GAMutationOperation >> doMutate: individual [
	"Mutate genes of the argument"
	
	self checkForRandomNumber.
	self checkForGeneFactory.
	
	1 to: individual genes size do: [ :index |
		self randomNumber <= mutationRate
			ifTrue: [ individual genes at: index 
														 put: (geneFactoryBlock cull: random
																							   cull: index
																							   cull: individual 
																 ) 							
						 ]
		]
]

{ #category : #initialization }
GAMutationOperation >> geneFactoryBlock [
	"Return the three-arg block used to create a gene,
	following the pattern: 
		[ :rand :index :ind | ... ]
		rand  : random number generator
		index : index of the gene
		ind   : individual being filled
	"

	^ geneFactoryBlock
]

{ #category : #initialization }
GAMutationOperation >> geneFactoryBlock: oneArgBlock [
	"The block receives a random number as an argument"
	
	geneFactoryBlock := oneArgBlock 
]
