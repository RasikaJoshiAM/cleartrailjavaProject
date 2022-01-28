package com.example.demo;
import java.util.*;

public class TokenStatistics implements java.io.Serializable{
	private int frequencyCount;
	private LinkedList<FileStatistics> fileStatisticsList;
	private String tokenName;
	private double frequencyPercentage;
	public TokenStatistics()
	{
		this.fileStatisticsList=new LinkedList<>();
	}
public void setFrequencyPercentage(double frequencyPercentage)
{
	this.frequencyPercentage=frequencyPercentage;
}
public double getFrequencyPercentage()
{
	return this.frequencyPercentage;
}
	public void setTokenName(String tokenName)
	{
		this.tokenName=tokenName;
	}
	public String getTokenName()
	{
		return this.tokenName;
	}
	public int getFrequencyCount() {
		return frequencyCount;
	}
	public void setFrequencyCount(int frequencyCount) {
		this.frequencyCount = frequencyCount;
	}
	public LinkedList<FileStatistics> getFileStatisticsList() {
		return fileStatisticsList;
	}
	public void setFileStatisticsList(LinkedList<FileStatistics> fileStatisticsList) {
		this.fileStatisticsList = fileStatisticsList;
	}
	public void addFileStatistics(FileStatistics fileStatistics) {
		this.fileStatisticsList.addFirst(fileStatistics);
	}
}
