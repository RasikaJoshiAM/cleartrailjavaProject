package com.example.demo;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Scanner;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

public class FileIndexUtility implements FileWatcherListener {
	private StopWordsValidator stopWordsValidator;
	private HashMap<String, TokenStatistics> tokenStatisticsMap;
	private String folderPath;
	private String indexFolderPath;
	private HashSet<String> filesSet;
	private HashSet<String> filesToAllow;
	private FileReaderAndWriter fileReaderAndWriter;
	private FileWatcherThread fileWatcherThread;
	private FileIndexModel fileIndexModel;
	private LinkedList<IndexFolderPair> indexFolderPairs;
	private int filesCount = 0;
	private boolean isFileModify = false;
	private boolean isStopWordsFileUploaded;
	private int numberOfFolders;
	private int hindi;
	private int english;
	private int arabic;
	private long bytesRead = 0;
	private long bytesReadFromFile = 0;
	private int threadCount;
	private ExecutorService executorService;
private boolean isThreading;
	public FileIndexUtility(FileIndexModel fileIndexModel) {
		this.fileIndexModel = fileIndexModel;
		this.tokenStatisticsMap = new HashMap<>();
		this.stopWordsValidator = new StopWordsValidator();
		this.filesSet = new HashSet<>();
		this.fileReaderAndWriter = new FileReaderAndWriter();
		this.fileWatcherThread = new FileWatcherThread();
		this.indexFolderPairs = new LinkedList<>();
		this.fileWatcherThread.setFileWatcherListener(this);
		this.filesToAllow = new HashSet<>();
		this.numberOfFolders = 0;
		this.hindi = 0;
		this.english = 0;
		this.arabic = 0;
		this.threadCount = 0;
		this.executorService = Executors.newFixedThreadPool(5);
		this.initializeFilesToAllow();
		this.readFromFile();
	}
public void setIsThreading(boolean isThreading)
{
	this.isThreading=isThreading;
}
public boolean getIsThreading()
{
	return this.isThreading;
}
	public void initializeFilesToAllow() {
		this.filesToAllow.add("txt");
		this.filesToAllow.add("log");
		this.filesToAllow.add("err");
	//	this.filesToAllow.add("pdf");
	}

	public boolean isStopWordsFileUploaded() {
		return this.isStopWordsFileUploaded;
	}

	public void setIsStopWordsFileUploaded(boolean status) {
		this.isStopWordsFileUploaded = status;
		if (this.isStopWordsFileUploaded) {
			this.fileReaderAndWriter.readStopWordsFromFile(this.stopWordsValidator);
		}
	}

	public void writeIndexPairInFile() {
		this.fileReaderAndWriter.writeIndexFolderPairInFile(this.indexFolderPairs);
	}

	public void increaseThreadsCountByOne() {
		this.threadCount++;
	}

	public void addIndexFolderPairs(String folderToBeIndex, String indexPath) {
		IndexFolderPair indexFolderPair = new IndexFolderPair();
		indexFolderPair.setFolderToBeIndex(folderToBeIndex);
		indexFolderPair.setIndexFolderPath(indexPath);
		this.indexFolderPairs.add(indexFolderPair);
	}

