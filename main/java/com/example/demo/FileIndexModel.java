package com.example.demo;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.PreDestroy;

import org.springframework.messaging.simp.SimpMessageSendingOperations;

public class FileIndexModel {
	private LinkedList<String> data;
	private ConcurrentHashMap<String, HashMap<String, TokenStatistics>> indexTokenMap;
	private FileIndexUtility fileIndexUtility;
	private ConcurrentHashMap<String, String> folderToBeIndexAndIndexPathMap;
	private SimpMessageSendingOperations messagingTemplate;

	public FileIndexModel() {
		this.indexTokenMap = new ConcurrentHashMap<>();
		this.fileIndexUtility = new FileIndexUtility(this);
		this.folderToBeIndexAndIndexPathMap = new ConcurrentHashMap<>();
	}

	public FileIndexUtility getFileIndexUtility() {
		return fileIndexUtility;
	}

	@PreDestroy
	public void onDestroy() throws Exception {
		System.out.println("Spring Container is destroyed!");
		System.out.println("Bye");
		this.data = null;
		this.indexTokenMap = null;
		this.fileIndexUtility = null;
		this.folderToBeIndexAndIndexPathMap = null;
		this.messagingTemplate = null;
		this.fileIndexUtility.getFileWatcherThread().stopThread();
	}

	public void setFileIndexUtility(FileIndexUtility fileIndexUtility) {
		this.fileIndexUtility = fileIndexUtility;

	}

	public void setIndexTokenMap(HashMap<String, HashMap<String, TokenStatistics>> indexMap) {
		this.indexTokenMap = indexTokenMap;
	}

	public void setMessagingTemplate(SimpMessageSendingOperations messagingTemplate) {
		this.messagingTemplate = messagingTemplate;
	}

	public void setDirectoriesForWatcher(ArrayList<String> directories) {
		fileIndexUtility.setDirectoriesForWatcher(directories);
	}

	public void sendData() {
		try {
			if (this.messagingTemplate != null)
				this.messagingTemplate.convertAndSend("/topic/greetings", "Data updated");
		} catch(Exception e)
		{
			System.out.println("File model > send data :" +e);
		}
	}

	public ConcurrentHashMap<String, HashMap<String, TokenStatistics>> getIndexTokenMap() {
		return this.indexTokenMap;
	}

	public void addIndexTokenMap(String indexPath, HashMap<String, TokenStatistics> tokenMap) {
		this.indexTokenMap.put(indexPath, tokenMap);
	}

	public void addFolderToBeIndexAndIndexPath(String folderToBeIndex, String indexPath) {
		this.folderToBeIndexAndIndexPathMap.put(folderToBeIndex, indexPath);
	}

	public HashMap<String, TokenStatistics> getIndexTokenMap(String indexPath) {
		return this.indexTokenMap.get(indexPath);
	}

	public void addIndexTokenMap(List<String> foldersToBeIndex, String indexPath)
			throws FileIndexingApplicationException {
		HashMap<String, TokenStatistics> tokenStatisticsMap = new HashMap<>();
		if (this.indexTokenMap.containsKey(indexPath)) {
			tokenStatisticsMap = this.indexTokenMap.get(indexPath);
			fileIndexUtility.setTokenStatisticsMap(tokenStatisticsMap);
		} else {
			fileIndexUtility.setTokenStatisticsMap(tokenStatisticsMap);
			this.addIndexTokenMap(indexPath, tokenStatisticsMap);
		}
		this.fileIndexUtility.setIsThreading(true);
		for (String folderToBeIndex : foldersToBeIndex) {
			this.fileIndexUtility.fetchFiles(new File(folderToBeIndex));
			//this.fileIndexUtility.addIndexFolderPairs(folderToBeIndex, indexPath);
		}
		while (this.fileIndexUtility.getFilesCount() != this.fileIndexUtility.getThreadCount()) {
		}
		for (String folderToBeIndex : foldersToBeIndex) {
		this.fileIndexUtility.addIndexFolderPairs(folderToBeIndex,indexPath);
		}
	//	this.fileIndexUtility.getExecutorService().shutdown();
		this.fileIndexUtility.writeInFile(indexPath);
		this.fileIndexUtility.writeIndexPairInFile();
	}

	public int getIndexTokenMapSize() {
		return this.indexTokenMap.size();
	}

