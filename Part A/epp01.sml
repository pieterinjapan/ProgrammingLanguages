(* Author  : Pieter van Wyk
 * Created : 2020-03-27
 * Updated : 2020-04-13
 *
 * Solutions to the extra practice problems of week 2 of part A 
 *)
		
(* Problem 1. 
 * a function that takes a list of numbers and 
 * adds them with alternating sign 
 *)
 
fun alternate (ls: int list) : int =
    if null ls then 0
    else (hd ls) - alternate (tl ls)
	
(* Problem 2. 
 * a function that takes a non-empty list of numbers, 
 * and returns a pair of the minimum and maximum of 
 * the numbers in the list 
 *)
	  
(* helper function : generic function for defining maxInLst and minInLst *)	
fun predInLst (ls : int list) (p : int -> int -> bool) : int =
    let fun predInLst' (v : int)  (ls : int list) (p : int -> int -> bool) : int =	  
	    if null ls then v
	    else if (p (hd ls) v) then predInLst' v (tl ls) p
	    else predInLst' (hd ls) (tl ls) p
    in predInLst' (hd ls) (tl ls) p	
    end
	  	
(* main function *)	
fun min_max (ls: int list) : int*int =
    if length ls = 1 then (hd ls, hd ls)
    else let val minInLst = (fn xs => (predInLst ls (fn x => fn y => x >= y)))
	     val maxInLst = (fn xs => (predInLst ls (fn x => fn y => x <= y)))
	 in (minInLst ls, maxInLst ls)	
         end
		 
(* Problem 3. 
 * a function that takes a list of numbers and returns a list 
 * of the partial sums of those numbers.
 *)

(* helper function : computes the sum of a list of integers *)
fun sumLst (ls : int list) : int =
    if null ls then 0
    else (hd ls) + sumLst (tl ls)

(* helper function : given list of lists of integers, computes list of sums *)
fun sumLstLst (lss:(int list) list) : int list =
    if null lss then []
    else (sumLst (hd lss))::(sumLstLst (tl lss)) 
	
(* helper function : append two lists *)	
fun append (xs : 'a list) (ys : 'a list) : 'a list =
    if null xs then ys
    else (hd xs)::(append (tl xs) ys)
	