	public void readFromFile() {
		if (this.fileReaderAndWriter.checkExistence()) {
			LinkedList<String> indexPaths = this.fileReaderAndWriter.getIndexFolderPaths();
			HashSet<String> indexPathsSet = new HashSet<>();
			for (String each : indexPaths) {
				if (each.trim().length() == 0)
					continue;
				indexPathsSet.add(each);
			}
			Iterator<String> iterator = indexPathsSet.iterator();
			indexPaths = new LinkedList<>();
			while (iterator.hasNext()) {
				indexPaths.add(iterator.next());
			}
			System.out.println("IndexFolderPaths :" + indexPaths.size());
			for (String indexPath : indexPaths) {
				System.out.println("Index path :" + indexPath);
				HashMap<String, TokenStatistics> tokenStatisticsMap = this.fileReaderAndWriter.readFromFile(indexPath);
				System.out.println("Token statistics map size :" + tokenStatisticsMap.size());
				if (tokenStatisticsMap == null)
					continue;
				this.fileIndexModel.addIndexTokenMap(indexPath, tokenStatisticsMap);
				for (String token : tokenStatisticsMap.keySet()) {
					TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
					this.addFilesSet(tokenStatistics.getFileStatisticsList());
				}
			}
			this.indexFolderPairs = this.fileReaderAndWriter.readIndexFolderPairInFile();
			ArrayList<String> foldersToApplyWatcher = new ArrayList<String>();
			for (IndexFolderPair indexFolderPair : indexFolderPairs) {
				foldersToApplyWatcher.add(indexFolderPair.getFolderToBeIndex());
			}
			this.fileWatcherThread.setDirectories(foldersToApplyWatcher);
			this.filesCount = this.filesSet.size();
		} else {
			System.out.println("File with index path doesn't exists");
		}
	}

	public int getFilesCount() {
		return this.filesCount;
	}

	public int getThreadCount() {
		return this.threadCount;
	}

	public ExecutorService getExecutorService() {
		return this.executorService;
	}

	public void setFilesCount(int filesCount) {
		this.filesCount = filesCount;
	}

	public long getBytesReadFromFile() {
		return this.bytesReadFromFile;
	}

	public int getFilesCount(File node) {
		if (node.isFile()) {
			String name = node.getName();
			String extension = name.substring(name.lastIndexOf('.') + 1, name.length());
			if (this.filesToAllow.contains(extension)) {
				if (Files.isReadable(node.toPath()) != false) {
					this.filesCount++;
				}
				this.bytesReadFromFile += node.length();
			}
		}
		if (node.isDirectory()) {
			String[] subNote = node.list();
			if (subNote != null) {
				for (String fileName : subNote) {
					File file = new File(node, fileName);
					getFilesCount(file);
				}
			}
		}
		return this.filesCount;
	}

	public void addFilesSet(LinkedList<FileStatistics> fileStatisticsList) {
		for (FileStatistics fileStatistics : fileStatisticsList) {
			this.filesSet.add(fileStatistics.getFilePath());
		}
	}

	public LinkedList<IndexFolderPair> getIndexFolderPairs() {
		return indexFolderPairs;
	}

	public void setIndexFolderPairs(LinkedList<IndexFolderPair> indexFolderPairs) {
		this.indexFolderPairs = indexFolderPairs;
	}

	public void addIndexFolderPair(IndexFolderPair indexFolderPair) {
		this.indexFolderPairs.add(indexFolderPair);
	}

	public FileWatcherThread getFileWatcherThread() {
		return this.fileWatcherThread;
	}

	public void setTokenStatisticsMap(HashMap<String, TokenStatistics> tokenStatisticsMap) {
		this.tokenStatisticsMap = tokenStatisticsMap;
	}

	public void setDirectoriesForWatcher(ArrayList<String> directories) {
		this.fileWatcherThread.setDirectories(directories);
	}

	public HashMap<String, TokenStatistics> getTokenStatisticsMap() {
		return this.tokenStatisticsMap;
	}

	public void setFilesSet(HashSet<String> filesSet) {
		this.filesSet = filesSet;
	}

	public HashSet<String> getFilesSet() {
		return this.filesSet;
	}

	public int getNumberOfFolders() {
		return this.indexFolderPairs.size();
	}

