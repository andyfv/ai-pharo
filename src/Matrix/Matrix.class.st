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

{ #category : #operations }
Matrix >> + matrixOrVector [
	"Add either a matrix or a vector to the receiver.
	The argument could either be a matrix of the same size or
	a vector. A new matrix is returned as result."
	
	| m |
	((nbRows = matrixOrVector nbRows) and: [ nbColumns = matrixOrVector nbColumns])
		ifTrue: [ ^ self add: matrixOrVector ].
	matrixOrVector nbColumns ~= 1 ifTrue: [ self error: 'not a n*1 vector' ].
	m := matrixOrVector stretchToColumns: nbColumns.
	^ self + m.
]

{ #category : #operations }
Matrix >> add: aMatrix [
	"Add two matrices, the reciever and the argument, and produces
	a new matrix"
	
	| result resultArray |
	
	nbColumns = aMatrix nbColumns 
		ifFalse: [ self error: 'dimensions do not conform' ].
	nbRows = aMatrix nbRows
		ifFalse: [ self error: 'dimensions do not conform' ].
	
	resultArray := ByteArray new: (nbRows * aMatrix nbColumns * 8).
	
	self assert: [ nbRows * nbColumns = array size ].
	self assert: [ aMatrix nbRows * aMatrix nbColumns = aMatrix size ].
	self assert: [ nbRows * aMatrix nbColumns * 8 = resultArray size ].
	self add: self getHandle 
			with: nbRows 
			with: nbColumns 
			with: aMatrix getHandle
			in: resultArray.
	result := Matrix newHandle: resultArray rows: nbRows columns: nbColumns.
	^ result
]

{ #category : #operations }
Matrix >> add: m1 with: nb_rows with: nb_columns with: m2 in: res [
	^ self 
			ffiCall: #( void add( double *m1
											 , int nb_rows
											 , int nb_columns 
											 , double *m2
											 , double *res) )
			module: 'libmatrix.so'
]

{ #category : #accessing }
Matrix >> array [ 
	"The array containing maxtrix values"
	
	^ array
]

{ #category : #accessing }
Matrix >> asArray [

	"return a linear array of the matrix values"
	
	^ array asArray
]

{ #category : #accessing }
Matrix >> asStructuredArray [
	"Return a structured arrat that describes the matrix"
	
	^ (1 to: nbRows) collect: [ :i | self atRow: i ] as: Array.
]

{ #category : #accessing }
Matrix >> at: aPoint [
	"Access an element of the matrix"
	
	^ array at: ((aPoint x - 1) * nbColumns + (aPoint y - 1)) + 1
]

{ #category : #accessing }
Matrix >> at: aPoint put: aNumber [
	"Modify an element of the matrix"
	
	^ array at: ((aPoint x - 1) * nbColumns + (aPoint y - 1)) + 1
				put: aNumber asFloat
]

{ #category : #accessing }
Matrix >> atRow: rowNumber [
	"Return a particular row"
	
	(rowNumber between: 1 and: rowNumber)
		ifFalse: [ self error: 'index out of range' ].
		^ (1 to: nbColumns) collect: [ :x | self at: rowNumber @ x ].
]

{ #category : #initialization }
Matrix >> fromContents: content [
	"Initialize the matrix with a linear content"
	
	self assert: [ content size = (nbColumns * nbRows) ] description: 'size mismatch'.
	content doWithIndex: [ :v :i | array at: i put: v ].
]

{ #category : #accessing }
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

{ #category : #accessing }
Matrix >> max [
	"Return the maximum value of the matrix"
	
	^ self asArray max
]

{ #category : #accessing }
Matrix >> nbColumns [
	"Number of columns defined in the matrix"
	
	^ nbColumns
]

{ #category : #accessing }
Matrix >> nbRows [
	"Number of rows defined in the matrix"
	
	^ nbRows
]

{ #category : #creation }
Matrix >> newArray [
	"Create an array used to contains the store the matrix content"
	
	^ FFIExternalArray 
			newType: 'double' 
			size: nbColumns * nbRows
]

{ #category : #creation }
Matrix >> newArrayFromHandle: aHandle [
	"Create an external array using a handle"
	
	^ FFIExternalArray
			fromHandle: aHandle
			type: 'double' size: nbColumns * nbRows
]

{ #category : #accessing }
Matrix >> size [
	"The number of values contained in the matrix"
	
	^ nbColumns * nbRows
]

{ #category : #operations }
Matrix >> sumHorizontal [
	"Horizontal summing"
	
	| result sum |
	
	result := Matrix newRows: nbRows columns: 1.
	1 to: nbRows do: [ :y |
		sum := 0.
		1 to: nbColumns do: [ :x |
			sum := sum + (self at: y @ x) ].
		result at: y @ 1 put: sum 
		].
	^ result 
]
