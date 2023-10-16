"
Class: I represent an genetic algorithm engine.
Responsibility: Configure and run the genetic algorithm
Collaborators:
Public API and Key Messages:

Internal Representation and Key Implementation Points:

    Instance Variables
	beforeCreatingInitialIndividual:		<Block>				one-arg block evaluated before and individual is created
	compareFitness:									<Block>				two-arg block. compare which fitness is better
	createGeneBlock:									<Block> 			a gene block factory
	crossoverOperator:								<Object>			the crossover operator
	fitnessBlock:										<GAOperation> one-arg block. Takes the genes of each individual 
																						and returns the fitness of the individual
	logs:													<Collection> 	evolutionary history of the algorithm. 
																						collection of instances of GALog
	mutationOperator:								<GAOperation> the mutation operator
	numberOfGenes:										<Object> 			number of genes each individual has
	population:											<Object> 			the individual population
	populationSize:									<Object> 			the size of the population
	selection:											<GASelection> 	a selection algorithm		
	terminationBlock:								<Block>				a block that indicates when the algorithm 
																						has to stop.

"
Class {
	#name : #GAEngine,
	#superclass : #GAObject,
	#instVars : [
		'fitnessBlock',
		'createGeneBlock',
		'numberOfGenes',
		'populationSize',
		'logs',
		'population',
		'terminationBlock',
		'compareFitness',
		'mutationOperator',
		'crossoverOperator',
		'selection',
		'beforeCreatingInitialIndividual'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #configuration }
GAEngine >> beforeCreatingInitialIndividual: aOneArgBlock [
	"Set the behaviour to be executed before creating an individual.
	The block takes a random number generator as a n argument."
	
	beforeCreatingInitialIndividual := aOneArgBlock 
]

{ #category : #configuration }
GAEngine >> beforeRun [
	"Method executed before creating the initial population"
	
	self checkIfReadyToRun.
	selection fitnessBlock: fitnessBlock.
	selection populationSize: populationSize.
]

{ #category : #testing }
GAEngine >> checkIfReadyToRun [
	"Raise an exception if the configuration is not ready to be run"

	self
		assert: [ fitnessBlock notNil ]
		description: 'Need to set a fitnessBlock'.

	self
		assert: [ createGeneBlock notNil ]
		description: 'Need to set a createGeneBlock'.

	self
		assert: [ numberOfGenes notNil ]
		description: 'Need to set how many genes you wish to have,
			using numberOfGenes: '.

	self assert: [ logs isEmpty ] description: 'Already  been run'
]

{ #category : #operations }
GAEngine >> createGeneBlock: threeArgBlock [
	"Three arguments must be provided rand, index, and the individual being filled"
	
	createGeneBlock := threeArgBlock.
	mutationOperator geneFactoryBlock: threeArgBlock 
]

{ #category : #operations }
GAEngine >> crossover: partnerA with: partnerB [
	"Perform a crossover operation between the two arguments" 
	
	^ crossoverOperator crossover: partnerA with: partnerB.
]

{ #category : #accessing }
GAEngine >> crossoverOperator: aCrossoverOperator [
	"Set the crossover operator used in the algorithm"
	
	crossoverOperator := aCrossoverOperator.
	crossoverOperator random: random. 
]

{ #category : #configuration }
GAEngine >> endForMaxNumberOfGeneration: nbOfGenerations [
	"End the algorithm after a fixed number of generations"
	
	terminationBlock := [ logs last generationNumber >= nbOfGenerations ]
]

{ #category : #configuration }
GAEngine >> endIfFitnessIsAbove: aValueTreshhold [
	"End the algorithm if the best fitness value is above a particular threshold"

	terminationBlock := 
		[ logs last fittestIndividual fitness >= aValueTreshhold ]
]

{ #category : #configuration }
GAEngine >> endIfNoImprovementFor: nbOfGenerations [
	"End if no improvememnt occurred within a given number 
	of generations"
	
	^ self endIfNoImprovementFor: nbOfGenerations withinRangeOf: 0
]

{ #category : #configuration }
GAEngine >> endIfNoImprovementFor: nbOfGenerations withinRangeOf: delta [
	"End if no improvement occired (within a delta value) within a 
	given number of generations"
	
	terminationBlock := [ (logs last generationNumber => nbOfGenerations) and: 
		[ | fs |
		fs := (logs last: nbOfGenerations) collect: [ :aLog | aLog
			fittestIndividual fitness ].
		(fs max - fs min) <= delta
		]
	]
]

{ #category : #accessing }
GAEngine >> fitnessBlock [
	"Return the fitness bock used by the engine"

	^ fitnessBlock
]

{ #category : #accessing }
GAEngine >> fitnessBlock: aOneArgBlock [
	"The argment is evaluted on the genes of each individual.
	The block argument has to compute the ftness"
	
	fitnessBlock := aOneArgBlock
]

{ #category : #accessing }
GAEngine >> initialize [

	super initialize.

	logs := OrderedCollection new.
	random := Random seed: 42.
	self endForMaxNumberOfGeneration: 10.
	populationSize := 10.
	self maximizeComparator.

	mutationOperator := GAMutationOperation new.
	mutationOperator mutationRate: 0.01.
	mutationOperator random: random.

	crossoverOperator := GACrossoverOperation new.
	crossoverOperator random: random.

	self selection: GATournamentSelection new.

	beforeCreatingInitialIndividual := [ :rand | "do nothing per default"
	                                    ]
]

{ #category : #accessing }
GAEngine >> initializePopulation [

	self checkForRandomNumber.
	population := OrderedCollection new.
	populationSize timesRepeat: [
		| ind |
		beforeCreatingInitialIndividual value: random.
		ind := GAIndividual new.
		population add: (ind
				 random: random;
				 set: numberOfGenes genesUsing: createGeneBlock)
		]
]

{ #category : #visualization }
GAEngine >> inspectorViewFitness [
	<inspectorPresentationOrder: 90 title: 'Fitness'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self viewFitness;
		yourself.
]

{ #category : #visualization }
GAEngine >> inspectorViewFitnessContext: aContext [
	aContext withoutEvaluator 
]

{ #category : #testing }
GAEngine >> isIndividual: anIndividual betterThan: aFittestIndividual [
	"Compare an individual against the fittest individual of the population"
	
	^ compareFitness value: anIndividual fitness
								value: aFittestIndividual fitness 
]

{ #category : #accessing }
GAEngine >> logs [
	"Return the logs of the run"
	
	^ logs
]

{ #category : #configuration }
GAEngine >> maximizeComparator [
	"A better indiviudal is the one with the highest finess value"
	
	compareFitness := [ :f1 :f2 | f1 > f2 ]
]

{ #category : #configuration }
GAEngine >> microPause [
	"Useful when you wish to log in the transcript and see progresses"
	
	(Delay forMilliseconds: 1) wait.
	
	World doOneCycleNow.
	
	
]

{ #category : #configuration }
GAEngine >> minimizeComparator [
	"A better indiviudal is the one with the lowest finess value"

	compareFitness := [ :f1 :f2 | f1 < f2 ]
]

{ #category : #accessing }
GAEngine >> mutate: anIndividual [
	"Mutate the child provided as an argument"
	
	^ mutationOperator mutate: anIndividual 
]

{ #category : #accessing }
GAEngine >> mutationOperator: aMutationOperator [
	mutationOperator := aMutationOperator.
	aMutationOperator random: random
]

{ #category : #accessing }
GAEngine >> mutationRate: aFloat [
	"Set the mutation rate used by the engine.
	The default value is 0.01"
	
	mutationOperator mutationRate: aFloat 
]

{ #category : #accessing }
GAEngine >> numberOfGenes: anInteger [
	"Set the number of genes each individual will have"
	
	numberOfGenes := anInteger
	
	
]

{ #category : #accessing }
GAEngine >> populationSize: anInteger [
	"Set the population size"
	populationSize := anInteger 
]

{ #category : #operations }
GAEngine >> produceNewPopulation [
	"This method 
		-	produces a new population, set in the variables 'population'
		- select the fittest element of the population"

	selection doSelection.
	population := selection population
]

{ #category : #accessing }
GAEngine >> randomNumber: maxNumber [
	"Return a number between 1 and maxNumber"

	^ random nextInteger: maxNumber
]

{ #category : #accessing }
GAEngine >> result [
	"Return the genes of the fittest individual. This method is 
	expected to be execited after #run has completed"
	
	^ self logs last fittestIndividual genes
]

{ #category : #operations }
GAEngine >> run [
	"Public method -- Run the genetic algorithm"
	
	| t log |
	self beforeRun.
	self initializePopulation.
	
	selection initialPopulation: population.
	selection compareFitness: compareFitness.
	
	UIManager default
		informUserDuring: [ :bar |
			| gen |
			gen := 0.
			[ self shouldTerminate ] whileFalse: [ gen := gen + 1. 
				bar label: gen asString.
				self microPause.
				t := Time now asSeconds.
				self produceNewPopulation.
				
				log := GALog new.
				log generationNumber: gen.
				log fittestIndividual: selection fittest.
				log worstFitness: ( (population collect: #fitness)
					inject: log bestFitness into: [ :wFit :current | 
						(compareFitness value: wFit value: current) 
							ifTrue: [ current ]
							ifFalse: [ wFit ]
						] ).
				log averageFitness: (population collect: #fitness)
							average asFloat.
				log timeToProduceGeneration: Time now asSeconds - t.
				logs add: log.	
				]
			]
]

{ #category : #accessing }
GAEngine >> selection [
	"Return the selection operator"
	
	^ selection
]

{ #category : #accessing }
GAEngine >> selection: aSelection [
	"Set the selection method to be used to create a new population"
	
	selection := aSelection.
	aSelection engine: self.
]

{ #category : #testing }
GAEngine >> shouldTerminate [
	logs ifEmpty: [ ^ false ].
	^ terminationBlock value
]

{ #category : #visualization }
GAEngine >> viewFitness [
	"Visualize the evolution of the population"

	| chart legend plotBestFitness plotWorstFitness plotAverageFitness |
	chart := RSCompositeChart new.
	legend := RSLegend new.
	legend layout vertical.
	legend title: 'Fitness evolution'.

	plotBestFitness := RSLinePlot new
		                   rawData: self logs
		                   x: #generationNumber
		                   y: #bestFitness.
	plotBestFitness color: Color blue.
	chart add: plotBestFitness.

	plotWorstFitness := RSLinePlot new
		                    rawData: self logs
		                    x: #generationNumber
		                    y: #worstFitness.
	plotWorstFitness color: Color red.
	chart add: plotWorstFitness.

	plotAverageFitness := RSLinePlot new
		                      rawData: self logs
		                      x: #generationNumber
		                      y: #averageFitness.
	plotAverageFitness color: Color green.
	chart add: plotAverageFitness.

	chart build.
	
	legend := RSLegend new.
	legend layout vertical.
	legend title: 'Fitness evolution'.
	legend container: chart canvas.
	legend text: 'Best fitness' withBoxColor: Color blue.
	legend text: 'Worst fitness' withBoxColor: Color red.
	legend text: 'Average fitness' withBoxColor: Color green.	
	legend build.
	
	^ chart canvas
]