	synchronized public void fetchFiles(File node) {
		try {
			if (node.isFile()) {
			if(Files.isReadable(node.toPath())!=false)
			{
				String name = node.getName();
				String extension = name.substring(name.lastIndexOf('.') + 1, name.length());
				if (this.filesToAllow.contains(extension)) {
					if(isThreading)
					{
					FileIndexingThread fileIndexingThread = new FileIndexingThread(extension, node, this);
					this.executorService.execute(fileIndexingThread);
					}
					else
					{
						System.out.println("In else :"+isThreading);
						this.performIndexing(extension, node);
					}
				} else {
					// System.out.println("Skip file :" + node.getAbsolutePath());
				}
			}
			}
			if (node.isDirectory()) {
				this.numberOfFolders++;
				String[] subNote = node.list();
				if (subNote != null) {
					for (String fileName : subNote) {
						File file = new File(node, fileName);
						this.fetchFiles(file);
					}
				}
			}
			this.calculatePercentage();
		} catch (Exception e) {
			System.out.println("Exception in fetchFiles :" + e);
		}
	}

	synchronized public void performIndexing(String extension, File node) {
		try {
			HashMap<String, Integer> invertedMap;
			if (extension.equals("pdf")) {
				invertedMap = new HashMap<String, Integer>();
				File file = new File(node.getAbsolutePath());
				PDDocument document = PDDocument.load(file);
				PDFTextStripper pdfStripper = new PDFTextStripper();
				String text = pdfStripper.getText(document);
				document.close();
				invertedMap = this.countTokens(text, invertedMap);
			} else {
				invertedMap = this.countTokensInverted(node);
			}
			this.addTokenStatisticsMap(invertedMap, node);
			this.filesSet.add(node.getAbsolutePath());
		} catch (Exception e) {
			System.out.println("Exception in perform indexing :" + e);
		}
	}

	public int getFilesSetSize() {
		return this.filesSet.size();
	}

	synchronized public void calculatePercentage() {
		Set<String> tokenSet = this.tokenStatisticsMap.keySet();
		int sum = 0;
		for (String token : tokenSet) {
			TokenStatistics tokenStatistics = this.tokenStatisticsMap.get(token);
			sum += tokenStatistics.getFrequencyCount();
		}
		for (String token : tokenSet) {
			TokenStatistics tokenStatistics = this.tokenStatisticsMap.get(token);
			double percentage = (double) (((double) tokenStatistics.getFrequencyCount() / (double) sum) * (double) 100);
			tokenStatistics.setFrequencyPercentage(percentage);
		}
	}

	public void calculatePercentage(HashMap<String, TokenStatistics> tokenStatisticsMap) {
		Set<String> tokenSet = tokenStatisticsMap.keySet();
		int sum = 0;
		for (String token : tokenSet) {
			TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
			sum += tokenStatistics.getFrequencyCount();
		}
		for (String token : tokenSet) {
			TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
			double percentage = (double) (((double) tokenStatistics.getFrequencyCount() / (double) sum) * (double) 100);
			tokenStatistics.setFrequencyPercentage(percentage);
		}
	}

	public long getBytesRead() {
		return this.bytesRead;
	}

	synchronized public HashMap<String, Integer> countTokensInverted(File file) {
		HashMap<String, Integer> tokenCounter = new HashMap<>();
		try {
			Scanner sc = new Scanner(file);
			String data;
			while (sc.hasNext()) {
				data = sc.next();
				if (data.trim().length() == 0)
					continue;
				this.countTokens(data, tokenCounter);
			}
			sc.close();
			// bf.close();
			return tokenCounter;
		} catch (Exception e) {
			System.out.println("Exception in countTokensInverted :" + e);
		}
		return tokenCounter;
	}

	synchronized public HashMap<String, Integer> countTokens(String data, HashMap<String, Integer> tokenCounter) {
		boolean isStopWord;
		data = data.replaceAll("[+^\":’‘…,?;=%#&~`$'!@*_)/(}{\\.]", " ");
		data = data.toLowerCase();
		if (data.contains(" ")) {
			String[] array = data.split(" ");
			for (int i = 0; i < array.length; i++) {
				data = array[i];
				data = data.trim();
				if (data.length() == 0)
					continue;
				isStopWord = this.stopWordsValidator.isStopWord(data);
				if (!isStopWord) {
					if (tokenCounter.containsKey(data)) {
						tokenCounter.put(data, tokenCounter.get(data) + 1);
					} else {
						tokenCounter.put(data, 1);
					}
				}
			}
		} else {
			isStopWord = this.stopWordsValidator.isStopWord(data);
			if (!isStopWord) {
				if (tokenCounter.containsKey(data)) {
					tokenCounter.put(data, tokenCounter.get(data) + 1);
				} else {
					tokenCounter.put(data, 1);
				}
			}
		}
		return tokenCounter;
	}

