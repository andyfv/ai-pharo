"
Class:  I am referencing a population of a GAIndividual instance 

Responsibility: My purpose is to pick the fittest individual based on a strategy implemented by a
							subclass of mine. The selection is aware of the initialPopulation, which is necessary 
							to deduce a new population of a size populationSize. 

Collaborators Part: 	
	- GAEngine
	- GAIndividual

Public API and Key Messages:


Internal Representation and Key Implementation Points.

    Instance Variables
	compareFitness:			<BlockClosure>		A two-argument block that indicates which of two fitness values is best.																	
	engine:							<GAEngine>			Genetic algorithm engine
	fitnessBlock:				<BlockClosure>		The way the fitness of each individual is computed
	fittest:						<GAIndividual>		The fittest individual
	initialPopulation:		<Object>				The initial population	
	population:					<Object>				The new population
	populationSize:			<Object>				The size of the new population

"
Class {
	#name : #GASelection,
	#superclass : #Object,
	#instVars : [
		'population',
		'fittest',
		'initialPopulation',
		'fitnessBlock',
		'populationSize',
		'compareFitness',
		'engine'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #initialization }
GASelection >> checkIfEngineSet [
	self assert: [ engine notNil ] description: 'Should set the engine'
]

{ #category : #initialization }
GASelection >> checkIfInitialPopulationSet [

	self
		assert: [ initialPopulation notNil ]
		description: 'Should set the initial population'.
	self
		assert: [ initialPopulation isCollection ]
		description: 'Has to be a collection'.
	self
		assert: [ initialPopulation notEmpty ]
		description: 'Cannot be empty'
]

{ #category : #initialization }
GASelection >> compareFitness: aTwoArgBlock [
	"Take as argument a two-arg block that compares the fitness
	of two individuals"
	
	compareFitness := aTwoArgBlock 
]

{ #category : #initialization }
GASelection >> createNewPopulation [
	"Create a new population"
	
	self subclassResponsibility 
]

{ #category : #initialization }
GASelection >> crossover: partnerA with: partnerB [
	"Return one child, result of the crossover of the two arguments"
	
	^ engine crossover: partnerA with: partnerB  
]

{ #category : #initialization }
GASelection >> doSelection [
	"Produce a new population using the selection algorithm"
	
	self checkIfEngineSet .
	self checkIfInitialPopulationSet.
	populationSize := initialPopulation size.
	fittest := initialPopulation first.
	initialPopulation do: [ :ind |
		ind computeFitnessUsing: fitnessBlock.
		(self isIndividual: ind betterThan: fittest)
			ifTrue: [ fittest := ind ].
		].
	self createNewPopulation.
	initialPopulation := population.
	
]

{ #category : #initialization }
GASelection >> engine [
	"Return the GAEngine to which the selection is associated" 
	^ engine
]

{ #category : #initialization }
GASelection >> engine: anEngine [
	"Set the GAEngine to which the selection is associated with"

	engine := anEngine.
	self checkIfEngineSet.
]

{ #category : #initialization }
GASelection >> fitnessBlock [ 
	"Return the aon-arg block used to compute the fitness of each individual"
	
	^ fitnessBlock
]

{ #category : #initialization }
GASelection >> fitnessBlock: aOneArgBlock [
	"The argument is evaluated on the genes of each individual.
	The block argument has to compute the fitness"
	
	fitnessBlock := aOneArgBlock
]

{ #category : #initialization }
GASelection >> fittest [
	"Return the fittest individual from the new population"
	
	^ fittest
]

{ #category : #initialization }
GASelection >> initialPopulation: aPopulation [
	"Set the initial population. This is used to create the new
	population"

	initialPopulation := aPopulation.
	self checkIfInitialPopulationSet 
]

{ #category : #initialization }
GASelection >> initialize [ 
	super initialize.
	population := OrderedCollection new.
]

{ #category : #initialization }
GASelection >> isIndividual: ind betterThan: fittestIndividual [
	"Is the first individual better than the second"
	
	 ^ engine isIndividual: ind betterThan: fittestIndividual
	
]

{ #category : #initialization }
GASelection >> mutate: child [
	"Perform a mutation on the argument"
	
	^ engine mutate: child
]

{ #category : #initialization }
GASelection >> population [
	"Return the new population"
	^ population
]

{ #category : #initialization }
GASelection >> populationSize [
	"Return the population size"
	
	^ initialPopulation size
]

{ #category : #initialization }
GASelection >> populationSize: anInteger [
	"Set the population size"

	initialPopulation := anInteger 
]

{ #category : #initialization }
GASelection >> randomNumber: aValue [
	"Return a number between 1 and value"
	
	^ engine randomNumber: aValue
]
