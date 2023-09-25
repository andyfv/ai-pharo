"
This class hold example methods that uses the NNetwork class and it's collaborator classes 
"
Class {
	#name : #NNetworkExample,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #examples }
NNetworkExample >> exampleAccuracy [
	"Split a dataset in training and test sets. Then compute the ratio 
of correctly classified results.

Inspect (Cmd - I / Select the script -> Right click -> Inspect it) the script below:

NNetworkExample new exampleAccuracy

"

	| irisData cut cutTraining cutTest trainingData testData n acc |
	irisData := self getIrisData.
	cut := 0.8.

	"Compute the size of the training and test sets. We use 80% of the irisData for training."
	cutTraining := (irisData size * cut) rounded.
	cutTest := (irisData size * (1 - cut)) rounded.

	"Get the training and test sets"
	trainingData := irisData first: cutTraining.
	testData := irisData last: cutTest.


	"Train the network"
	n := NNetwork new.
	n configure: 4 hidden: 6 nbOfOutputs: 3.
	n train: trainingData nbEpochs: 1000.

	"Test the network. First predict the classification of the input. Second select
only the correctly classified results. Third, compute the ratio of correctly classified results"
	acc := (((testData collect: [ :d |
		          (n predict: d allButLast) = d last ]) select: [ :d |
		         d = true ]) size / testData size) asFloat round: 2.

	^ acc
]

{ #category : #examples }
NNetworkExample >> exampleAccuracyWithDifferentCuts [
	"Split a dataset in training and test sets. Then compute the ratio 
of correctly classified results.

Run the example below (Cmd - I / Select the script -> Right click -> Inspect it) to see the results:

NNetworkExample new exampleAccuracyWithDifferentCuts

"

	| shuffledIrisData cuts acc accData |
	shuffledIrisData := self getIrisData shuffleBy: (Random seed: 42).
	accData := OrderedCollection new.
	cuts := #( 0.6 0.5 0.4 ).

	cuts do: [ :cut |
		| cutTraining cutTest trainingData testData n |
		cutTraining := (shuffledIrisData size * cut) rounded.
		cutTest := (shuffledIrisData size * (1 - cut)) rounded.

		"Get the training and test sets"
		trainingData := shuffledIrisData first: cutTraining.
		testData := shuffledIrisData last: cutTest.


		"Train the network"
		n := NNetwork new.
		n configure: 4 hidden: 6 nbOfOutputs: 3.
		n train: trainingData nbEpochs: 1000.

		"Test the network. First predict the classification of the input. Second select
		only the correctly classified results. Third, compute the ratio of correctly classified results"
		acc := (((testData collect: [ :d |
			          (n predict: d allButLast) = d last ]) select: [ :d |
			         d = true ]) size / testData size) asFloat round: 2.

		accData add: cut -> acc ].
	^ accData
]

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

learningRates do: [ :rate |
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

{ #category : #'as yet unclassified' }
NNetworkExample >> exampleMatrices [
	"Run the script below to see the results:
	
	NNetworkExample new exampleMatrices 
	
	"
	| n din h dout r x y w1 w2 learningRate losses plot |
	
	n := 8. 			"Number of examples"
	din := 10.		"Number of input values"
	h := 20.			"Size of the hidden layer"
	dout := 5.		"Number of output values"
			
	r := Random seed: 42.
	
	x := (Matrix newRows: n columns: din) random: r.
	y := (Matrix newRows: n columns: dout) random: r.
	w1 := (Matrix newRows: din columns: h) random: r.
	w2 := (Matrix newRows: h columns: dout) random: r.
	
	learningRate := 1e-6.
	losses := OrderedCollection new.
	
	1500 timesRepeat: [ 
		| hh hrelu ypred loss gradYPred gradW2 gradHRelu gradH gradW1 |
		hh := x +* w1.
		hrelu := hh collect: [ :v | v max: 0 ].
		ypred := hrelu +* w2.
		
		"Compute and print loss"
		loss := ((ypred - y) collect: [ :vv | vv * vv]) sum.
		losses add: loss.
		
		"Backpropagate to compute gradients of w2 and w2 with respect to loss"
		gradYPred := (ypred - y) * 2.0.
		gradW2 := hrelu transposed +* gradYPred.
		gradHRelu := gradYPred +* w2 transposed.
		gradH := gradHRelu collect: [ :v | v max: 0 ].
		gradW1 := x transposed +* gradH.
		
		w1 := w1 - (gradW1 * learningRate).
		w2 := w2 - (gradW2 * learningRate).
		].
	
	plot := RSLinePlot new y: losses.
	plot ylabel: 'Error'.
	plot xlabel: 'Epoch'.
	
	^ plot 
	
]

{ #category : #'helper methods' }
NNetworkExample >> exampleNormalization [
	"Run the script below to see the results: 
	
	NNetworkExample new exampleNormalization
	
	"

	| max min irisData |
	
	max := OrderedCollection new.
	min := OrderedCollection new.
	irisData := self getIrisData.

	1 to: 4 do: [ :i |
		max add: (irisData collect: [ :d | d at: i ]) max.
		min add: (irisData collect: [ :d | d at: i ]) min ].

	^ { max . min }
]

{ #category : #'helper methods' }
NNetworkExample >> exampleNormalizedData [
	"Run the script below to see the results: 
	
	NNetworkExample new exampleNormalizedData
	
	"

	| n data |
	n := NNetwork new.
	n configure: 3 hidden: 8 nbOfOutputs: 8.

	data := { #( 0 0 0 0 )
				. #( 0 0 1 1 )
				. #( 0 1 0 2 )
				. #( 0 1 1 3 )
				. #( 1 0 0 4 )
				. #( 1 0 1 5 )
				. #( 1 1 0 6 )
				. #( 1 1 1 7 ) 
				}.

	n train: data nbEpochs: 10000.
	^ n
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
