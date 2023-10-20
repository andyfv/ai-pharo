Class {
	#name : #GAAlgorithmicExamples,
	#superclass : #Object,
	#category : #'GeneticAlgorithm-Examples'
}

{ #category : #'as yet unclassified' }
GAAlgorithmicExamples >> knapsack [
	"Use genetic algorithm to search for 
	solution of the knapsack problem
	
	Run the script below to see the results:"
	<script: 'self new knapsack'>
	
	| maxWeight boxes g |
	
	"The maximum weight capacity of the knapsack"
	maxWeight := 15.
	
	"A box is a tuple of (value, weight).
	There is a empty box with (value, weight) = (0, 0) in order for 
	the algorithm to be able to find solutions for unbounded 
	versions of the problem. It will pick the possible boxes 
	and fill the remaining slots with empty boxes."
	boxes := #( #(4 12) #(2 1) #(2 2) #(1 1) #(10 4) #(0 0) ).
	
	g := GAEngine new.
	g endIfNoImprovementFor: 10.
	g populationSize: 20000.
	
	"Because the lightest box is 1kg, there could not be more 
	than 15 boxes. Thus the maximum number of genes possible is 15"
	g numberOfGenes: 15.
	g createGeneBlock: [ :rand :index :ind | boxes atRandom: rand ].
	g maximizeComparator.
	g fitnessBlock: [ :genes | 
		| totalWeight totalValue penalty |
		totalValue := (genes collect: #first) sum.
		totalWeight := (genes collect: #second) sum.
		maxWeight < totalWeight 
			ifTrue: [ penalty := (maxWeight - totalWeight) abs * 50 ]
			ifFalse: [ penalty := 0 ].
		totalValue - penalty.
		].
	g run.
	^ g result copyWithout: #(0 0).
]

{ #category : #'as yet unclassified' }
GAAlgorithmicExamples >> knapsack01 [
	"Use genetic algorithm to search for 
	solution of the 0-1 knapsack problem
	
	Run the script below to see the results:"
	<script: 'self new knapsack01'>
	
	| maxWeight boxes g decodeToBoxes |
	
	"The maximum weight capacity of the knapsack"
	maxWeight := 15.
	
	"A box is a tuple of (value, weight)."
	boxes := #( #(4 12) #(2 1) #(2 2) #(1 1) #(10 4) ).
	
	g := GAEngine new.
	g endIfNoImprovementFor: 10.
	g populationSize: 20000.
	g numberOfGenes: boxes size.
	
	"A gene is either 0 or 1"
	g createGeneBlock: [ :rand :index :ind | #(0 1) atRandom: rand ].
	g maximizeComparator.
	g fitnessBlock: [ :genes | 
		| totalWeight totalValue penalty |
		decodeToBoxes := OrderedCollection new.
		genes doWithIndex: [ :b :ind | b = 1 ifTrue: [ 
				decodeToBoxes add: (boxes at: ind) ] ].
		decodeToBoxes 
			ifEmpty: [ 
				totalValue := 0. 
				totalWeight := 0 
				]
			ifNotEmpty: [ 
				totalValue := (decodeToBoxes collect: #first) sum.
				totalWeight := (decodeToBoxes collect: #second) sum. 
				].
		maxWeight < totalWeight 
			ifTrue: [ penalty := (maxWeight - totalWeight) abs * 50 ]
			ifFalse: [ penalty := 0 ].
		totalValue - penalty.
		].
	g run.
	
	decodeToBoxes := OrderedCollection new.
	g result doWithIndex: [ :b :ind |
		b = 1 ifTrue: [ decodeToBoxes add: (boxes at: ind) ] ].
	^ decodeToBoxes 
]

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