	public LinkedList<TokenStatistics> getTokenStatisticsList() throws FileIndexingApplicationException {
		LinkedList<TokenStatistics> tokenStatisticsList = new LinkedList<>();
		Set<String> indexPathsSet = this.indexTokenMap.keySet();
		for (String indexPath : indexPathsSet) {
			HashMap<String, TokenStatistics> tokenStatisticsMap = this.indexTokenMap.get(indexPath);
			Set<String> tokenSet = tokenStatisticsMap.keySet();
			for (String token : tokenSet) {
				TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
				tokenStatisticsList.add(tokenStatistics);
			}
		}
		return tokenStatisticsList;
	}

	public LinkedList<TokenStatistics> getUniqueTokenStatisticsList() throws FileIndexingApplicationException {
		LinkedList<TokenStatistics> tokenStatisticsList = new LinkedList<>();
		HashMap<String, TokenStatistics> finalMap = new HashMap<>();
		Set<String> indexPathsSet = this.indexTokenMap.keySet();
		int tokenSum = 0;
		for (String indexPath : indexPathsSet) {
			HashMap<String, TokenStatistics> tokenStatisticsMap = (HashMap<String,TokenStatistics>)this.indexTokenMap.get(indexPath).clone();
			Set<String> tokenSet = tokenStatisticsMap.keySet();
			for (String token : tokenSet) {
				TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
				if (finalMap.containsKey(tokenStatistics.getTokenName())) {
					TokenStatistics ts = finalMap.get(tokenStatistics.getTokenName());
					tokenSum += tokenStatistics.getFrequencyCount();
					ts.setFrequencyCount(ts.getFrequencyCount() + tokenStatistics.getFrequencyCount());
				} else {
					TokenStatistics tokenStatistics1 = new TokenStatistics();
					tokenSum += tokenStatistics.getFrequencyCount();
					tokenStatistics1.setTokenName(tokenStatistics.getTokenName());
					tokenStatistics1.setFrequencyCount(tokenStatistics.getFrequencyCount());
					finalMap.put(tokenStatistics.getTokenName(), tokenStatistics1);
				}
			}
		}
		for (String tokenName : finalMap.keySet()) {
			TokenStatistics tokenStatistics = finalMap.get(tokenName);
			double percentage = (double) (((double) tokenStatistics.getFrequencyCount() / (double) tokenSum)
					* (double) 100);
			tokenStatistics.setFrequencyPercentage(percentage);
			tokenStatisticsList.add(tokenStatistics);
		}
		return tokenStatisticsList;
	}

	public LinkedList<FileStatistics> getFilesList() throws FileIndexingApplicationException {
		LinkedList<FileStatistics> fileStatisticsList = new LinkedList<>();
		HashSet<String> filesList = (HashSet<String>) this.fileIndexUtility.getFilesSet().clone();
		Iterator<String> iterator = filesList.iterator();
		while (iterator.hasNext()) {
			String filePath = iterator.next();
			File file = new File(filePath);
			String fileName = filePath.substring(filePath.lastIndexOf('\\') + 1, filePath.length());
			FileStatistics fileStatistics = new FileStatistics();
			filePath = filePath.substring(0, filePath.lastIndexOf('\\'));
			fileStatistics.setFilePath(filePath);
			fileStatistics.setFileName(fileName);
			fileStatistics.setDate(new Date(file.lastModified()));
			fileStatistics.setSize(file.length());
			fileStatisticsList.add(fileStatistics);
		}
		return fileStatisticsList;
	}

	public LinkedList<FileStatistics> getFilesByToken(String token) throws FileIndexingApplicationException {
		LinkedList<FileStatistics> fileStatisticsList = new LinkedList<>();
		Set<String> indexPathSet = this.indexTokenMap.keySet();
		TokenStatistics tokenStatistics = new TokenStatistics();
		for (String indexPath : indexPathSet) {
			HashMap<String, TokenStatistics> tokenStatisticsMap = this.indexTokenMap.get(indexPath);
			token = token.toLowerCase();
			if (tokenStatisticsMap.containsKey(token)) {
				tokenStatistics = tokenStatisticsMap.get(token);
				LinkedList<FileStatistics> list = tokenStatistics.getFileStatisticsList();
				for (FileStatistics fileStatistics : list) {
					fileStatisticsList.add(fileStatistics);
				}
			}
		}
		return fileStatisticsList;
	}

