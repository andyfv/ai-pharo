"
Class: I represent a tournament selection strategy to select an individual from a population

"
Class {
	#name : #GATournamentSelection,
	#superclass : #GASelection,
	#instVars : [
		'tournamentSize'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #initialization }
GATournamentSelection >> createNewPopulation [
	"Return a new population made of newly breed individual"
	
	| partnerA partnerB child |
	
	population := (1 to: self populationSize) collect: [ :seed |
		engine random: (Random seed: seed).
		partnerA := self getGoodIndividual.
		partnerB := self getGoodIndividual.
		child := self mutate: (self crossover: partnerA with: partnerB ).
		child computeFitnessUsing: engine fitnessBlock.
		child.
		] 
]

{ #category : #initialization }
GATournamentSelection >> getGoodIndividual [
	"Return the best individual from tournamentSize individual randomly 
	chosen from the population"
	
	| best ind |
	best := nil.
	tournamentSize timesRepeat: [ 
		ind := initialPopulation at: (self randomNumber: initialPopulation size).
		(best isNil or: [compareFitness value: ind fitness value: best fitness])
			ifTrue: [ best := ind ] 
		].
	
	^ best
]

{ #category : #initialization }
GATournamentSelection >> initialize [ 
	super initialize.
	
	tournamentSize := 5
]
