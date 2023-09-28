Class {
	#name : #GAIndividualTest,
	#superclass : #TestCase,
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #tests }
GAIndividualTest >> testCreation [
	| r individuals f ind |
	r := Random seed: 42.
	f := [ :random | ($a to: $z) atRandom: random ].
	individuals := GAIndividual create: 100 
													withNbOfGenes: 10 
													usingFactory: f 
													with: r.
													
	self assert: individuals size equals: 100.
	self assert: (individuals collect: #numberOfGenes) asSet asArray
			equals: #(10).
			
	ind := individuals anyOne.
	self assert: (ind genes allSatisfy: [ :c | ($a to: $z) includes: c ]).
]

{ #category : #tests }
GAIndividualTest >> testGuess [
	| individuals factory fitnessBlock |
	factory := [ :random | ($a to: $z) atRandom: random ].
	individuals := GAIndividual create: 100 
													withNbOfGenes: 3 
													usingFactory: factory.

	fitnessBlock := [ :genes | 
		(genes with: 'cat' asArray collect: 
			[ :a :b | (a == b) ifTrue: [ 1 ] ifFalse: [ 0 ] ]) sum
		].													
	individuals do: [ :i | i computeFitnessUsing: fitnessBlock ].
]
