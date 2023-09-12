Class {
	#name : #NNetworkTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #tests }
NNetworkTest >> testBasic [
| n |
n := NNetwork new.
n configure: 2 hidden: 2 nbOfOutputs: 1.

self assert: ( (n feed: #(1 3)) anyOne closeTo: 0.6745388083637036 precision: 0.0000000001).
self assert: n numberOfOutputs equals: 1.
]

{ #category : #tests }
NNetworkTest >> testLabelWhenNotRun [
"Test that the visualization correctly prints on the canvas
that the network has not runned if the NNetwork>>errors variable is nil"
| n shapes |
n := NNetwork new.
n configure: 2 hidden: 3 nbOfOutputs: 2.

shapes := n viewLearningCurve shapes.
	
self assert: (shapes size) equals: 1.
self assert: ((shapes at: 1) class) equals: RSLabel.
self assert: ((shapes at: 1) text) equals: 'Should first run the network'. 

]

{ #category : #tests }
NNetworkTest >> testVisualizeErrorsAndPrecision [

"self new testVisualizeErrorsAndPrecision "

| n data |
n := NNetwork new.
n configure: 2 hidden: 3 nbOfOutputs: 2.

data := 
	{ #(0 0 0)
	. #(0 1 1)
	. #(1 0 1)
	. #(1 1 0) 
	}.
	
n train: data nbEpochs: 10000. 
n viewLearningCurve.

]

{ #category : #tests }
NNetworkTest >> testXOR [ 
| n data |
n := NNetwork new.
n configure: 2 hidden: 3 nbOfOutputs: 2.

data := 
	{ #(0 0 0)
	. #(0 1 1)
	. #(1 0 1)
	. #(1 1 0) 
	}.
	
n train: data nbEpochs: 20000. 

self assert: (n predict: #(0 0)) equals: 0.
self assert: (n predict: #(0 1)) equals: 1.
self assert: (n predict: #(1 0)) equals: 1.
self assert: (n predict: #(1 1)) equals: 0.
]
