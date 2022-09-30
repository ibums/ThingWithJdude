function sum_array(array, size){
	
	var sum = 0;
	var decremented_number = size

	while (--decremented_number >= 0){

		sum += array[decremented_number];
	}
	return sum;
}