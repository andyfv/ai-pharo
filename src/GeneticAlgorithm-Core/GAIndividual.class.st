"
I am Generic Algorithm Individual

Responsibility: I hold genes and a fitness value. I generate genetic information.

Collaborators: .


Instance Variables
	fitness:		<Object>
	genes:		<OrderedCollection>
"
Class {
	#name : #GAIndividual,
	#superclass : #GAObject,
	#instVars : [
		'genes',
		'fitness'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAIndividual class >> create: nbOfIndividuals 
withNbOfGenes: nbOfGenes 
usingFactory: aBlockFactory [
	"Factory method to easily create a population of Individuals.
		nbOfIndividuals 	: number of individuals to return 
		nbOfGenes 			: number of genes each individual should have
		aBlockFactory		: a one-argument block to generate a gene"	
			
	^ self create: nbOfIndividuals 
				withNbOfGenes: nbOfGenes 
				usingFactory: aBlockFactory 
				with: (Random new seed: 42).  
]

{ #category : #'as yet unclassified' }
GAIndividual class >> create: nbOfIndividuals 
withNbOfGenes: nbOfGenes 
usingFactory: aBlockFactory
with: randomGenerator [
	"Factory method to easily create a population of Individuals.
		nbOfIndividuals 	: number of individuals to return 
		nbOfGenes 			: number of genes each individual should have
		aBlockFactory		: a one-argument block to generate a gene
		randomGenerator	: a random generator"	
			
	| someIndividuals ind |
	someIndividuals := OrderedCollection new.
	nbOfIndividuals timesRepeat: [ 
		ind := self new.
		ind random: randomGenerator.
		ind set: nbOfGenes genesUsing: aBlockFactory .
		someIndividuals add: ind. 
		].
		
	^ someIndividuals 
]

{ #category : #compute }
GAIndividual >> computeFitnessUsing: fitnessBlock [
	"Compute the fitness of mysef if not already computed"
	
	self assert: [ genes notNil ]
			description: 'Need to have some genes first'.
			
	"Simply exit of already computed"
	fitness ifNotNil: [ ^ self ].
	
	"Compute the fitness score"
	fitness := fitnessBlock value: genes. 
]

{ #category : #accessing }
GAIndividual >> fitness [
	"Retrn the fitness of the individual"
	
	^ fitness
]

{ #category : #accessing }
GAIndividual >> genes [
	"Return the individual's genes"
	
	^ genes
]

{ #category : #accessing }
GAIndividual >> genes: someGenes [
	"Set the genes of the indiviual. Used by the generic operations"
	
	genes := someGenes.
]

{ #category : #accessing }
GAIndividual >> numberOfGenes [
	"Return the number of genes the individual has"
	
	^ self genes size
]

{ #category : #accessing }
GAIndividual >> set: numberOfGenes genesUsing: geneBlockFactory [
	"Public method - Generate the genes of the individual"
	
	self checkForRandomNumber.
	genes := (1 to: numberOfGenes ) collect: [ :index | 
		geneBlockFactory 
			cull: random 
			cull: index 
			cull: self 
			].
]
