"
I represent a matrix of columns and rows.

Responsibility: I create and manipulate matrices. 
Collaborators: .

Public API and Key Messages:

"
Class {
	#name : #Matrix,
	#superclass : #Object,
	#instVars : [
		'nbRows',
		'nbColumns',
		'array'
	],
	#category : #Matrix
}

{ #category : #'instance creation' }
Matrix class >> newFromArrays: arrays [
	"Create a matrix from an array containing the structured
	values of the matrix. Example of matrix creations: 
	
	Matrix newFromArrays: #(#(1 2 3) #(4 5 6))
	Matrix newFromArrays: #(#(1 2 3))
	Matrix newFromArrays: #( #(1) #(2) #(3) )
	
	"
	
	^ self basicNew
			initializeRows: arrays size columns: arrays first size;
			fromContents: (arrays flatCollect: #yourself);
			yourself 
]

{ #category : #'instance creation' }
Matrix class >> newRows: numRows columns: numColumns [
	"Create a matrix with a given shape"
	
	^ self basicNew
			initializeRows: numRows columns: numColumns;
			yourself
]

{ #category : #initialization }
Matrix >> array [ 
	"The array containing maxtrix values"
	
	^ array
]

{ #category : #initialization }
Matrix >> asArray [

	"return a linear array of the matrix values"
	
	^ array asArray
]

{ #category : #initialization }
Matrix >> fromContents: content [
	"Initialize the matrix with a linear content"
	
	self assert: [ content size = (nbColumns * nbRows) ] description: 'size mismatch'.
	content doWithIndex: [ :v :i | array at: i put: v ].
]

{ #category : #initialization }
Matrix >> getHandle [
	"Return the handle of the foreign object.
	This allows the array to bw accessed from C"
	
	^ array getHandle
	
]

{ #category : #initialization }
Matrix >> initializeHandle: aHandle rows: numRows columns: numColumns [
	"Initialize the matrix"
	self initialize.
	
	nbRows := numRows.
	nbColumns := numColumns.
	array := self newArrayFromHandle: aHandle.
]

{ #category : #initialization }
Matrix >> initializeRows: numRows columns: numColumns [
	self initialize.
	
	nbRows := numRows.
	nbColumns := numColumns.
	array := self newArray.
]

{ #category : #initialization }
Matrix >> nbColumns [
	"Number of columns defined in the matrix"
	
	^ nbColumns
]

{ #category : #initialization }
Matrix >> nbRows [
	"Number of rows defined in the matrix"
	
	^ nbRows
]

{ #category : #initialization }
Matrix >> newArray [
	"Create an array used to contains the store the matrix content"
	
	^ FFIExternalArray 
			newType: 'double' 
			size: nbColumns * nbRows
]

{ #category : #initialization }
Matrix >> newArrayFromHandle: aHandle [
	"Create an external array using a handle"
	
	^ FFIExternalArray
			fromHandle: aHandle
			type: 'double' size: nbColumns * nbRows
]

{ #category : #initialization }
Matrix >> size [
	"The number of values contained in the matrix"
	
	^ nbColumns * nbRows
]
