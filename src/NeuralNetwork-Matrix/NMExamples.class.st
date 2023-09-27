Class {
	#name : #NMExamples,
	#superclass : #Object,
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #examples }
NMExamples >> exampleIrisData [

	"Inspect the script below to see the results:
	
	NMExamples new exampleIrisData 
	
	"
	| irisDataset n |
	
	irisDataset := self getIrisData.
	
	n:= NMNetwork new.
	n configure: 4 hidden: 6 nbOfOutputs: 3.
	n train: irisDataset nbEpochs: 3000.
	^ n
]

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

{ #category : #examples }
NMExamples >> getIrisData [
"Prepare the Iris Dataset"

| irisCSV lines tLines irisData |

"Get the CSV"
irisCSV := (ZnEasy get: 'https://agileartificialintelligence.github.io/Datasets/iris.csv') contents.

"Get the rows of the dataset"
lines := irisCSV lines.

"Remove the header(first row) from the dataset"
lines := lines allButFirst.

"Transorm each row data from a string to a numerical value, except the last column"
tLines := lines collect: [ :l |
	| subStrings |
	subStrings := l substrings: ','.
	(subStrings allButLast collect: [ :w | w asNumber ]), (Array with: subStrings last) 
	].

"Hot-encode the data by transforming the categorical variable to a numerical value"
irisData := tLines collect: [ :row |
	| l |
	row last = 'setosa' 			ifTrue: [ l := #( 0 ) ].
	row last = 'versicolor' 	ifTrue: [ l := #( 1 ) ].
	row last = 'virginica' 	ifTrue: [ l := #( 2 ) ].
	row allButLast, l 
	].

^ irisData
]