	public void checkCharacter(String data) {
		char c = data.charAt(0);
		if (Character.UnicodeBlock.of(c) == Character.UnicodeBlock.DEVANAGARI) {
			this.hindi++;
		} else {
			if (Character.UnicodeBlock.of(c) == Character.UnicodeBlock.ARABIC) {
				this.arabic++;
			} else {
				if (Character.UnicodeBlock.of(c) == Character.UnicodeBlock.BASIC_LATIN
						|| Character.UnicodeBlock.of(c) == Character.UnicodeBlock.LATIN_1_SUPPLEMENT
						|| Character.UnicodeBlock.of(c) == Character.UnicodeBlock.LATIN_EXTENDED_A) {
					this.english++;
				}
			}
		}

	}

	public int getEnglishWordCount() {
		return this.english;
	}

	public int getHindiWordCount() {
		return this.hindi;
	}

	public int getArabicWordCount() {
		return this.arabic;
	}

	public void setEnglishWordCount(int english) {
		this.english = english;
	}

	public void setHindiWordCount(int hindi) {
		this.hindi = hindi;
	}

	public void setArabicWordCount(int arabic) {
		this.arabic = arabic;
	}

	synchronized public void addTokenStatisticsMap(HashMap<String, Integer> invertedMap, File file) {
		try {
			Set<String> tokenSet = invertedMap.keySet();
			Iterator<String> tokenSetIterator = tokenSet.iterator();
			while (tokenSetIterator.hasNext()) {
				String token = tokenSetIterator.next();
				FileStatistics fileStatistics = new FileStatistics();
				fileStatistics.setFilePath(file.getAbsolutePath());
				fileStatistics.setFileName(file.getName());
				fileStatistics.setDate(new Date(file.lastModified()));
				fileStatistics.setSize(file.length());
				fileStatistics.setFileTokenCount(invertedMap.get(token));
				this.putTokenStatisticsMap(token, fileStatistics);
			}
		} catch (Exception e) {
			System.out.println("Exception in addTokenStatisticsMap :" + e);
		}
	}

	synchronized public void putTokenStatisticsMap(String data, FileStatistics fileStatistics) {
		if (this.tokenStatisticsMap.containsKey(data)) {
			TokenStatistics tokenStatistics = this.tokenStatisticsMap.get(data);
			tokenStatistics.setFrequencyCount(tokenStatistics.getFrequencyCount() + fileStatistics.getFileTokenCount());
			tokenStatistics.addFileStatistics(fileStatistics);
			tokenStatistics.setTokenName(data);
		} else {
			TokenStatistics tokenStatistics = new TokenStatistics();
			tokenStatistics.setFrequencyCount(fileStatistics.getFileTokenCount());
			tokenStatistics.addFileStatistics(fileStatistics);
			tokenStatistics.setTokenName(data);
			this.tokenStatisticsMap.put(data, tokenStatistics);
		}
	}

	public void writeInFile(String indexPath) {
		this.fileReaderAndWriter.writeInFile(indexPath, this.tokenStatisticsMap);
	}

	public void writeInFile(String indexPath, HashMap<String, TokenStatistics> tokenStatisticsMap) {
		this.fileReaderAndWriter.writeInFile(indexPath, tokenStatisticsMap);
	}

	public String getIndexFolderPair(String path) {
		String indexFolderPath = "";
		for (IndexFolderPair indexFolderPair : this.indexFolderPairs) {
			if (path.startsWith(indexFolderPair.getFolderToBeIndex())) {
				indexFolderPath = indexFolderPair.getIndexFolderPath();
				break;
			}
		}
		return indexFolderPath;
	}

