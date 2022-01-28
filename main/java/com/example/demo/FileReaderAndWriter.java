package com.example.demo;

import java.io.*;
import java.util.*;

public class FileReaderAndWriter {
	private String indexPath = "C:\\Users\\kunal.gangaher\\Training\\Assignment3";
	private String indexFolderPath = "C:\\Users\\kunal.gangaher\\Training\\IndexFolderPath\\IndexPath.txt";
	private String stopWordsFilePath = "C:\\Users\\kunal.gangaher\\Training\\StopWordsFiles";

	public String getIndexFolderPath() {
		return indexFolderPath;
	}

	public void setIndexFolderPath(String folderPath) {
		this.indexFolderPath = folderPath;
	}

	public void readStopWordsFromFile(StopWordsValidator stopWordsValidator) {
		try {
			File file = new File(this.stopWordsFilePath + "\\file1.txt");
			Scanner sc = new Scanner(file);
			HashSet<String> stopWordsSet = new HashSet<>();
			while (sc.hasNext()) {
				String word = sc.next();
				if (word.trim().length() != 0) {
					stopWordsSet.add(word);
				}
			}
			stopWordsValidator.setStopWords(stopWordsSet);
			sc.close();
		} catch (Exception e) {
			System.out.println("Exception from readStopWordsFromFile :" + e);
		}
	}

	public LinkedList<String> readFolderPathsFromFile() {
		try {
			if (!checkExistence())
				return new LinkedList<String>();
			File file = new File(this.indexPath + "\\temp1.txt");
			Scanner sc = new Scanner(file);
			LinkedList<String> indexPaths = new LinkedList<>();
			while (sc.hasNext()) {
				indexPaths.add(sc.nextLine().trim());
			}
			sc.close();
			return indexPaths;
		} catch (Exception e) {
			System.out.println(e);
		}
		return null;
	}

	public boolean checkExistence() {
		File f = new File(this.indexFolderPath);
		if (f.exists()) {
			return true;
		} else {
			return false;
		}
	}

	public LinkedList<String> getIndexFolderPaths() {
		LinkedList<String> filePaths = new LinkedList<>();
		try {
			File fileOfIndexPath = new File(this.indexFolderPath);
			Scanner sc = new Scanner(fileOfIndexPath);
			while (sc.hasNext()) {
				filePaths.add(sc.nextLine());
			}
			sc.close();
			return filePaths;
		} catch (Exception e) {
			System.out.println("Exception in file reader and writer :" + e);
		}
		return filePaths;
	}

	public HashMap<String, TokenStatistics> readFromFile(String folderPath) {
		try {
			File toRead = new File(folderPath + "\\Index.ser");
			FileInputStream fis = new FileInputStream(toRead);
			ObjectInputStream ois = new ObjectInputStream(fis);
			HashMap<String, TokenStatistics> mapInFile = (HashMap<String, TokenStatistics>) ois.readObject();
			ois.close();
			fis.close();
			Set<String> keySet = mapInFile.keySet();
			Iterator<String> iter = keySet.iterator();
			while (iter.hasNext()) {
				String key = iter.next();
			}
			return mapInFile;
		} catch (Exception e) {
			System.out.println(e);
		}
		return null;
	}

	public void writeFolderPathInFile(String indexPath) {
		try {
			File file = new File(this.indexFolderPath);
			RandomAccessFile raf = new RandomAccessFile(file, "rw");
			if (file.length() == 0) {
				raf.writeBytes(indexPath);
			} else {
				raf.seek(raf.length());
				raf.writeBytes("\r\n");
				raf.writeBytes(indexPath);
			}
			raf.close();
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public void writeIndexFolderPairInFile(LinkedList<IndexFolderPair> indexFolderPairs) {
		try {
			String indexFolderPairFilePath = this.indexFolderPath.substring(0, this.indexFolderPath.lastIndexOf("\\"));
			File file = new File(indexFolderPairFilePath + "\\" + "IndexFolderPair.txt");
			FileOutputStream fileOutputStream = new FileOutputStream(file);
			ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);
			objectOutputStream.writeObject(indexFolderPairs);
			objectOutputStream.close();
			fileOutputStream.close();
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public LinkedList<IndexFolderPair> readIndexFolderPairInFile() {
		try {
			LinkedList<IndexFolderPair> indexFolderPairs;
			String indexFolderPairFilePath = this.indexFolderPath.substring(0, this.indexFolderPath.lastIndexOf("\\"));
			File file = new File(indexFolderPairFilePath + "\\" + "IndexFolderPair.txt");
			FileInputStream fis = new FileInputStream(file);
			ObjectInputStream ois = new ObjectInputStream(fis);
			indexFolderPairs = (LinkedList<IndexFolderPair>) ois.readObject();
			ois.close();
			fis.close();
			return indexFolderPairs;
		} catch (Exception e) {
			System.out.println(e);
		}
		return null;
	}

	public void writeInFile(String folderPath, HashMap<String, TokenStatistics> invertedIndexMap) {
		try {
			this.writeFolderPathInFile(folderPath);
			File file = new File(folderPath + "\\" + "Index.ser");
			FileOutputStream fileOutputStream = new FileOutputStream(file);
			ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);
			objectOutputStream.writeObject(invertedIndexMap);
			objectOutputStream.close();
			fileOutputStream.close();
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}