	public LinkedList<FileStatistics> getFilesByFilter(String filter) throws FileIndexingApplicationException {
		LinkedList<FileStatistics> fileStatisticsList = this.getFilesList();
		if (filter.equals("name")) {
			Collections.sort(fileStatisticsList, (fs1, fs2) -> {
				return fs1.getFileName().compareToIgnoreCase(fs2.getFileName());
			});
		}
		if (filter.equals("size")) {
			Collections.sort(fileStatisticsList, (fs1, fs2) -> {
				return (int) (fs1.getSize() - fs2.getSize());
			});
		}
		if (filter.equals("path")) {
			Collections.sort(fileStatisticsList, (fs1, fs2) -> {
				return fs1.getFilePath().compareToIgnoreCase(fs2.getFilePath());
			});
			if (filter.equals("path")) {
				return fileStatisticsList;
			}
		}
		return fileStatisticsList;
	}

	public LinkedList<TokenStatistics> getTokensByFilter(String filter) throws FileIndexingApplicationException {
		LinkedList<TokenStatistics> tokenStatisticsList = this.getUniqueTokenStatisticsList();
		if (filter.equals("name")) {
			Collections.sort(tokenStatisticsList, (fs1, fs2) -> {
				return fs1.getTokenName().compareToIgnoreCase(fs2.getTokenName());
			});
		}
		if (filter.equals("frequencyCount")) {
			Collections.sort(tokenStatisticsList, (fs1, fs2) -> {
				return (int) (fs2.getFrequencyCount() - fs1.getFrequencyCount());
			});
		}
		if (filter.equals("frequencyPercentage")) {
			Collections.sort(tokenStatisticsList, (fs1, fs2) -> {
				return (int) (fs2.getFrequencyCount() - fs1.getFrequencyCount());
			});
		}
		return tokenStatisticsList;
	}

	public void searchOnSize(long fromSize, long toSize, long size, LinkedList<FileStatistics> fileStatisticsList,
			FileStatistics fileStatistics) throws FileIndexingApplicationException {
		if (fromSize != 0 && toSize != 0) {
			if (size >= fromSize && size <= toSize) {
				fileStatisticsList.add(fileStatistics);
			}
		} else {
			if (fromSize == 0 && toSize != 0) {
				if (size <= toSize) {
					fileStatisticsList.add(fileStatistics);
				} else {
					if (fromSize != 0 && toSize == 0) {
						if (size >= fromSize) {
							fileStatisticsList.add(fileStatistics);
						} else {
							if (fromSize == 0 && toSize == 0) {
								fileStatisticsList.add(fileStatistics);
							}
						}
					}
				}
			}
		}
	}

	public void searchOnDate(long fromDate, long toDate, long time, LinkedList<FileStatistics> fileStatisticsListFinal,
			FileStatistics fileStatistics) throws FileIndexingApplicationException {
		if (fromDate != 0 && toDate != 0) {
			if (time >= fromDate && time <= toDate) {
				fileStatisticsListFinal.add(fileStatistics);
			}
		} else {
			if (fromDate == 0 && toDate != 0) {
				if (time <= toDate) {
					fileStatisticsListFinal.add(fileStatistics);
				}
			} else {
				if (fromDate != 0 && toDate == 0) {
					if (time >= fromDate) {
						fileStatisticsListFinal.add(fileStatistics);
					}
				} else {
					if (fromDate == 0 && toDate == 0) {
						fileStatisticsListFinal.add(fileStatistics);
					}
				}
			}
		}

	}

