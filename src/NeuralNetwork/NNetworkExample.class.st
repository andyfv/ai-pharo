"
This class hold example methods that uses the NNetwork class and it's collaborator classes 
"
Class {
	#name : #NNetworkExample,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #examples }
NNetworkExample >> exampleIrisDataset [
"Prepare the Iris Dataset and train a network on it.
Run the example below to see the results: "

"NNetworkExample new exampleIrisDataset "

| irisCSV lines tLines irisData n |

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

"Training a Network with the Iris Dataset"
n := NNetwork new.
n configure: 4 hidden: 6 nbOfOutputs: 3.
n train: irisData nbEpochs: 1000.
^ n
]
