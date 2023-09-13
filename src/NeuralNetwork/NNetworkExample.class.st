"
This class hold example methods that uses the NNetwork class and it's collaborator classes 
"
Class {
	#name : #NNetworkExample,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #examples }
NNetworkExample >> exampleContradictoryData [
"Example of a contradictory data. In effect the error curve cannot get close to 0.
The first example that trains the network to output 0 with input (0 0). The second 
example that trains the network outputs 1 for the same input.

Inspect the script below to see the results

NNetworkExample new exampleContradictoryData 

"


| n data |
n := NNetwork new.
n configure: 2 hidden: 3 nbOfOutputs: 2.

data := 
	{ #(0 0 0)
	. #(0 0 1) 
	}.
	
^ n train: data nbEpochs: 1000.
]

{ #category : #examples }
NNetworkExample >> exampleIrisDataset [
"Prepare the Iris Dataset and train a network on it.
Run the example below to see the results: "

"NNetworkExample new exampleIrisDataset "

| irisData n |

irisData := self getIrisData.

"Training a Network with the Iris Dataset"
n := NNetwork new.
n configure: 4 hidden: 6 nbOfOutputs: 3.
n train: irisData nbEpochs: 1000.
^ n
]

{ #category : #examples }
NNetworkExample >> exampleLearningCurve [
"See the effects of a different learning rate of a neuron
Run the example below to see the results: "

"NNetworkExample new exampleLearningCurve "

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
^ n
]

{ #category : #examples }
NNetworkExample >> exampleLearningRate [
"See the effects of a different learning rate of a neuron
Run the example below to see the results: "

"NNetworkExample new exampleLearningRate "

| chart learningRates colorScale legend |

chart := RSCompositeChart new.
colorScale := NSScale category20.
chart colors: colorScale .
learningRates := #(0.001 0.01 0.1 0.2 0.3).

learningRates doWithIndex: [ :rate :index |
	| learningCurveNeuron plot |
	
	learningCurveNeuron := OrderedCollection new.
	
	0 to: 1000 do: [ :nbOfTrained |
		| neuron result |
		
		neuron := Neuron new.
		neuron weights: #(-1 -1).
		neuron bias: 2.
		neuron learningRate: rate.
		nbOfTrained timesRepeat: 
			[ neuron train: #(0 0) desiredOutput: 0
			. neuron train: #(0 1) desiredOutput: 0
			. neuron train: #(1 0) desiredOutput: 0
			. neuron train: #(1 1) desiredOutput: 1. 
			].
		result := ((neuron feed: #(0 0)) - 0) abs 
						+ 
						((neuron feed: #(0 1)) - 0) abs
						+
						((neuron feed: #(1 0)) - 0) abs
						+
						((neuron feed: #(1 1)) - 1) abs.
		learningCurveNeuron add: result / 4.
		].
	
	plot := RSLinePlot new y: learningCurveNeuron.
	chart add: plot.
	].


chart build.

"Add legend below the chart"
legend := RSLegend new.
legend withFrame.
legend layout vertical.
legend container: chart canvas.
legend title: 'Learning rate effect'.
	
learningRates with: chart plots do: [ :c :p |
	legend 
		text: ('Sigmoid neuron learning rate = ' , c asString) 
		withBoxColor: (chart colorFor: p).
	].

legend build.

^ chart canvas

]

{ #category : #examples }
NNetworkExample >> exampleLearningRateNetwork [
"See the effects of a different learning rate of a network
Run the example below to see the results: "

"NNetworkExample new exampleLearningRateNetwork "

| canvas learningRates irisData |

irisData := self getIrisData.
learningRates := #(0.001 0.01 0.1 0.3).

canvas := RSCanvas new.

learningRates doWithIndex: [ :rate :index |
	| network canvasWithLabel |
	
	"Create and train a network"
	network := NNetwork new.
	network configure: 4 hidden: 6 nbOfOutputs: 3.
	network learningRate: rate.
	network train: irisData nbEpochs: 1000.
	
	"Add label to the learning curve chart with the used learning rate"
	canvasWithLabel := RSCanvas new.
	canvasWithLabel add: (RSLabel new text: 'Learning rate = ' , rate asString).
	canvasWithLabel add: network viewLearningCurve asShape.
	RSVerticalLineLayout new on: canvasWithLabel shapes; gapSize: 10.

	canvas add: canvasWithLabel asShape.
	].

RSGridLayout new on: canvas shapes; gapSize: 30.

canvas @ RSDraggable @ RSCanvasController.

^  canvas

]

{ #category : #examples }
NNetworkExample >> exampleLearningRateNeuron [
"See the effects of a different learning rate of a neuron
Run the example below to see the results: "

"NNetworkExample new exampleLearningRate "

| chart learningRates colorScale legend |

chart := RSCompositeChart new.
colorScale := NSScale category20.
chart colors: colorScale .
learningRates := #(0.001 0.01 0.1 0.2 0.3).

learningRates doWithIndex: [ :rate :index |
	| learningCurveNeuron plot |
	
	learningCurveNeuron := OrderedCollection new.
	
	0 to: 1000 do: [ :nbOfTrained |
		| neuron result |
		
		neuron := Neuron new.
		neuron weights: #(-1 -1).
		neuron bias: 2.
		neuron learningRate: rate.
		nbOfTrained timesRepeat: 
			[ neuron train: #(0 0) desiredOutput: 0
			. neuron train: #(0 1) desiredOutput: 0
			. neuron train: #(1 0) desiredOutput: 0
			. neuron train: #(1 1) desiredOutput: 1. 
			].
		result := ((neuron feed: #(0 0)) - 0) abs 
						+ 
						((neuron feed: #(0 1)) - 0) abs
						+
						((neuron feed: #(1 0)) - 0) abs
						+
						((neuron feed: #(1 1)) - 1) abs.
		learningCurveNeuron add: result / 4.
		].
	
	plot := RSLinePlot new y: learningCurveNeuron.
	chart add: plot.
	].


chart build.

"Add legend below the chart"
legend := RSLegend new.
legend withFrame.
legend layout vertical.
legend container: chart canvas.
legend title: 'Learning rate effect'.
	
learningRates with: chart plots do: [ :c :p |
	legend 
		text: ('Sigmoid neuron learning rate = ' , c asString) 
		withBoxColor: (chart colorFor: p).
	].

legend build.

^ chart canvas

]

{ #category : #'helper methods' }
NNetworkExample >> getIrisData [
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
^ irisData := tLines collect: [ :row |
	| l |
	row last = 'setosa' 			ifTrue: [ l := #( 0 ) ].
	row last = 'versicolor' 	ifTrue: [ l := #( 1 ) ].
	row last = 'virginica' 	ifTrue: [ l := #( 2 ) ].
	row allButLast, l 
	].

]
