function evaluate(str) {
	result = parseInt(str);
	if (result == 0) return 1
	result *= result;
	return result.toString(); 
}