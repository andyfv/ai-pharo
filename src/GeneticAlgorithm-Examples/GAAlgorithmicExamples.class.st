Class {
	#name : #GAAlgorithmicExamples,
	#superclass : #Object,
	#category : #'GeneticAlgorithm-Examples'
}

{ #category : #'as yet unclassified' }
GAAlgorithmicExamples >> knapsack [
	"Use genetic algorithm to search for 
	solution of the knapsack problem.
	
	In this unbounded variant as a result we have a set of boxes.
	For this variant we have two objectives (constraints): 
		- maximizing the value of the bag
		- ensure that the overall weight does not exceed the maximum
	
	The objective are met by using a penalty
	
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
	solution of the 0-1 knapsack problem.
	
	In this 0-1 variant the solution is a set of 0 and 1.
	For this variant we have three objectives (constraints): 
		- maximizing the value of the bag
		- ensure that the overall weight does not exceed the maximum
		- boxes should not repeat themselves
	
	There could have been a second penalty to express the additional 
	(third) objective
	
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
GAAlgorithmicExamples >> meetingRoomScheduling [
	"Meetings should not overlap and should a minimum 
	amount of rooms

	Run the script below to see the results:"

	<script: 'self new meetingRoomScheduling'>
	| meetings g numberOfMeetings |
	"A meeting is a tuple with structure = (start time, end time)"
	meetings := #( #( 1 3 ) #( 2 3 ) #( 5 6 ) #( 7 9 ) #( 4 7 ) ).
	numberOfMeetings := meetings size.


	g := GAEngine new.
	g endIfNoImprovementFor: 10.
	g populationSize: 20000.

	"The number of genes is the number of meetings.
	Worst case scenario all the meetings are overlapping 
	and each meetings needs its own room. So the 
	maximum number of rooms = the maximum number of meetings."
	g numberOfGenes: numberOfMeetings.
	g createGeneBlock: [ :rand :index :ind |
		(1 to: numberOfMeetings) atRandom: rand ].

	"We want to minimize the number of rooms"
	g minimizeComparator.

	g fitnessBlock: [ :genes |
		| distribution numberOfOverlap |
		distribution := OrderedCollection new.
		numberOfMeetings timesRepeat: [
			distribution add: OrderedCollection new ].
		genes doWithIndex: [ :roomNumber :index |
			(distribution at: roomNumber) add: (meetings at: index) ].
		numberOfOverlap := 0.
		distribution do: [ :aSetOfMeetings |
			| table |
			table := OrderedCollection new: 10 withAll: 0.
			aSetOfMeetings do: [ :meeting |
				meeting first to: meeting second do: [ :v |
				table at: v put: (table at: v) + 1 ]
				].
			numberOfOverlap := numberOfOverlap
			                   + (table select: [ :v | v >= 2 ]) size
			].
		(distribution select: #notEmpty) size + numberOfOverlap
		].

	g run.
	^ g result asSet size
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

{ #category : #'as yet unclassified' }
GAAlgorithmicExamples >> sudoku [
	"We have a grid and a set of numbers.
	We want to combine the numbers in such a 
	way that each vertical, horizontal and diagonal
	line equals 30. In this scenario the grid is 3x3

	Run the script below to see the results:"

	<script: 'self new sudoku'>
	| numbers sums g canvas elements |
	numbers := #( 2 4 6 8 10 12 14 16 18 ).

	"The combinations to sum:"
	sums := {
		        #( 1 2 3 ).
		        #( 4 5 6 ).
		        #( 7 8 9 ).

		        "Diagonal sums"
		        #( 1 5 9 ).
		        #( 7 5 3 ).

		        "Verical sums"
		        #( 1 4 7 ).
		        #( 2 5 8 ).
		        #( 3 6 9 ) }.
	"Horizontal sums"

	g := GAEngine new.
	g populationSize: 400.
	g endIfFitnessIsAbove: 9.
	g mutationRate: 0.01.
	g numberOfGenes: 9.
	g createGeneBlock: [ :rand :index | numbers atRandom: rand ].
	g fitnessBlock: [ :genes |
		| score penalty |
		score := (sums collect: [ :arr |
			          (arr collect: [ :index | genes at: index ]) sum ])
			         inject: 0
			         into: [ :a :b | a + (b - 30) abs ].
		penalty := genes size - genes asSet size * 3.
		9 - (score + penalty)
		].
	g run.

	"Visualize the grid"
	canvas := RSCanvas new.
	elements := RSLabel models: g result.
	canvas addAll: elements.
	RSGridLayout new
		gapSize: 20;
		on: elements.

	canvas @ RSCanvasController.
	canvas open
]
