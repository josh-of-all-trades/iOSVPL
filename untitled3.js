function evaluate(str) {
	return square(str);
}

function square(str){
	result = parseInt(str);
	if (result == 0) return 2
	result *= result;
	return result.toString(); 
}