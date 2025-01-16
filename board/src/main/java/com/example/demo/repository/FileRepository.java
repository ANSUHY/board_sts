package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.file.FileReqDto;
import com.example.demo.dto.file.FileResDto;

@Mapper
public interface FileRepository {

	int saveFile(FileReqDto files);

	List<FileResDto> getUploadFiles(int board_no);

	FileResDto getFile(int file_no);

	int deleteFile(int file_no);

	int hitDownloadCnt(int file_no);

	int updateFile(FileReqDto files);

	int deleteFileAll(List<FileResDto> files);

	void saveImg(FileReqDto fileReqDto);

}
