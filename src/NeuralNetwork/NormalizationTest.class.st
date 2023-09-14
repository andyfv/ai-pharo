Class {
	#name : #NormalizationTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #tests }
NormalizationTest >> testEmptyError [

	self
		should: [ Normalization new normalizeData: #( ) ]
		raise: Error
]

{ #category : #tests }
NormalizationTest >> testError [
	self should: [ Normalization new normalizeData: #( #(10 5 1) ) ]
			raise: Error.
			
]

{ #category : #tests }
NormalizationTest >> testSimpleNormalization [
| input expectedNormalizedIput |
input := #( #(10 5 1) #(2 6 0) ).
expectedNormalizedIput := Normalization new normalizeData: input.
self assert: expectedNormalizedIput equals: #(#(1.0 0.0 1) #(0.0 1.0 0) ).
]
