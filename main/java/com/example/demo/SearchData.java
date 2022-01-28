package com.example.demo;

import java.util.Date;

public class SearchData implements java.io.Serializable {
private Date fromDate;
private Date toDate;
private String token;
private long fromSize;
private long toSize;
private static final long serialVersionUID = 4L; 
public Date getFromDate() {
	return fromDate;
}
public void setFromDate(Date fromDate) {
	this.fromDate = fromDate;
}
public Date getToDate() {
	return toDate;
}
public void setToDate(Date toDate) {
	this.toDate = toDate;
}
public String getToken() {
	return token;
}
public void setToken(String token) {
	this.token = token;
}
public long getFromSize() {
	return fromSize;
}
public void setFromSize(long fromSize) {
	this.fromSize = fromSize;
}
public long getToSize() {
	return toSize;
}
public void setToSize(long toSize) {
	this.toSize = toSize;
}
}
