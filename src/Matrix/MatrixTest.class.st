Class {
	#name : #MatrixTest,
	#superclass : #TestCase,
	#category : #Matrix
}

{ #category : #tests }
MatrixTest >> testAt [
	| m |
	m := Matrix newFromArrays: #( #(1 2) #(3 4) ).
	self assert: (m at: 1 @ 1) equals: 1.
	self assert: (m at: 1 @ 2) equals: 2.
	self assert: (m at: 2 @ 1) equals: 3.
	self assert: (m at: 2 @ 2) equals: 4.
]

{ #category : #tests }
MatrixTest >> testAtPut [
	| m |
	m := Matrix newFromArrays: #( #(1 2) #(3 4) ).
	m at: 2 @ 1 put: 10.0.
	
	self assert: (m at: 2 @ 1) equals: 10.0.
	self assert: m asStructuredArray equals: #( #(1 2) #(10 4) )
]

{ #category : #tests }
MatrixTest >> testCreation [
	| m |
	m := Matrix newFromArrays: #( #(1 2) #(3 4) ).
	self assert: m asArray equals: #(1.0 2.0 3.0 4.0).
	
]

{ #category : #tests }
MatrixTest >> testMax [
	| m | 
	
	m := Matrix newFromArrays: #( #(1 2) #(3 4) ).
	
	self assert: m max equals: 4.
]
