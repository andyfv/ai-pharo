Class {
	#name : #GAIndividualExamples,
	#superclass : #Object,
	#category : #'GeneticAlgorithm-Examples'
}

{ #category : #tests }
GAIndividualExamples >> testGuess [
	"Run the script below to see the results:"
	<script: 'self new testGuess'>
	
	| individuals factory fitnessBlock data chart plot |
	factory := [ :random | ($a to: $z) atRandom: random ].
	individuals := GAIndividual create: 1000
													withNbOfGenes: 3 
													usingFactory: factory.

	fitnessBlock := [ :genes | 
		(genes with: 'cat' asArray collect: 
			[ :a :b | (a == b) ifTrue: [ 1 ] ifFalse: [ 0 ] ]) sum
		].													
	individuals do: [ :i | i computeFitnessUsing: fitnessBlock ].
	
	data := (((individuals collect: #fitness) groupedBy: #yourself) associations 
					collect: [ :as | as key -> as value size ]) sorted.
					
	"Graph the results"
	chart := RSCompositeChart new.
	plot := RSBarPlot new rawData: data x: #key y: #value.
	plot yLog.
	chart add: plot.
	chart removeHorizontalTicks.
	chart addDecoration: (RSHorizontalTick new ticksData: (plot xValues); integer).
	chart build.
	
	plot bars @ RSPopup.
	^ chart canvas	
]
