Class {
	#name : #MatrixTest,
	#superclass : #TestCase,
	#category : #Matrix
}

{ #category : #tests }
MatrixTest >> testAddition1 [
	| m1 m2 | 
	
	m1 := Matrix newFromArrays: #( #(1 2 3) #(4 5 6) ).
	m2 := Matrix newFromArrays: #( #(4 5 6) #(1 2 3) ).	
	
	self assert: (m1 + m2) asStructuredArray equals: #( #(5.0 7.0 9.0) #(5.0 7.0 9.0) ).
]

{ #category : #tests }
MatrixTest >> testAddition2 [
	| m | 
	
	m := Matrix newFromArrays: #( #(1 2 3) #(4 5 6) ).
	
	self assert: (m + m) asStructuredArray equals: #( #(2.0 4.0 6.0) #(8.0 10.0 12.0) ).
]

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
MatrixTest >> testCollect [
	| m expectedMatrix | 
	
	m := Matrix newFromArrays: #( #(1 2 3) #(4 5 6) ).
	expectedMatrix := Matrix newFromArrays: #( #(2 3 4) #(5 6 7) ).
	
	self assert: (m collect: [ :v | v + 1 ] ) asStructuredArray 
			equals: expectedMatrix asStructuredArray. 
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

{ #category : #tests }
MatrixTest >> testPrinting [
	| m | 
	
	m := Matrix newFromArrays: #( #(1 2 3) #(4 5 6) ).
	
	self assert: (m + m) asString equals: ('(2.0 4.0 6.0', String cr, '8.0 10.0 12.0)' ).
]

{ #category : #tests }
MatrixTest >> testStretching [
	| m | 
	
	m := (Matrix newFromVector: #(1 2 3 4)) stretchToColumns: 5.
	
	self assert: m nbRows equals: 4.
	self assert: m nbColumns equals: 5.
	self assert: (m atRow: 1) equals: #(1 1 1 1 1).
	self assert: (m atRow: 3) equals: #(3 3 3 3 3).
]

{ #category : #tests }
MatrixTest >> testSumHorizontal [
	| m expectedResult | 
	
	m := Matrix newFromArrays: #( #(1.0 2.0) #(3.0 4.0) #(5.0 6.0) ).
	expectedResult := Matrix newFromArrays: #( #(3.0) #(7.0) #(11.0) ).	
	
	self assert: (m sumHorizontal asStructuredArray) equals: expectedResult asStructuredArray.
]

{ #category : #tests }
MatrixTest >> testVectorCreation [
	| v |
	v := Matrix newFromVector: #(1 2 3).
	self assert: v nbColumns equals: 1.
	self assert: v nbRows equals: 3.
	self assert: v asStructuredArray equals: #( #(1) #(2) #(3) ).
]