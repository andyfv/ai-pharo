Class {
	#name : #GAAlgorithmicExamples,
	#superclass : #Object,
	#category : #'GeneticAlgorithm-Examples'
}

{ #category : #'as yet unclassified' }
GAAlgorithmicExamples >> primes [
	"Use genetic algorithms to identify the prime factors of any given number
	
	Run the script below to see the results: "
	<script: 'self new primes' >
	
	| numberOfIdentityFactors primes candidates g |
	
	numberOfIdentityFactors := 345.
	primes := #( 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67
		71 73 79 83 89 97 101 103 107 109 113 127 131 139 149 151 157
		163 167 173 179 181 191 193 197 199).
	candidates := #(1) , primes.
	
	g := GAEngine new.
	g endIfNoImprovementFor: 10.
	g populationSize: 10000.
	g numberOfGenes: 10.
	g createGeneBlock: [ :rand :index :ind | candidates atRandom: rand].
	g minimizeComparator.
	g fitnessBlock: [ :genes | 
		((genes inject: 1 into: [:r :v | r * v ]) - numberOfIdentityFactors) abs ].
	g run.
	
	"If the the value is 0 we have found the exact prime factors.
	If not we can increase the population size or increase the number of generations 
	needed to find an improvement using endIfNoImporvement: method"
	g logs last bestFitness = 0
		ifTrue: [ ^ g result copyWithout: 1 ]
]
