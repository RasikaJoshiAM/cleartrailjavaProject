package com.example.demo;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class AssignmentTwoService {
	@Autowired
	private FileIndexModel fileIndexModel;
	@Autowired
	private SimpMessageSendingOperations messagingTemplate;
	private String folderPath = "C:\\Users\\kunal.gangaher\\Training\\FoldersToBeIndex";
	private String foldersPathForIndexFile = "C:\\Users\\kunal.gangaher\\Training\\FoldersToSaveIndexFile";
	private int progress = 0;
	private int filesCount = 0;
	private HashSet<String> indexedFolders = new HashSet<>();
	private Logger logger = Logger.getLogger(AssignmentTwoService.class.getName());

	@RequestMapping(value = "/deleteIndexedFolders", method = RequestMethod.POST)
	public ServiceResponse deleteIndexedFolders(@RequestBody ServiceResponse serviceResponse) {
		ServiceResponse serviceResponse1 = new ServiceResponse();
		ArrayList<String> indexedFoldersList = (ArrayList<String>) serviceResponse.getResult();
		for (String folder : indexedFoldersList) {
			System.out.println("Folder :" + folder);
		this.indexedFolders.remove(folder);
		}
		serviceResponse1.setIsSuccessful(true);
		this.fileIndexModel.getFileIndexUtility().deleteFolders(indexedFoldersList);
		serviceResponse1.setResult("Indexed folders deleted successfully");
		return serviceResponse1;
	}

	@RequestMapping(value = "/getListOfFoldersToBeIndex", method = RequestMethod.GET)
	public LinkedList<String> getListOfFoldersToBeIndex() {
		LinkedList<String> listOfFolders = new LinkedList<>();
		HashSet<String> setOfFolders = new HashSet<>();
		String folderPaths[] = { this.folderPath };
		for (String folderPath : folderPaths) {
			File file = new File(folderPath);
			File[] folders = file.listFiles();
			int index = 0;
			if (this.fileIndexModel.getFileIndexUtility().getIndexFolderPairs().size() != 0) {
				for (File f : folders) {
					index = 0;
					for (IndexFolderPair indexFolderPair : this.fileIndexModel.getFileIndexUtility()
							.getIndexFolderPairs()) {
						if (f.getAbsolutePath().equals(indexFolderPair.getFolderToBeIndex())) {
							break;
						}
						index++;
					}
					if (index == this.fileIndexModel.getFileIndexUtility().getIndexFolderPairs().size()) {
						setOfFolders.add(f.getAbsolutePath());
					}
				}

			} else {
				for (File f : folders) {
					listOfFolders.add(f.getAbsolutePath());
				}
			}
		}
		Iterator<String> iter = setOfFolders.iterator();
		while (iter.hasNext()) {
			listOfFolders.add(iter.next());
		}
		return listOfFolders;
	}

	public LinkedList<String> getListOfFolders() {
		LinkedList<String> listOfFolders = new LinkedList<>();
		HashSet<String> setOfFolders = new HashSet<>();
		File file = new File(this.folderPath);
		File[] folders = file.listFiles();
		int index = 0;
		if (this.fileIndexModel.getFileIndexUtility().getIndexFolderPairs().size() != 0) {
			for (File f : folders) {
				index = 0;
				for (IndexFolderPair indexFolderPair : this.fileIndexModel.getFileIndexUtility()
						.getIndexFolderPairs()) {
					if (f.getAbsolutePath().equals(indexFolderPair.getFolderToBeIndex())) {
						break;
					}
					index++;
				}
				if (index == this.fileIndexModel.getFileIndexUtility().getIndexFolderPairs().size()) {
					setOfFolders.add(f.getAbsolutePath());
				}
			}
			Iterator<String> iter = setOfFolders.iterator();
			while (iter.hasNext()) {
				listOfFolders.add(iter.next());
			}

		} else {
			for (File f : folders) {
				listOfFolders.add(f.getAbsolutePath());
			}
		}
		return listOfFolders;

	}

	@RequestMapping(value = "/getIndexedFoldersList", method = RequestMethod.GET)
	public ServiceResponse getIndexedFoldersList() {
		LinkedList<IndexFolderPair> indexFolderPairs = this.fileIndexModel.getFileIndexUtility().getIndexFolderPairs();
		HashSet<String> indexedFoldersList = new HashSet<>();
		for (IndexFolderPair indexFolderPair : indexFolderPairs) {
			indexedFoldersList.add(indexFolderPair.getFolderToBeIndex());
		}
		System.out.println("Indexed folders pairs :"+indexFolderPairs.size());
		ServiceResponse serviceResponse = new ServiceResponse();
		serviceResponse.setIsSuccessful(true);
		serviceResponse.setResult(indexedFoldersList);
		return serviceResponse;
	}

	@RequestMapping(value = "/getListOfFoldersIndexPath", method = RequestMethod.GET)
	public LinkedList<String> getFoldersIndexPath() {
		LinkedList<String> listOfFolders = new LinkedList<>();
		File file = new File(this.foldersPathForIndexFile);
		File[] folders = file.listFiles();
		for (File f : folders) {
			listOfFolders.add(f.getAbsolutePath());
		}
		return listOfFolders;
	}

	@RequestMapping(value = "/getProgressing", method = RequestMethod.GET)
	public int getProgressing() {
		double data = 0;
		this.filesCount = this.fileIndexModel.getFileIndexUtility().getFilesCount();
		if (this.filesCount > 0) {
			data = (double) (((double) this.fileIndexModel.getFileIndexUtility().getFilesSetSize())
					/ ((double) this.filesCount));
		}
		this.progress++;
		int percentage = (int) ((data) * 100.0);
		if ((this.progress % 100) == 0)
			System.out.println("Percentage :" + percentage);
		return percentage;
	}

	@RequestMapping(value = "/getProgress", method = RequestMethod.GET)
	public int getProgress() {
		double data = 0;
		long bytesReadFromFile = this.fileIndexModel.getFileIndexUtility().getBytesReadFromFile();
		if (this.filesCount > 0) {
			data = ((double) ((double) this.fileIndexModel.getFileIndexUtility().getBytesRead())
					/ (double) bytesReadFromFile) * 100.0;
			System.out.println("Total bytes :" + bytesReadFromFile);
			System.out.println("Bytes read :" + this.fileIndexModel.getFileIndexUtility().getBytesRead());
		}
		this.progress++;
		int percentage = (int) data;
		System.out.println("Data :" + percentage);
		return percentage;
	}

	public void printStackTraceElements(Exception fiae) {
		StackTraceElement[] stackTraceElements = fiae.getStackTrace();
		for (StackTraceElement stackTraceElement : stackTraceElements) {
			System.out.println(stackTraceElement.toString());
		}
	}

	@RequestMapping(value = "/setFileIndexData", method = RequestMethod.POST)
	public ServiceResponse setFileIndexData(@RequestBody FileIndexData fileIndexData) {
		ServiceResponse serviceResponse = new ServiceResponse();
		this.logger.info("Info :Indexing started Logger test completed");
		long start = System.currentTimeMillis();
		try {
			this.fileIndexModel.getFileIndexUtility().setFilesCount(0);
			ArrayList<String> foldersList = fileIndexData.getIndexFoldersList();
			for (String folder : foldersList) {
				System.out.println("Folder to index :" + folder);
				this.filesCount = this.fileIndexModel.getFileIndexUtility().getFilesCount(new File(folder));
				this.indexedFolders.add(folder);
			}
			this.fileIndexModel.getFileIndexUtility().setFilesCount(this.filesCount);
			fileIndexModel.getFileIndexUtility().setIsStopWordsFileUploaded(fileIndexData.isFileUploaded());
			fileIndexModel.addIndexTokenMap(fileIndexData.getIndexFoldersList(), fileIndexData.getIndexFilePath());
			for (String folderToBeIndex : fileIndexData.getIndexFoldersList()) {
				this.fileIndexModel.addFolderToBeIndexAndIndexPath(folderToBeIndex, fileIndexData.getIndexFilePath());
			}
			System.out.println("After index token map");
			this.fileIndexModel.setDirectoriesForWatcher(fileIndexData.getIndexFoldersList());
			this.fileIndexModel.setMessagingTemplate(this.messagingTemplate);
			serviceResponse = new ServiceResponse();
			serviceResponse.setResult(this.getListOfFolders());
			long end = System.currentTimeMillis();
			System.out.println((end - start) / 1000);
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/getTokensList", method = RequestMethod.GET)
	public ServiceResponse getTokensList() {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setIsSuccessful(true);
			serviceResponse.setResult(fileIndexModel.getUniqueTokenStatisticsList());
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/getSummary", method = RequestMethod.GET)
	public ServiceResponse getSummary() {
		ServiceResponse serviceResponse = new ServiceResponse();
		serviceResponse.setIsSuccessful(true);
		Summary summary = new Summary();
		summary.setNumberOfFiles(this.fileIndexModel.getFileIndexUtility().getFilesSetSize());
		summary.setNumberOfFolders(this.fileIndexModel.getFileIndexUtility().getNumberOfFolders());
		summary.setNumberOfTokens(this.fileIndexModel.getNumberOfTokens());
		summary.setNumberOfArabicTokens(this.fileIndexModel.getFileIndexUtility().getArabicWordCount());
		summary.setNumberOfEnglishTokens(this.fileIndexModel.getFileIndexUtility().getEnglishWordCount());
		summary.setNumberOfHindiTokens(this.fileIndexModel.getFileIndexUtility().getHindiWordCount());
		ConcurrentHashMap<String, HashMap<String, TokenStatistics>> invertedTokenMap = this.fileIndexModel
				.getIndexTokenMap();
		int max = 0;
		int min = Integer.MAX_VALUE;
		String maxToken = "";
		String minToken = "";
		for (String indexPath : invertedTokenMap.keySet()) {
			HashMap<String, TokenStatistics> tokenStatisticsMap = invertedTokenMap.get(indexPath);
			for (String token : tokenStatisticsMap.keySet()) {
				TokenStatistics tokenStatistics = tokenStatisticsMap.get(token);
				if (token.trim().length() == 0)
					continue;
				if (tokenStatistics.getFrequencyCount() > max) {
					max = tokenStatistics.getFrequencyCount();
					maxToken = tokenStatistics.getTokenName();
				}
				if (tokenStatistics.getFrequencyCount() < min) {
					min = tokenStatistics.getFrequencyCount();
					minToken = tokenStatistics.getTokenName();
				}
			}
		}
		summary.setMaxFrequency(max);
		summary.setTokenWithMaxFrequency(maxToken);
		summary.setMinFrequency(min);
		summary.setTokenWithMinFrequency(minToken);
		serviceResponse.setResult(summary);
		return serviceResponse;
	}

	@RequestMapping(value = "/getTokensListForChart", method = RequestMethod.GET)
	public ServiceResponse getTokensListForChart() {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setIsSuccessful(true);
			LinkedList<TokenStatistics> tokenStatisticsList = fileIndexModel.getTokenStatisticsList();
			LinkedList<TokenStatistics> tokenStatisticsListClone = (LinkedList<TokenStatistics>) tokenStatisticsList
					.clone();
			LinkedList<TokenStatistics> finalTokensList = new LinkedList<>();
			if (tokenStatisticsListClone.size() != 0) {
				Collections.sort(tokenStatisticsListClone, (fs1, fs2) -> {
					return fs2.getFrequencyCount() - fs1.getFrequencyCount();
				});
				for (int i = 0; i < Math.min(20, tokenStatisticsListClone.size()); i++) {
					finalTokensList.add(tokenStatisticsListClone.get(i));
				}
			}
			serviceResponse.setResult(finalTokensList);
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/getTokensListForWordCloud", method = RequestMethod.GET)
	public ServiceResponse getTokensListForWordCloud() {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setIsSuccessful(true);
			LinkedList<TokenStatistics> tokenStatisticsList = fileIndexModel.getTokenStatisticsList();
			LinkedList<TokenStatistics> tokenStatisticsListClone = (LinkedList<TokenStatistics>) tokenStatisticsList
					.clone();
			LinkedList<TokenStatistics> finalTokensList = new LinkedList<>();
			if (tokenStatisticsListClone.size() != 0) {
				Collections.sort(tokenStatisticsListClone, (fs1, fs2) -> {
					return fs2.getFrequencyCount() - fs1.getFrequencyCount();
				});
				for (int i = 0; i < Math.min(100, tokenStatisticsListClone.size()); i++) {
					finalTokensList.add(tokenStatisticsListClone.get(i));
				}
			}
			serviceResponse.setResult(finalTokensList);
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@PostMapping("/setStopWordsFile")
	public ServiceResponse setStopWordsFile(@RequestParam("stopWordsFile") MultipartFile stopWordsFile) {
		ServiceResponse serviceResponse = null;
		try {
			File file = new File("C:\\Users\\kunal.gangaher\\Training\\StopWordsFiles\\file1.txt");
			if (file.exists())
				file.delete();
			FileUtils.writeByteArrayToFile(file, stopWordsFile.getBytes());
			serviceResponse = new ServiceResponse();
			serviceResponse.setResult("File uploaded");
		} catch (Exception e) {
			this.printStackTraceElements(e);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(e.getMessage());
			this.logger.error(e.getMessage());
			return serviceResponse;
		}
		return serviceResponse;
	}

	@RequestMapping(value = "/getFilesList", method = RequestMethod.GET)
	public ServiceResponse getFilesList() {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setResult(this.fileIndexModel.getFilesList());
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/setDate", method = RequestMethod.POST)
	public ServiceResponse setDate(@RequestBody SearchData searchData) {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setIsSuccessful(true);
			LinkedList<FileStatistics> fileStatisticsList = this.fileIndexModel.searchFiles(searchData);
			serviceResponse.setResult(fileStatisticsList);
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/getFilterFiles", method = RequestMethod.POST)
	public ServiceResponse getFilterFiles(@RequestBody String filterCategory) {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setResult(this.fileIndexModel.getFilesByFilter(filterCategory));
			serviceResponse.setIsSuccessful(true);
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/getFilterTokens", method = RequestMethod.POST)
	public ServiceResponse getFilterTokens(@RequestBody String filterCategory) {
		ServiceResponse serviceResponse = new ServiceResponse();
		try {
			serviceResponse.setResult(this.fileIndexModel.getTokensByFilter(filterCategory));
			serviceResponse.setIsSuccessful(true);
			return serviceResponse;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/getFilesOfToken", method = RequestMethod.POST)
	public ServiceResponse getFilesOfToken(@RequestBody ServiceResponse serviceResponse) {
		ServiceResponse serviceResponse1 = new ServiceResponse();
		try {
			serviceResponse1.setResult(this.fileIndexModel.getFilesByToken((String) serviceResponse.getResult()));
			serviceResponse1.setIsSuccessful(true);
			return serviceResponse1;
		} catch (FileIndexingApplicationException fiae) {
			this.printStackTraceElements(fiae);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(fiae.getMessage());
			this.logger.error(fiae.getMessage());
			return serviceResponse;
		}
	}

	@RequestMapping(value = "/addWebSocketSessionInModel", method = RequestMethod.GET)
	public ServiceResponse addWebSocketSessionInModel() {
		ServiceResponse serviceResponse = new ServiceResponse();
		this.fileIndexModel.sendData();
		serviceResponse.setIsSuccessful(true);
		serviceResponse.setResult("websocket session is saved");
		return serviceResponse;
	}

	@RequestMapping(value = "/getFileByPath", method = RequestMethod.POST)
	public ServiceResponse getFileByPath(@RequestBody String filePath) {
		ServiceResponse serviceResponse = new ServiceResponse();
		String content = "No data";
		try {
			filePath = java.net.URLDecoder.decode(filePath, StandardCharsets.UTF_8.name());
			System.out.println("file path :" + filePath);
			if (filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length()).equals("pdf")) {
				File file = new File(filePath);
				PDDocument document = PDDocument.load(file);
				PDFTextStripper pdfStripper = new PDFTextStripper();
				String text = pdfStripper.getText(document);
				content = text;
			} else {
				BufferedReader in = new BufferedReader(
						new InputStreamReader(new FileInputStream(filePath), StandardCharsets.UTF_8));
				StringBuffer stringBuffer = new StringBuffer();
				String line;
				String ls = System.getProperty("line.separator");
				while ((line = in.readLine()) != null) {
					stringBuffer.append(line);
					stringBuffer.append(ls);
				}
				if (stringBuffer.length() > 0)
					stringBuffer.deleteCharAt(stringBuffer.length() - 1);
				in.close();
				content = new String(stringBuffer);
			}
		} catch (Exception e) {
			this.printStackTraceElements(e);
			serviceResponse.setIsSuccessful(false);
			serviceResponse.setResult(e);
			this.logger.error(e.getMessage());
			return serviceResponse;
		}
		serviceResponse.setIsSuccessful(true);
		serviceResponse.setResult(content);
		return serviceResponse;
	}
}
