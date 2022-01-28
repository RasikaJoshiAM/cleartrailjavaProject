package com.example.demo;

public class Summary {
private int numberOfFolders;
private int numberOfFiles;
private long numberOfTokens;
private int numberOfEnglishTokens;
private int numberOfHindiTokens;
private int numberOfArabicTokens;
private int maxFrequency;
private String tokenWithMaxFrequency;
private int minFrequency;
private String tokenWithMinFrequency;
public int getMaxFrequency() {
	return maxFrequency;
}
public void setMaxFrequency(int maxFrequency) {
	this.maxFrequency = maxFrequency;
}
public String getTokenWithMaxFrequency() {
	return tokenWithMaxFrequency;
}
public void setTokenWithMaxFrequency(String tokenWithMaxFrequency) {
	this.tokenWithMaxFrequency = tokenWithMaxFrequency;
}
public int getMinFrequency() {
	return minFrequency;
}
public void setMinFrequency(int minFrequency) {
	this.minFrequency = minFrequency;
}
public String getTokenWithMinFrequency() {
	return tokenWithMinFrequency;
}
public void setTokenWithMinFrequency(String tokenWithMinFrequency) {
	this.tokenWithMinFrequency = tokenWithMinFrequency;
}

public int getNumberOfFolders() {
	return numberOfFolders;
}
public void setNumberOfFolders(int numberOfFolders) {
	this.numberOfFolders = numberOfFolders;
}
public int getNumberOfFiles() {
	return numberOfFiles;
}
public void setNumberOfFiles(int numberOfFiles) {
	this.numberOfFiles = numberOfFiles;
}
public long getNumberOfTokens() {
	return numberOfTokens;
}
public void setNumberOfTokens(long numberOfTokens) {
	this.numberOfTokens = numberOfTokens;
}
public int getNumberOfEnglishTokens() {
	return numberOfEnglishTokens;
}
public void setNumberOfEnglishTokens(int numberOfEnglishTokens) {
	this.numberOfEnglishTokens = numberOfEnglishTokens;
}
public int getNumberOfHindiTokens() {
	return numberOfHindiTokens;
}
public void setNumberOfHindiTokens(int numberOfHindiTokens) {
	this.numberOfHindiTokens = numberOfHindiTokens;
}
public int getNumberOfArabicTokens() {
	return numberOfArabicTokens;
}
public void setNumberOfArabicTokens(int numberOfArabicTokens) {
	this.numberOfArabicTokens = numberOfArabicTokens;
}

}