	public void fileCreated(Path path) {
		this.filesCount++;
		this.isThreading=false;
		System.out.println("File created called");
		String pathString = path.toString();
		String indexFolderPath = this.getIndexFolderPair(pathString);
		HashMap<String, TokenStatistics> tokenStatisticsMap = this.fileIndexModel.getIndexTokenMap(indexFolderPath);
		this.tokenStatisticsMap = tokenStatisticsMap;
		this.fetchFiles(new File(pathString));
		this.writeInFile(indexFolderPath, tokenStatisticsMap);
		if (this.isFileModify == false) {
			this.fileIndexModel.sendData();
		}
	}

	public void folderCreated(Path path) {
		this.isThreading=false;
		System.out.println("Folder created called");
		String pathString = path.toString();
		String indexFolderPath = this.getIndexFolderPair(pathString);
		HashMap<String, TokenStatistics> tokenStatisticsMap = this.fileIndexModel.getIndexTokenMap(indexFolderPath);
		this.tokenStatisticsMap = tokenStatisticsMap;
		this.fetchFiles(new File(pathString));
		this.writeInFile(indexFolderPath, tokenStatisticsMap);
		if (this.isFileModify == false) {
			//this.fileIndexModel.sendData();
		}
	}

	public void deleteFromIndexFolderPair(String indexedFolder) {
		ArrayList<IndexFolderPair> indexes = new ArrayList<>();
		for (IndexFolderPair indexFolderPair : this.indexFolderPairs) {
			if (indexedFolder.equals(indexFolderPair.getFolderToBeIndex())) {
				indexes.add(indexFolderPair);
			}
		}
		for (IndexFolderPair index : indexes) {
			this.indexFolderPairs.remove(index);
		}
	}

	public void removeFromFilesSet(String folder) {
		Iterator<String> iterator = this.filesSet.iterator();
		ArrayList<String> folders = new ArrayList<>();
		while (iterator.hasNext()) {
			String folder1 = iterator.next();
			if (folder1.startsWith(folder + "\\")) {
				folders.add(folder1);
			}
		}
		for (String each : folders) {
			this.filesSet.remove(each);
		}
	}

	public void deleteFolders(ArrayList<String> folders) {
		this.isThreading=false;
		for (String folder : folders) {
			LinkedList<String> tokenToRemove = new LinkedList<>();
			String pathString = folder;
			if (pathString == null || pathString.trim().length() == 0)
				return;
			this.removeFromFilesSet(pathString);
			String indexFolderPath = this.getIndexFolderPair(pathString);
			HashMap<String, TokenStatistics> tokenStatisticsMap = this.fileIndexModel.getIndexTokenMap(indexFolderPath);
			for (String token : tokenStatisticsMap.keySet()) {
				TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
				int i = 0;
				LinkedList<FileStatistics> fileStatisticsList = tokenStatistics.getFileStatisticsList();
				for (FileStatistics fileStatistics : fileStatisticsList) {
					if (fileStatistics.getFilePath().startsWith(pathString + "\\")) {
						if (tokenStatistics.getTokenName().equals("watcher")) {
							System.out.println("Count :" + tokenStatistics.getFrequencyCount());
							System.out.println(
									"File statistics list size :" + tokenStatistics.getFileStatisticsList().size());
							for (FileStatistics fileStatistics1 : tokenStatistics.getFileStatisticsList()) {
								System.out.println("File name :" + fileStatistics1.getFilePath());
								System.out.println("File frequency count :" + fileStatistics1.getFileTokenCount());
							}
						}
						if (tokenStatistics.getFrequencyCount() > 0) {
							tokenStatistics.setFrequencyCount(
									tokenStatistics.getFrequencyCount() - fileStatistics.getFileTokenCount());
						}
						if (tokenStatistics.getFrequencyCount() <= 0) {
							tokenToRemove.add(token);
							break;
						}
					}

					i++;
				}
				if (i < fileStatisticsList.size()) {
					fileStatisticsList.remove(i);
				}
			}
			for (String token : tokenToRemove) {
				TokenStatistics tokenStatistics = tokenStatisticsMap.remove(token);
			}
			this.fileWatcherThread.removeWatcher(folder);
			this.calculatePercentage(tokenStatisticsMap);
			this.deleteFromIndexFolderPair(pathString);
			this.writeIndexPairInFile();
			this.writeInFile(indexFolderPath, tokenStatisticsMap);
		}
		this.fileIndexModel.sendData();
	}

