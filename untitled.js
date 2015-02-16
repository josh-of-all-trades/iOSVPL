function evaluate(str) {
	return incr(str);
}

function incr(str) {
	result = parseInt(str);
	result++;
	return result.toString(); 
}