(* helper function : chop off last element from list *)
fun init (xs : 'a list)	: 'a list =
    if null xs then []
    else if length xs = 1 then []
    else (hd xs)::init (tl xs)

(* helper function : breaks list into partial lists *)
fun partLst (xs : 'a list) : ('a list) list =
    if null xs then []
    else if null (tl xs) then [[hd xs]]
    else append (partLst (init xs)) [xs]
	
(* main function *)	
fun cumsum (xs : int list) : int list = 
    sumLstLst (partLst xs)

(* Problem 4. 
 * a function that given a string option SOME name returns the string 
 * "Hello there, ...!" where the dots would be replaced by name. Note that 
 * the name is given as an option, so if it is NONE then replace the dots with "you".
 *)	

fun greeting (str_op : string option) : string =
    let val ht = "Hello there, "
	in if isSome str_op then ht ^ (valOf str_op) ^ "!"
	   else ht ^ "you!"
	end
	
(* Problem 5. 
 * a function that given a list of integers and another list of nonnegative 
 * integers, repeats the integers in the first list according to the numbers 
 * indicated by the second list.
 *)		

fun repeat (ps : (int list)*(int list)) : int list =
    let val xs = #1 ps
	val ys = #2 ps
	fun repeatInt (n : int) (m : int) : int list =
            if n = 0 then []
	    else m::(repeatInt (n-1) m)
    in if null xs then []
       else if null ys then []
       else append (repeatInt (hd ys) (hd xs)) (repeat (tl xs,tl ys))
    end   

(* Problem 6. 
 * a function that given two "optional" integers, adds them if they are both 
 * present (returning SOME of their sum), or returns NONE if at least one of 
 * the two arguments is NONE.
 *)		
 
fun addOpt (x_opt : int option) (y_opt : int option) : int option =
    if (isSome x_opt) andalso (isSome y_opt) 
    then let val x = valOf x_opt 
	     val y = valOf y_opt 
         in SOME (x + y)
         end
    else NONE	 
	
 (* Problem 7. 
 * a function that given a list of "optional" integers, adds those integers that 
 * are there (i.e. adds all the SOME i). If the list does not contain any SOME i 
 * in it, the function should return NONE.
 *)	
 
fun addAllOpt (x_opt_s : int option list) : int option =
    if null x_opt_s then NONE 
    else let fun addOpt' (x_opt : int option) (y_opt : int option) : int option =
                 if (isSome x_opt) andalso (isSome y_opt) 
                 then SOME (valOf x_opt + valOf y_opt)
                 else if isSome x_opt then x_opt
                 else if isSome y_opt then y_opt
                 else NONE
	 in addOpt' (hd x_opt_s) (addAllOpt (tl x_opt_s)) 
	 end

(* Problem 8. 
 * a function that given a list of booleans returns true if there is at least one of 
 * them that is true, otherwise returns false. (If the list is empty it should return false) 
 *)	
 
fun any (bs : bool list) : bool =
    if null bs then false
    else if (hd bs) then true
    else any (tl bs) 
	
(* Problem 9. 
 * a function that given a list of booleans returns true if all of them are  
 * true, otherwise returns false. (If the list is empty it should return true) 
 *)		
 
 fun all (bs : bool list) : bool =
     if null bs then true
     else if (hd bs = false) then false
     else all (tl bs) 	
 
(* Problem 10. 
 * a function that given two lists of integers creates consecutive pairs, 
 * and stops when one of the lists is empty.
 *)	
 
fun zip (xs : 'a list) (ys : 'b list) : ('a*'b) list =
    if null xs then []
    else if null ys then []
    else (hd xs, hd ys) :: (zip (tl xs) (tl ys))	

(* Problem 11. 
 * Write a version zipRecycle of zip, where when one list is empty it starts 
 * recycling from its start until the other list completes. 
 *)
 
(* helper function : zip with recicle assuming the right list is smaller *)
fun zipRecycleR (xs : 'a list) (ys : 'b list) : ('a*'b) list =
    let fun zipRecycleR' (r_lst : 'a list ) (xs : 'a list) (ys : 'b list) : ('a*'b) list =
            if null ys then []
            else let val xs' = if null xs then r_lst 
	                       else xs
                 in (hd xs', hd ys) :: ( zipRecycleR' r_lst (tl xs') (tl ys) )	
		 end
    in zipRecycleR' xs xs ys
    end

(* helper function : zip with recicle assuming the left list is smaller *)
fun zipRecycleL (xs : 'a list) (ys : 'b list) : ('a*'b) list =
    let fun zipRecycleL' (l_lst : 'b list ) (xs : 'a list) (ys : 'b list) : ('a*'b) list =
            if null xs then []
            else let val ys' = if null ys then l_lst 
	                       else ys
                 in (hd xs, hd ys') :: ( zipRecycleL' l_lst (tl xs) (tl ys') )	
		 end
    in zipRecycleL' ys xs ys
    end

(* main function *)
fun zipRecycle (xs : 'a list) (ys : 'b list) : ('a*'b) list =
    if length xs <= length ys 
    then zipRecycleR xs ys
    else zipRecycleL xs ys	


(* Problem 12. 
 * Write a version zipOpt of zip. This version should return SOME of a list 
 * when the original lists have the same length, and NONE if they do not. 
 *)
 
fun zipOpt (xs : 'a list) (ys : 'b list) : ('a*'b) list option =
    if length xs <> length ys 
    then NONE
    else let val zip_ls = zip xs ys
         in SOME zip_ls 
         end 

(* Problem 13. 
 * a function that takes a list of pairs (s,i) and also a string s2 to look up. 
 * It then goes through the list of pairs looking for the string s2 in the first 
 * component. If it finds a match with corresponding number i, then it returns SOME i.
 * If it does not, it returns NONE.
 *)
 
 fun lookup (p_ls : (string*int) list) (st : string) : int option = 
     if null p_ls then NONE 
     else let val p = hd p_ls
	      val st1 = #1 p
              val idx = #2 p			  
	  in if st = st1 then SOME idx
	     else lookup (tl p_ls) st
          end
 
(* Problem 14. 
 * a function that, given a list of integers creates two lists of integers, one containing 
 * the non-negative entries, the other containing the negative entries. Relative order must 
 * be preserved: All non-negative entries must appear in the same order in which they were 
 * on the original list, and similarly for the negative entries.
 *) 

fun splitup (xs : int list) : int list * int list = 
    let fun splitup' (xs : int list) (pos_ls : int list) (neg_ls : int list) : int list * int list =
            if null xs then (pos_ls,neg_ls)
	    else let val h_xs = hd xs
                     val t_xs = tl xs	
	         in if h_xs >= 0
	            then let val pos_ls' = append pos_ls [h_xs]
	                 in splitup' t_xs pos_ls' neg_ls
		         end
	            else let val neg_ls' = append neg_ls [h_xs]
                         in splitup' t_xs pos_ls neg_ls'	
		         end 
		 end	
    in splitup' xs [] [] 
    end

(* Problem 15.
 * Write a version of the previous function that takes an extra "threshold" parameter, and uses that 
 * instead of 0 as the separating point for the two resulting lists.
 *)

fun splitAt (xs : int list) (n : int) : int list * int list = 
    let fun splitAt' (xs : int list) (pos_ls : int list) (neg_ls : int list) : int list * int list =
            if null xs then (pos_ls,neg_ls)
	    else let val h_xs = hd xs
                     val t_xs = tl xs	
	             in if h_xs >= n
	                then let val pos_ls' = append pos_ls [h_xs]
	                     in splitAt' t_xs pos_ls' neg_ls
		             end
	                else let val neg_ls' = append neg_ls [h_xs]
                             in splitAt' t_xs pos_ls neg_ls'	
		             end 
		     end	
    in splitAt' xs [] [] 
    end

(* Problem 16.
 * a function that, that given a list of integers determines whether 
 * the list is sorted in increasing order.
 *)

fun isSorted (xs : int list) : bool =
    if null xs then true 
    else let val t_xs = tl xs 
             val h_xs = hd xs	
	 in if null t_xs then true 
            else (h_xs <= (hd t_xs)) andalso (isSorted t_xs) 
         end	

(* Problem 17.
 * a function that, given a list of integers, determines whether the 
 * list is sorted in either increasing or decreasing order. 
 *)

fun isAnySorted (xs : int list) : bool =
    if null xs then true
    else let val t_xs = tl xs
             fun isSorted' (p : int -> int -> bool) (ys : int list) : bool =
	         if null ys then true 
	         else let val t_ys = tl ys 
                          val h_ys = hd ys	
	              in if null t_ys then true 
                         else (p h_ys (hd t_ys)) andalso (isSorted' p t_ys) 
                      end	
	 in if null t_xs then true
	       else if (hd xs) <= (hd t_xs) 
	       then isSorted' (fn x => fn y => x <= y) xs
	       else isSorted' (fn x => fn y => x >  y) xs
         end

(* Problem 18.
 * a function that, that takes two lists of integers that are each sorted from 
 * smallest to largest, and merges them into one sorted list. 
 *)

fun sortedMerge (l_ls : int list) (r_ls : int list) : int list =
    if null l_ls then r_ls
    else if null r_ls then l_ls
    else let val h_r = hd r_ls
             val h_l = hd l_ls	 
         in if h_l <= h_r 
	    then h_l::(sortedMerge (tl l_ls) r_ls)
	    else h_r::(sortedMerge l_ls (tl r_ls))
	 end

(* Problem 19.
 * Write a sorting function that works as follows: Takes the first element out, and uses it as the 
 * "threshold" for splitAt. It then recursively sorts the two lists produced by splitAt. Finally 
 * it brings the two lists together. (Don't forget that element you took out, it needs to get back in at some point). 
 *)

fun qsort (xs : int list) : int list = 
    if isSorted xs then xs
    else let val h_xs = hd xs
	     val p_ls = splitAt (tl xs) h_xs
             val small_ls = #2 p_ls	
	     val large_ls = #1 p_ls
	 in append (qsort small_ls) (h_xs::(qsort large_ls))
         end
	 
(* Problem 20.
 * Write a function that takes a list of integers and produces two 
 * lists by alternating elements between the two lists.  
 *)	
 
fun divide (ls: int list) : int list * int list =
    if null ls then ([],[])
    else let val h_ls = hd ls 
             val t_ls = tl ls
         in if null t_ls then ([h_ls],[])
	    else let fun cons_pair ((x,y) : int * int) ((xs,ys) : int list * int list) : int list * int list =
                         (x::xs, y::ys)
	         in cons_pair (h_ls,hd t_ls) (divide (tl t_ls))
		 end
         end		 

(* Problem 21.
 * Write another sorting function that works as follows: Given the initial list of integers, 
 * splits it in two lists using divide, then recursively sorts those two lists, then merges 
 * them together with sortedMerge.
*)

fun not_so_quick_sort (ls: int list) : int list =
    if length ls <= 1 then ls
    else let val div_ls = divide ls
	     val fst_ls = not_so_quick_sort (#1 div_ls) 
	     val snd_ls = not_so_quick_sort (#2 div_ls)
	 in sortedMerge fst_ls snd_ls
         end

(* Problem 22.
 * Write a function that given two numbers k and n it attempts to evenly divide k into 
 * n as many times as possible, and returns a pair (d,n2) where is the number of times 
 * while n2 is the resulting n after all those divisions.
 *)		 
 
(* helper : for testing fullDivide *)
fun pow (n : int, k : int) : int =
    if k = 0 then 1
    else n * pow(n, k - 1) 

fun unDivide (k : int) (d : int, n : int) : int =
    pow(k,d)*n     

fun fullDivide (k : int, n : int) : int * int =
    let fun fullDivide' (d : int) (k : int) (n : int) : int * int =
            if n mod k = 0
	    then fullDivide' (d + 1) k (n div k)
	    else (d, n)
    in fullDivide' 0 k n
    end
 
(* Problem 23.
 * write a function that given a number n returns a list of pairs (d,k) 
 * where d is a prime number dividing n and k is the number of times it fits. 
 * The pairs should be in increasing order of prime factor, and the process 
 * should stop when the divisor considered surpasses the square root of n.
 *)	
  
fun factorize (n : int) : (int * int) list =
    if n < 2 then []
    else let fun factorize' (k : int) (m : int) : (int * int) list =
                 case (m = 1) 
	         of true  => []
	         |  false => case (m mod k = 0) 
                             of true  => let val (d,m') = fullDivide (k,m)
	                                 in if (m < k*k) then [(k,d)]
					    else (k,d) :: (factorize' (k + 2) m')
                                         end	
                             | false => factorize' (k + 2) m  	
	 in if (n mod 2 = 0) then let val (d,n') = fullDivide (2,n)
	                          in (2,d) :: (factorize' 3 n')
                                  end							   
            else factorize' 3 n		 
	 end 

(* Problem 24.
 * Write a function multiply that given a factorization of a number n as 
 * described in the previous problem computes back the number n. 
 * So this should do the opposite of factorize.
 *)	
 
fun multiply (factors : (int * int) list) : int = 
    if null factors then 1
    else let val h_ls = hd factors
	 in pow (#1 h_ls, #2 h_ls) * (multiply (tl factors))
         end
		 
(* Problem 25.
 * Write a function that given a factorization list result from factorize creates 
 * a list all of possible products produced from using some or all of those prime 
 * factors no more than the number of times they are available. This should end up 
 * being a list of all the divisors of the number n that gave rise to the list.
 *)	

(* helper functions *)
fun last (xs : 'a list) : 'a =
    if length xs = 1 then hd xs
    else last (tl xs)

fun init (xs : 'a list) : 'a list =
    if length xs = 1 then []
    else (hd xs)::(init (tl xs)) 

fun multiples (n : int, k : int) : int list =
    if k = 0 then [1]
    else (multiples (n, k - 1)) @ [pow(n,k)]
 
fun multiplesLst (ps : (int * int) list) : (int list) list =
    if null ps then []
    else (multiples (hd ps))::(multiplesLst (tl ps)) 
 
fun scaleLst (xs : int list) (y : int) : int list =
    case xs 
    of []      => []
    | (x::xs') => (x*y)::(scaleLst xs' y)	
	
fun scaleLsts (xs : int list) (ys : int list) : int list =
    case ys 
    of []      => []
    | (y::ys') => (scaleLst xs y) @ (scaleLsts xs ys')	

fun scaleLstLst (xss : (int list) list) : int list =
    if null xss then []
    else if length xss <= 2 then let val xs1   = hd xss
                                     val t_xss = tl xss	
	                         in if null t_xss then xs1
				    else scaleLsts xs1 (hd t_xss)
		                 end
    else scaleLsts (scaleLstLst (init xss)) (last xss)
 
(* main function *) 
fun all_products (factors : (int * int) list) : int list =
    let val factors' = multiplesLst factors
    in qsort (scaleLstLst factors')
    end   
 
(* END *)
