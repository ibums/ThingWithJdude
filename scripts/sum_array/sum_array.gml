function sum_array(array, size){
	
	var sum = 0;
	var incremented_number = 0

	while (incremented_number <= size){

		sum += array[incremented_number++];
	}
	return sum;
}