	public LinkedList<FileStatistics> searchFiles(SearchData searchData) throws FileIndexingApplicationException {
		LinkedList<FileStatistics> fileStatisticsList = new LinkedList<FileStatistics>();
		LinkedList<FileStatistics> fileStatisticsListFinal = new LinkedList<FileStatistics>();
		String token = searchData.getToken();
		long toDate;
		long fromDate;
		if (searchData.getToDate() == null) {
			toDate = 0;
		} else {
			toDate = searchData.getToDate().getTime();
		}
		if (searchData.getFromDate() == null) {
			fromDate = 0;
		} else {
			fromDate = searchData.getFromDate().getTime();
		}
		if (toDate == 0 && fromDate == 0 && searchData.getToSize() == 0 && searchData.getFromSize() == 0
				&& (token == null || token.trim().length() == 0)) {
			return this.getFilesList();
		}
		long fromSize = searchData.getFromSize();
		long toSize = searchData.getToSize();
		for (String indexPath : this.indexTokenMap.keySet()) {
			HashMap<String, TokenStatistics> tokenStatisticsMap = this.indexTokenMap.get(indexPath);
			System.out.println("Check token contains :"+tokenStatisticsMap.containsKey(token));
			if (token != null && token.trim().length() != 0) {
				if (!tokenStatisticsMap.containsKey(token))
					return fileStatisticsListFinal;
				TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
				LinkedList<FileStatistics> filesList = tokenStatistics.getFileStatisticsList();
				if ((fromDate != 0 || toDate != 0) && (fromSize != 0 || toSize != 0)) {
					for (FileStatistics fileStatistics : filesList) {
						long size = fileStatistics.getSize();
						searchOnSize(fromSize, toSize, size, fileStatisticsList, fileStatistics);
					}
					for (FileStatistics fileStatistics : fileStatisticsList) {
						long time = fileStatistics.getDate().getTime();
						searchOnDate(fromDate, toDate, time, fileStatisticsListFinal, fileStatistics);
					}
				} else {
					if ((fromDate == 0 && toDate == 0) && (fromSize != 0 || toSize != 0)) {
						for (FileStatistics fileStatistics : filesList) {
							long size = fileStatistics.getSize();
							searchOnSize(fromSize, toSize, size, fileStatisticsListFinal, fileStatistics);
						}
					} else {
						if ((fromSize == 0 && toSize == 0) && (fromDate != 0 || toDate != 0)) {
							for (FileStatistics fileStatistics : filesList) {
								long time = fileStatistics.getDate().getTime();
								searchOnDate(fromDate, toDate, time, fileStatisticsListFinal, fileStatistics);
							}
						} else {
							if ((fromSize == 0 && toSize == 0) && (fromDate == 0 || toDate == 0)) {
								for (FileStatistics fileStatistics : filesList) {
									fileStatisticsListFinal.add(fileStatistics);
								}

							}
						}
					}
				}
			} else {
				for (String tokenName : tokenStatisticsMap.keySet()) {
					TokenStatistics tokenStatistics = tokenStatisticsMap.get(tokenName);
					if ((fromDate != 0 || toDate != 0) && (fromSize != 0 || toSize != 0)) {
						for (FileStatistics fileStatistics : tokenStatistics.getFileStatisticsList()) {
							long size = fileStatistics.getSize();
							searchOnSize(fromSize, toSize, size, fileStatisticsList, fileStatistics);
						}
						for (FileStatistics fileStatistics : fileStatisticsList) {
							long time = fileStatistics.getDate().getTime();
							searchOnDate(fromDate, toDate, time, fileStatisticsListFinal, fileStatistics);
						}
					} else {
						if ((fromDate == 0 && toDate == 0) && (fromSize != 0 || toSize != 0)) {
							for (FileStatistics fileStatistics : tokenStatistics.getFileStatisticsList()) {
								long size = fileStatistics.getSize();
								this.searchOnSize(fromSize, toSize, size, fileStatisticsListFinal, fileStatistics);
							}
						} else {
							if ((fromSize == 0 && toSize == 0) && (fromDate != 0 || toDate != 0)) {
								for (FileStatistics fileStatistics : tokenStatistics.getFileStatisticsList()) {
									long time = fileStatistics.getDate().getTime();
									searchOnDate(fromDate, toDate, time, fileStatisticsListFinal, fileStatistics);
								}
							}
						}
					}
				}
			}
		}
		HashMap<String, FileStatistics> tempHashMap = new HashMap<>();
		for (FileStatistics fileStatistics : fileStatisticsListFinal) {
			tempHashMap.put(fileStatistics.getFilePath(), fileStatistics);
		}
		fileStatisticsListFinal = new LinkedList<>();
		for (String filePath : tempHashMap.keySet()) {
			FileStatistics fileStatistics = tempHashMap.get(filePath);
			String fileName = filePath.substring(filePath.lastIndexOf('\\') + 1, filePath.length());
			filePath = filePath.substring(0, filePath.lastIndexOf('\\'));
			FileStatistics fs = new FileStatistics();
			fs.setFilePath(filePath);
			fs.setFileName(fileName);
			fs.setDate(fileStatistics.getDate());
			fs.setSize(fileStatistics.getSize());
			fileStatisticsListFinal.add(fs);
		}
		return fileStatisticsListFinal;
	}

	public long getNumberOfTokens() {
		long numberOfTokens = 0;
		this.fileIndexUtility.setEnglishWordCount(0);
		this.fileIndexUtility.setArabicWordCount(0);
		this.fileIndexUtility.setHindiWordCount(0);
		for (String indexPath : this.indexTokenMap.keySet()) {
			HashMap<String, TokenStatistics> tokenStatisticsMap = this.indexTokenMap.get(indexPath);
			numberOfTokens += tokenStatisticsMap.size();
			for (String token : tokenStatisticsMap.keySet()) {
				this.fileIndexUtility.checkCharacter(token);
			}
		}
		return numberOfTokens;
	}
}