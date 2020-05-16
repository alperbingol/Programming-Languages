;Alper Bingol 23661

(define symbol-length
	(lambda (inSym)
		(if (symbol? inSym)
			(string-length (symbol->string inSym))
			0
		)
	)
)



(define sequence?
	(lambda (inSeq)
		(if (list? inSeq)
			(if (not (null? inSeq))
				(if (eq? 1 (symbol-length (car inSeq))) 
					(sequence? (cdr inSeq))
					#f
				)
				#t
			)
			#f
		)	 
	)
)




(define same-sequence?
	(lambda (inSeq1 inSeq2)
		(if (sequence? inSeq1)
			(if (sequence? inSeq2)
				(if (null? inSeq1 )
					(if (null? inSeq2 )
						#t
						#f
					)
					(if (null? inSeq2)
						#f
						(if (eq? (car inSeq1) (car inSeq2) )
							(same-sequence? (cdr inSeq1) (cdr inSeq2))
							#f
						)
					)
				)
				(error "same-sequence?: it has non sequence parameter")
			)
			(error "same-sequence?: it has non sequence parameter")
		)	
	)
)


(define reverse-sequence
	(lambda (inSeq)
		(if (sequence? inSeq)
			(if (null? inSeq)
				'()
				(append (reverse-sequence (cdr inSeq)) (cons (car inSeq) '() ))
			)
			(error "error")
		)			
	)
)




(define palindrome?
	(lambda (inSeq)
		(if (same-sequence? inSeq (reverse-sequence inSeq))
			#t
			#f
		)
	) 
)







(define member?
	(lambda (inSym inSeq)
		(if (and (sequence? inSeq) (symbol? inSym))
			(if (not (null? inSeq))
				(if (eq? inSym (car inSeq))
					#t
					(member? inSym (cdr inSeq)))
				#f)
		(error "error")
		)
	)
)







(define remove-member
	(lambda (inSym inSeq)
		(if (member? inSym inSeq)
			(if (equal? inSym (car inSeq)) 
				(cdr inSeq)
				(cons (car inSeq) (remove-member inSym (cdr inSeq)))
			)
			(error "error")
		)
	)	
)





(define anagram?
	(lambda (inSeq1 inSeq2)
		(if (and (sequence? inSeq1) (sequence? inSeq2))
			(if (not (and (null? inSeq1) (null? inSeq2)))
				(if (member? (car inSeq1) inSeq2)
					(anagram? (remove-member (car inSeq1) inSeq1) (remove-member (car inSeq1) inSeq2))
					#f
				)
				#t
			)	
			(error "error")
		)
	)
)

(define anapoli?
	(lambda (inSeq1 inSeq2)
		(if (palindrome? inSeq2)
			(if (anagram? inSeq1 inSeq2)
				#t
				#f
			)
			#f
		)
	)
)













































