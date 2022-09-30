function smootherstep(a, b, amt){

	if amt <= 0 {return a}

	else if amt >=1 {return b}

	else{

		var amt_smoother = 6*power(amt, 5) - 15*power(amt, 4) + 10*power(amt, 3);
		
		return a + ((b-a) * amt_smoother);
		
	}
}