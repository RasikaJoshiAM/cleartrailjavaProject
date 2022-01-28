package com.example.demo;

public class ServiceResponse implements java.io.Serializable{
private boolean isSuccessful;
private Object result;
public boolean getIsSuccessful() {
	return isSuccessful;
}
public void setIsSuccessful(boolean isSuccessful) {
	this.isSuccessful = isSuccessful;
}
public Object getResult() {
	return result;
}
public void setResult(Object result) {
	this.result = result;
}
}
