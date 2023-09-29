Class {
	#name : #GACrossoverOperation,
	#superclass : #GAAbstractCrossoverOperaton,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GACrossoverOperation >> pickCutPointFor: partnerA [
	"Simply returns a random number between 1 and the number 
	of genes of the individual provided as an argument"
	^ random nextInteger: partnerA numberOfGenes
]