	public void folderDeleted(Path path) {
		this.isThreading=false;
		System.out.println("Folder deleted called");
		LinkedList<String> tokenToRemove = new LinkedList<>();
		String pathString = path.toString();
		this.removeFromFilesSet(pathString);
		String indexFolderPath = this.getIndexFolderPair(pathString);
		HashMap<String, TokenStatistics> tokenStatisticsMap = this.fileIndexModel.getIndexTokenMap(indexFolderPath);
		for (String token : tokenStatisticsMap.keySet()) {
			TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
			int i = 0;
			LinkedList<FileStatistics> fileStatisticsList = tokenStatistics.getFileStatisticsList();
			for (FileStatistics fileStatistics : fileStatisticsList) {
				if (fileStatistics.getFilePath().startsWith(pathString)) {
					this.filesCount--;
					if (tokenStatistics.getFrequencyCount() > 0)
						tokenStatistics.setFrequencyCount(
								tokenStatistics.getFrequencyCount() - fileStatistics.getFileTokenCount());
					if (tokenStatistics.getFrequencyCount() <= 0)
						tokenToRemove.add(token);
					break;
				}

				i++;
			}
			if (i < fileStatisticsList.size()) {
				fileStatisticsList.remove(i);
			}
		}
		for (String token : tokenToRemove) {
			tokenStatisticsMap.remove(token);
		}
		this.calculatePercentage(tokenStatisticsMap);
		this.writeInFile(indexFolderPath, tokenStatisticsMap);
	}

	public void fileDeleted(Path path) {
		this.isThreading=false;
		LinkedList<String> tokenToRemove = new LinkedList<>();
		String pathString = path.toString();
		boolean isRemoved = this.filesSet.remove(pathString);
		String indexFolderPath = this.getIndexFolderPair(pathString);
		HashMap<String, TokenStatistics> tokenStatisticsMap = this.fileIndexModel.getIndexTokenMap(indexFolderPath);
		for (String token : tokenStatisticsMap.keySet()) {
			TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
			int i = 0;
			LinkedList<FileStatistics> fileStatisticsList = tokenStatistics.getFileStatisticsList();
			for (FileStatistics fileStatistics : fileStatisticsList) {
				if (fileStatistics.getFilePath().equals(pathString)) {
					this.filesCount--;
					if (tokenStatistics.getFrequencyCount() > 0)
						tokenStatistics.setFrequencyCount(
								tokenStatistics.getFrequencyCount() - fileStatistics.getFileTokenCount());
					if (tokenStatistics.getFrequencyCount() <= 0)
						tokenToRemove.add(token);
					break;
				}

				i++;
			}
			if (i < fileStatisticsList.size()) {
				fileStatisticsList.remove(i);
			}
		}
		for (String token : tokenToRemove) {
			tokenStatisticsMap.remove(token);
		}
		this.filesSet.remove(pathString);
		this.calculatePercentage(tokenStatisticsMap);
		this.writeInFile(indexFolderPath, tokenStatisticsMap);
		if (this.isFileModify == false)
			this.fileIndexModel.sendData();
	}

	public void fileModify(Path path) {
		this.isThreading=false;
		this.isFileModify = true;
		this.fileDeleted(path);
		this.fileCreated(path);
		this.isFileModify = false;
		this.fileIndexModel.sendData();
	}
}
