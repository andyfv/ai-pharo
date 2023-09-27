Class {
	#name : #NMExamples,
	#superclass : #Object,
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #examples }
NMExamples >> exampleLabeledDataset [

	"Inspect the script below to see the results:
	
	NMExamples new exampleLabeledDataset 
	
	"
	| xor n |
	xor := #( #(0 0 0)
					 #(0 1 1)
					#(1 0 1)
					#(1 1 0)
					).
					
	n := NMNetwork new.
	n configure: 2 hidden: 3 nbOfOutputs: 2.
	n train: xor nbEpochs: 5000.
	^ n predict: (Matrix newFromVector: #(1 0)).
]

{ #category : #examples }
NMExamples >> exampleViewLearningCurve [
	"Inspect the script below to see the results:
	
	NMExamples new exampleViewLearningCurve 
	
	"
	| xor n |
	xor := #(	#(0 0 0)
					#(0 1 1)
					#(1 0 1)
					#(1 1 0)
					).
					
	n := NMNetwork new.
	n configure: 2 hidden: 3 nbOfOutputs: 2.
	n train: xor nbEpochs: 5000.
	^ n 
]
